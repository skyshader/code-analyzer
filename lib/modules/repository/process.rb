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
		end

		def get_analyzer
			Repository::Analyzer.new @repo, @type
		end

		def get_activity
			Repository::Activity.new @repo, @type
		end

		def series
			Repository::Config.setup_repo @repo, @type
			get_activity.generate
			get_analyzer.analyze
		end

	end
end