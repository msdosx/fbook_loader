class Opinion < ActiveRecord::Base
  belongs_to :tag, :inverse_of => :opinions
  has_many :posts, dependent: :destroy, inverse_of: :opinion
  validates :nickname, uniqueness: true
  validates :delta_days, numericality: { only_integer: true }
  validates :tag_id, presence: true
end
