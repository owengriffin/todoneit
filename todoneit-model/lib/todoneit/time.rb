class Time
  def self.today
    Date.today.to_time
  end
  def self.tomorrow
    Date.tomorrow.to_time
  end
  def self.yesterday
    Date.yesterday.to_time
  end
end
