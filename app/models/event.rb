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
  validates :start_at, :date => {:before_or_equal_to => :end_at, :message => 'must be before or equal to End at' }
  validates :start_at, :name, :end_at , :presence => true
  validates :repeat, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than => REPEAT.length }

  scope :owner,  lambda { |owner|
    where(:user_id => owner) if owner=~/\d/
  }
  class << self
    def events_for_date_range(start_d, end_d, find_options = {})
      self.scoped(find_options).find(
        :all,
        :conditions => [ "((? <= #{self.end_at_field}) AND (#{self.start_at_field}< ?)) OR (events.repeat != 0)", start_d.to_date, end_d.to_date ],
        :order => "#{self.start_at_field} ASC"
      )
    end


    def create_event_strips(strip_start, strip_end, events)
      # create an inital event strip, with a nil entry for every day of the displayed days
      event_strips = [[nil] * (strip_end - strip_start + 1)]

      events.each do |event|
        delta = (event.end_at.to_date - event.start_at.to_date).to_i
        cur_date = (event.start_at.to_date > strip_start) ? event.start_at : (strip_start - delta.days)
        repeatable_events = event.generate_repeatable_events(strip_end, cur_date, delta)
        repeatable_events.each do |event|
          cur_date = event.start_at.to_date
          end_date = event.end_at.to_date
          cur_date, end_date = event.clip_range(strip_start, strip_end)
          start_range = (cur_date - strip_start).to_i
          end_range = (end_date - strip_start).to_i

          # make sure the event is within our viewing range
          if (start_range <= end_range) and (end_range >= 0)

            range = start_range..end_range

            open_strip = space_in_current_strips?(event_strips, range)

            if open_strip.nil?
              # no strips open, make a new one
              new_strip = [nil] * (strip_end - strip_start + 1)
              range.each {|r| new_strip[r] = event}
              event_strips << new_strip
            else
              # found an open strip, add this event to it
              range.each {|r| open_strip[r] = event}
            end
          end
        end
      end
      event_strips
    end

  end

  def create_repeatable_dup cur_date, delta
    dup = self.dup
    dup.id = self.id
    dup.start_at = cur_date
    dup.end_at = cur_date + delta.days
    dup
  end

  def generate_repeatable_events strip_end, cur_date, delta
    case self.repeat
      when REPEAT.index(:none) then
        [self]
      when REPEAT.index(:day) then
        generate_daily_events(strip_end, cur_date, delta)
      when REPEAT.index(:week) then
        generate_weekly_events(strip_end, cur_date, delta)
      when REPEAT.index(:month) then
        generate_monthly_events(strip_end, cur_date, delta)
      when REPEAT.index(:year) then
        generate_yearly_events(strip_end, cur_date, delta)
    end
  end

  def generate_daily_events strip_end, cur_date, delta
    events = []
    while cur_date <= strip_end do
      dup = create_repeatable_dup(cur_date, delta)
      events << dup
      cur_date = cur_date + 1.day
    end
    events
  end
  def generate_weekly_events(strip_end, cur_date, delta)
    events = []
    event_week_day = self.start_at.wday
    while cur_date <= strip_end do
      if cur_date.wday == event_week_day
        dup = create_repeatable_dup(cur_date, delta)
        events << dup
        cur_date = cur_date + 7.days
      else
        cur_date = cur_date + 1.day
      end
    end
    events
  end

  def generate_monthly_events(strip_end, cur_date, delta)
    events = []
    event_month_day = self.start_at.day
    while cur_date <= strip_end do
      if cur_date.day == event_month_day
        dup = create_repeatable_dup(cur_date, delta)
        events << dup
        cur_date = cur_date + 28.days
      else
        cur_date = cur_date + 1.day
      end
    end
    events
  end

  def generate_yearly_events(strip_end, cur_date, delta)
    events = []
    event_year_day = self.start_at.yday
    while cur_date <= strip_end do
      if cur_date.yday == event_year_day
        dup = create_repeatable_dup(cur_date, delta)
        events << dup
        break
      else
        cur_date = cur_date + 1.day
      end
    end
    events
  end


end
