# == Schema Information
#
# Table name: tv_relationships
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  tv_show_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#


class TvRelationship < ActiveRecord::Base
  attr_accessible :tv_show_id

  belongs_to :user
  belongs_to :tv_show

  validates :user_id, presence: true
  validates :tv_show_id, presence: true
end
