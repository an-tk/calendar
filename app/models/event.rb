class Event < ActiveRecord::Base
  has_event_calendar
  belongs_to :user

  attr_accessible :start_at, :name, :end_at
  validates :start_at,
            :date => {:after_or_equal_to => Proc.new { Date.today }, :message => 'must be today of future date'}
  validates :end_at,
            :date => {:after_or_equal_to => Proc.new { Date.today }, :message => 'must be today of future date'}
  validates :start_at, :date => {:before_or_equal_to => :end_at, :message => 'must be before or equal to End at' }
  validates :start_at, :name, :end_at , :presence => true

  scope :owner,  lambda { |owner|
    where(:user_id => owner) if owner=~/\d/
  }

end
