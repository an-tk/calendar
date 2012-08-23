class Event < ActiveRecord::Base

  has_event_calendar

  belongs_to :user
    REPEAT =  [
    :none,
    :day,
    :week,
    :month,
    :year
  ]

  attr_accessible :name, :start_at, :end_at, :repeat
  validates :start_at,
            :date => {:after_or_equal_to => Proc.new { Date.today }, :message => 'must be today of future date'}
  validates :end_at,
            :date => {:after_or_equal_to => Proc.new { Date.today }, :message => 'must be today of future date'}
  validates :start_at, :date => {:before_or_equal_to => :end_at, :message => 'must be before or equal to End at' }
  validates :start_at, :name, :end_at , :presence => true
  validates :repeat, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than => REPEAT.length }
  validate :repeat_and_event_length

  scope :owner,  lambda { |owner|
    where(:user_id => owner) if owner=~/\d/
  }

  def self.events_for_date_range(start_d, end_d, find_options = {})
    self.scoped(find_options).find(
      :all,
      :conditions => [ "((? <= #{self.end_at_field}) AND (#{self.start_at_field}< ?)) OR (events.repeat != 0)", start_d.to_time.utc, end_d.to_time.utc ],
      :order => "#{self.start_at_field} ASC"
    )
  end

  private

  def repeat_and_event_length
    rez = case repeat
          when 1 then (end_at.to_date - start_at.to_date) == 0 ? true : false
          when 2 then (end_at.to_date - start_at.to_date) < 7 ? true : false
          when 3 then (end_at.to_date - start_at.to_date) < 30 ? true : false
          when 4 then (end_at.to_date - start_at.to_date) < 365 ? true : false
          else true
          end
    errors.add(:repeat, "of event with that length can't be so often") unless rez
  end

end
