class TvRelationship < ActiveRecord::Base
  attr_accessible :tv_show_id

  belongs_to :user
  belongs_to :tv_show

  validates :user_id, presence: true
  validates :tv_show_id, presence: true
end
