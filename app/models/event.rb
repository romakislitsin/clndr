class Event < ApplicationRecord
  serialize :recurring, Hash

  belongs_to :user

  validates :name, :start_time, presence: true
  validates :name, length: { maximum: 40 }

  def self.upcoming_events
    order('start_time asc').limit(5)
  end

  def recurring=(value)
    if RecurringSelect.is_valid_rule?(value)
      super(RecurringSelect.dirty_hash_to_rule(value).to_hash)
    else
      super(nil)
    end
  end

  def rule
    IceCube::Rule.from_hash recurring
  end

  def schedule(start)
    schedule = IceCube::Schedule.new(start)
    schedule.add_recurrence_rule(rule)
    schedule
  end

  def calendar_events(start)
    if recurring.empty?
      [self]
    else
      start_date = start.beginning_of_month.beginning_of_week
      end_date = start.end_of_month.end_of_week
      schedule(start_date).occurrences(end_date).map do |date|
        Event.new(id: id, name: name, start_time: date)
      end
    end
  end

end
