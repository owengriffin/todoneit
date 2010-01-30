
module ToDoneIt
  class Task 
    include DataMapper::Resource

    property :id, Serial
    property :description, Text, :required => true
    property :due_at, DateTime
    property :completed_at, DateTime
    property :created_at, DateTime
    property :duration, Integer
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
      return Task.all(attributes)
    end

    def self.before_date(attributes, date)
      attributes[:due_at.lt] = date.to_time
      return Task.all(attributes)
    end

    def self.after_date(attributes, date)
      attributes[:due_at.gt] = (date + 1).to_time
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
