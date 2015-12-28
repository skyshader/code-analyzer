class RepoStatsFilesCategory < ActiveRecord::Base
  belongs_to :code_category
  belongs_to :repo_stats_file
end
