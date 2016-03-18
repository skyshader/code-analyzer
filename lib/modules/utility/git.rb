module Utility

  CloneFailureError = Class.new(StandardError)
  PullFailureError = Class.new(StandardError)

  class Git

    # run clone command to get complete repo
    def clone repository
      ssh_url = repository.ssh_url.clone
      # for private repo convert ssh url to use ssh config
      if repository.is_private === 1
        ssh_url = ssh_url.insert(ssh_url.index(':'), "-" + repository.username)
      end

      system("git clone #{ssh_url} .")
      raise CloneFailureError, "Failed to clone repository" if $? != 0
      self
    end
    

    # run pull command to get fresh repo
    def pull repository
      pull_cmd = "git checkout " + repository.current_branch + " && git pull origin " + repository.current_branch;

      system(pull_cmd)
      raise PullFailureError, "Failed to pull from repository" if $? != 0
      self
    end

    def empty
      FileUtils.rm_rf(".")
      self
    end
  
  end
end