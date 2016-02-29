class Commit < ActiveRecord::Base

  belongs_to :contributor

  def self.store_commits(repo, commits)
  	commits_data = []
  	commits.each do |commit|
  		contributor = Contributor.find_by_email(commit.author.email)
  		if !contributor.nil?
  			existing_commit = Commit.find_by(brnach_id: repo.id, sha: commit.sha)
  			if !existing_commit
	  			commits_data.push({
	  				:sha => commit.sha,
	  				:date => commit.date.utc.to_date,
	  				:full_date => commit.date.utc,
	  				:additions => commit.short_stat.insertions,
	  				:deletions => commit.short_stat.deletions,
	  				:files_changed => commit.short_stat.files_changed,
	  				:repo_contributor_id => contributor.id,
	  				:supplier_project_repo_id => repo.id
	  			})
	  		end
  		end
  	end
  	Rails.logger.debug commits_data.to_s
  	Commit.create(commits_data)
  end
end
