class Event < ActiveRecord::Base
  has_event_calendar

  belongs_to :user

  attr_accessible :start_at, :name, :end_at

end
