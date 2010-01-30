
class Date
  def self.today
    now = Time.new
    Date.new(now.year, now.month, now.day)
  end

  def self.tomorrow
    self.today + 1
  end

  def self.yesterday
    self.today - 1
  end

  def to_time
    Time.parse(self.strftime("%c"))
  end
end
