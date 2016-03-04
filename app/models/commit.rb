class Commit < ActiveRecord::Base

  belongs_to :contributor
  belongs_to :branch

  def self.store_commits branch:, commits:
  	commits_data = []
  	commits.each do |commit|
  		contributor = Contributor.find_by_email(commit.author.email)
  		if !contributor.nil?
  			existing_commit = Commit.find_by(branch_id: branch.id, sha: commit.sha)
  			if !existing_commit
	  			commits_data.push({
	  				:sha => commit.sha,
	  				:date => commit.date.utc.to_date,
	  				:full_date => commit.date.utc,
	  				:additions => commit.short_stat.insertions,
	  				:deletions => commit.short_stat.deletions,
	  				:files_changed => commit.short_stat.files_changed,
	  				:contributor_id => contributor.id,
	  				:branch_id => branch.id
	  			})
	  		end
  		end
  	end
  	Rails.logger.debug commits_data.to_s
    ActiveRecord::Base.connection_pool.with_connection do 
      Commit.transaction do
        Commit.create(commits_data)
      end
    end
  end
end
