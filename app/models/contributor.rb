class Contributor < ActiveRecord::Base

  belongs_to :repository
  
  has_many :commits

  def self.store_contributors(branch, contributors)
    contributors_data = []
  	contributors.each do |contributor|
  		total_commits = 0 
  		commits = JSON.parse(contributor.activity.by_year.to_json)
  		commits.each do |y, c|
  			total_commits += c
  		end

      existing_contributor = Contributor.find_by(branch_id: branch.id, email: contributor.email)

      if !existing_contributor
        contributors_data.push({
          :name => contributor.name,
          :email => contributor.email,
          :additions => contributor.insertions,
          :deletions => contributor.deletions,
          :commits => total_commits,
          :branch_id => branch.id
        })
      else
        ActiveRecord::Base.connection_pool.with_connection do 
          existing_contributor.update(
            additions: contributor.insertions,
            deletions: contributor.deletions,
            commits: total_commits
          )
        end
      end
  	end
    Rails.logger.debug contributors_data.to_s
    ActiveRecord::Base.connection_pool.with_connection do 
      Contributor.create(contributors_data)
    end
  end
end
