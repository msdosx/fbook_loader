class App < Sinatra::Base
  helpers App_helper
  loop do
    Tag.all.each do |tag|
      tag.opinions.each do |opinion|
        if opinion.posts.blank?
          App_helper.first_save_to_database(opinion)
        else
          App_helper.save_to_database(opinion)
        end
      end
    end
    sleep 20.minutes
  end
  run! if App == $0
end
