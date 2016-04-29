module Repository
  class Git

    # run clone command to get complete repo
    def self.clone(repo, type)
      # empty directory before clone
      repo_name = repo.repo_name.gsub(/[.]+/, '-') || repo.repo_name
      FileUtils.rm_rf(Rails.root.join('storage', 'repos', repo.username, repo.supplier_project_id.to_s, repo_name, repo.current_branch))

      clone_url = repo.clone_url.clone
      # for private repo convert ssh url to use keys
      if repo.is_private === 1
       clone_url = clone_url.insert(clone_url.index(':'), "-" + repo.username)
      end

      clone_cmd = "git clone " + clone_url + " " + repo.current_branch
      system(clone_cmd)
      if $? != 0 then
       raise "Failed to clone repository."
      end
    end
    

    # run pull command to get fresh repo
    def self.pull(repo, type)
      Dir.chdir(repo.current_branch)
      pull_cmd = "git checkout " + repo.current_branch + " && git pull origin " + repo.current_branch;
      system(pull_cmd)
      if $? != 0 then
        raise 'Not able to pull from repository.'
      end
    end
  
  end
end