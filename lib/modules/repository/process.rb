module Repository
  class Process

    attr_reader :repo, :type
    
    # initialize object with defaults
    def initialize id, type
      @type = type
      ActiveRecord::Base.connection_pool.with_connection do 
        @repo = SupplierProjectRepo.find(id)
      end
    end


    # start analyzer
    def self.analyze id, type
      new(id, type).get_analyzer.analyze
    rescue => e
      msg = { :success => false, :message => "Failed to initiate. Please check if requested repository exists! " + e.to_s }
    end


    # start activity
    def self.activity id, type
      new(id, type).get_activity.generate
    rescue => e
      msg = { :success => false, :message => "Failed to initiate. Please check if requested repository exists! " + e.to_s }
    end

    
    # start processing activity and analyzer in series
    def self.series id, type
      new(id, type).series
    rescue => e
      msg = { :success => false, :message => "Failed to initiate. Please check if requested repository exists! " + e.to_s }
    end


    # return analyzer object
    def get_analyzer
      Repository::Analyzer.new @repo, @type
    end


    # return activity object
    def get_activity
      Repository::Activity.new @repo, @type
    end


    # process activity and analyzer in a thread together
    def series
      Thread.new do
        begin
          activity = get_activity
          analyzer = get_analyzer
          activity.process
          analyzer.process
        rescue => e
          Rails.logger.debug e.backtrace.to_s + " ----- " + e.to_s
        ensure
          # do something
        end
      end
      msg = { :success => true, :message => "Please wait while we process the repository!" }
    end

  end
end