class Post < ActiveRecord::Base
  #attr_accessible :body, :title
  has_many :comments
  acts_as_taggable_on :tags
  validates_presence_of :body, :title
end
