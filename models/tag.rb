class Tag < ActiveRecord::Base
  has_many :opinions, inverse_of: :tag, dependent: :destroy
  validates :name, uniqueness: true
end
