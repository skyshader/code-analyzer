module Repository
	class Process

		attr_reader :repo, :type
		
		def initialize id, type
			@type = type
			ActiveRecord::Base.connection_pool.with_connection do 
			  @repo = SupplierProjectRepo.find(id)
			end
		end

		def self.analyze id, type
			new(id, type).get_analyzer.analyze
    rescue => e
      msg = { :success => false, :message => "Failed to initiate. Please check if requested repository exists! " + e.to_s }
		end

		def self.activity id, type
			new(id, type).get_activity.generate
    rescue => e
      msg = { :success => false, :message => "Failed to initiate. Please check if requested repository exists! " + e.to_s }
		end

		def self.series id, type
			new(id, type).series
		rescue => e
      msg = { :success => false, :message => "Failed to initiate. Please check if requested repository exists! " + e.to_s }
		end

		def get_analyzer
			Repository::Analyzer.new @repo, @type
		end

		def get_activity
			Repository::Activity.new @repo, @type
		end

		def series
			Thread.new do
				begin
					get_activity.process
					get_analyzer.process
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