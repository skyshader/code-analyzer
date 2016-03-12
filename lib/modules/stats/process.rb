module Stats

    class Process
        

        def initialize (branch:)
            @branch = branch
        end
        

        def run
            category_stats = Stats::Generator::Category.new(branch: @branch).generate
            puts "--------------------->>>>>>>>><<<<<<<<<-----------------------"
            puts category_stats
            puts "--------------------->>>>>>>>><<<<<<<<<-----------------------"
            language_stats = Stats::Generator::Language.new(branch: @branch).generate_new
            puts "--------------------->>>>>>>>><<<<<<<<<-----------------------"
            puts language_stats
            puts "--------------------->>>>>>>>><<<<<<<<<-----------------------"
        end

    end

end