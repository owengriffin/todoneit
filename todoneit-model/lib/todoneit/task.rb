
module ToDoneIt
  class Task 
    include DataMapper::Resource

    property :id, Serial
    property :description, Text, :required => true
    property :due_at, DateTime
    property :completed_at, DateTime
    property :created_at, DateTime
    property :duration, Integer
    property :priority, Integer, :default => 99
    property :public, Boolean, :default => false

    belongs_to :user

    validates_length :description, :max => 50
    validates_present :public
    
    def due_at=(value)
        attribute_set(:due_at, Chronic.parse(value))
    end

    def completed_at=(value)
      attribute_set(:completed_at, Chronic.parse(value))
    end

    def complete?
      completed_at != nil and completed_at.to_time < Time.now
    end

    def self.quickadd(description)
      match = description.match(/(.*)((?:tomorrow|yesterday|today|(?:[0-9]{1,2}\/[0-9]{1,2}\/[0-9]{1,4}))(?: at [0-9]+(?:am|pm))?)(.*)/i)
      if match and match.length > 1
        task = Task.new({:description => (match[1] + (match[3].empty? ? "" : " " + match[3])).strip, :due_at => match[2]})
      else
        task = Task.new({:description => description})
      end
      return task
    end

    def self.today(attributes)
      return self.on_date(attributes, Date.today)
    end

    def self.yesterday(attributes={})
      return self.on_date(attributes, Date.yesterday)
    end

    def self.tomorrow(attributes)
      return self.on_date(attributes, Date.tomorrow)
    end

    def self.on_date(attributes, date)
      attributes[:due_at.gt] = date.to_time
      attributes[:due_at.lt] = (date + 1).to_time
      if attributes[:order] == nil
        attributes[:order]=[:completed_at.asc, :priority.asc, :due_at.desc, :created_at.desc]
      end
      return Task.all(attributes)
    end

    def self.before_date(attributes, date)
      attributes[:due_at.lt] = date.to_time
      if attributes[:order] == nil
        attributes[:order]=[:completed_at.asc, :priority.asc, :due_at.desc, :created_at.desc]
      end
      return Task.all(attributes)
    end

    def self.after_date(attributes, date)
      attributes[:due_at.gt] = (date + 1).to_time
      if attributes[:order] == nil
        attributes[:order]=[:completed_at.asc, :priority.asc, :due_at.desc, :created_at.desc]
      end
      return Task.all(attributes)
    end

    def self.destroy_all
      Task.all.each { |task|
        task.destroy!
      }
    end

    protected

    def assert_length(att, length)
      assert length === send(att).size, [att, :too_long]
    end

  end
end
