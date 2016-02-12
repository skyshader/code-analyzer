class RepoCommit < ActiveRecord::Base
  belongs_to :repo_contributors

  def self.store_commits(repo, commits)
  	commits_data = []
  	commits.each do |commit|
  		contributor = RepoContributor.find_by_email(commit.author.email)
  		if !contributor.nil?
  			existing_commit = RepoCommit.find_by(supplier_project_repo_id: repo.id, sha: commit.sha)
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
  	RepoCommit.create(commits_data)
  end
end
