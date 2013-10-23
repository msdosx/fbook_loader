#require 'sinatra/base'
#require 'koala'
#require 'active_record'
#require 'rubygems'
module App_helper
  def App_helper::save_comment(data, post)
    unless data['comments'].nil?
      unless data['comments']['data'].nil?
        data['comments']['data'].each do |data|
          comment = post.comments.new
          comment.message = data['message']
          comment.likes = data['like_count']
          comment.updated_at = data['created_at']
          comment.from = data['from']['name']
          comment.save
        end
      end
    end
  end

  def App_helper::save_post(data, post)
    post = post.new
    post.message = data['message']
    post.likes = data['likes']
    post.updated_time = data['updated_time']
    post.from = data['from']['name']
    data['picture'].present? ? (post.pic_url = data['picture']) : (post.pic_url = '0')
    data['likes'].present? ? (post.likes = data['likes']['data'].count) : (post.likes = 0)
    save_comment(data, post)
    post.save
  end

  def App_helper::first_record_time(post_model)
    if post_model.blank?
      DateTime.new(2004, 1, 1)
    else
      post_model.order('updated_time ASC').first[:updated_time]
    end
  end

  def App_helper::last_record_time(post_model)
    if post_model.blank?
      DateTime.new(2004, 1, 1)
    else
      post_model.order('updated_time ASC').last[:updated_time]
    end
  end

  def App_helper::get_access_token
    @oauth = Koala::Facebook::OAuth.new('707029629325606', 'd21f35eb8fb87de7efca405847e70ffe', 'localhost:3000')
    return Koala::Facebook::API.new(@oauth.get_app_access_token)
  end

  def App_helper::check_delta(opinion)
    post = opinion.posts
    puts (last_record_time(post).to_date - first_record_time(post).to_date)
    if (last_record_time(post).to_date - first_record_time(post).to_date) > opinion[:delta_days]
      true
    else
      false
    end
  end

  def App_helper::resolve_delta(opinion)
    post = opinion.posts
    last_post_data = last_record_time(post)-opinion[:delta_days].day
    post.where("updated_time < ?", last_post_data).destroy_all
  end

  def App_helper::first_save_to_database(opinion)
    @graph = App_helper.get_access_token
    @fbfeed = @graph.get_connections("#{opinion.nickname}", 'posts')
    @feed = @fbfeed
    loop do
      @feed.each do |data|
        save_post(data, opinion.posts)
      end
      break if check_delta(opinion)
      @feed = @fbfeed.next_page
    end
  end

  def App_helper::save_to_database(opinion)
    @graph = App_helper.get_access_token
    @fbfeed = @graph.get_connections("#{opinion.nickname}", 'feed')
    @feed = @fbfeed
    @stop_load = false
    loop do
      @feed.each do |data|
        if last_record_time(opinion.posts) == data['updated_time']
          save_post(data, opinion.posts)
        else
          @stop_load = true
        end
      end
      break if @stop_load
      @feed = @fbfeed.next_page
    end
    resolve_delta(opinion)
  end
end