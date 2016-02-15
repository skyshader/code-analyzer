module Repository
	class Analyzer

		attr_reader :repo, :type
		
		def initialize id, type
			@type = type
			ActiveRecord::Base.connection_pool.with_connection do 
			  @repo = SupplierProjectRepo.find(id)
			end
		end

		def self.analyze id, type
			new(id, type).analyze
    rescue => e
      msg = { :success => false, :message => "Failed to initiate. Please check if requested repository exists! " + e.to_s }
		end

		def analyze
			status = analyzer.begin_analysis
		end

		# determine the type of analysis on the repo
		def begin_analysis
		  Thread.new do
		    if type == 'full'
		      full_analysis
		    elsif type == 'refresh'
		      refresh_analysis
		    end
		  end
		  msg = { :success => true, :message => "Please wait while we process the repository!" }
		end

	end
end