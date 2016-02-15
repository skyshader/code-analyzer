module Repository
	class SSHKey

		attr_reader :username, :email, :host, :ssh_file
		
		def initialize username, email, host
			@username, @email, @host = username, email, host
			@ssh_file = ENV['HOME'] + "/.ssh/id_rsa_" + @username.to_s
		end

		def self.generate username, email, host
			ssh_generator = new(username, email, host)
			data = ssh_generator.initiate
			return data
		end

		def initiate
			if !@email.empty? && !@username.empty? && !@host.empty?
				return generate_ssh
			else
				raise 'Email/Username/Account not provided.'
			end
		rescue => e
			return_error_json e
		end

		private
			def generate_ssh
				if !does_key_exists?
				  ssh_keygen
				  ssh_config
				end
				public_key = get_public_key
				data = {
					'success' => true,
					'public_key' => public_key,
					'email' => @email,
					'message' => 'Generated ssh key successfully.'
				}
			end

			# generate new ssh key
			def ssh_keygen
			  ssh_cmd = "ssh-keygen -t rsa -C '#{@email}' -f '#{@ssh_file}' -N ''"
			  system(ssh_cmd)
			  if $? != 0 then
			    raise 'There was an error in generating ssh key.'
			  end
			end

			# add details to ssh config
			def ssh_config
			  config_file = get_config_file
			  File.open(config_file, 'a') do |f|
			    f.puts("##{@username} account")
			    f.puts("Host #{@host}-#{@username}")
			    f.puts("    HostName #{@host}")
			    f.puts("    User git")
			    f.puts("    IdentityFile #{@ssh_file}")
			    f.puts("    IdentitiesOnly yes")
			    f.puts("    StrictHostKeyChecking no")
			    f.puts("    UserKnownHostsFile=/dev/null")
			    f.puts("")
			  end
			end

			# if ssh config file does not exist, create one
			def get_config_file
			  config_file = ENV['HOME'] + '/.ssh/config'
			  if !File.file?(config_file)
			    create_config_cmd = "touch #{config_file}"
			    system(create_config_cmd)
			    if $? != 0 then
			      raise 'Failed to create config file.'
			    end
			  end
			  config_file
			end

			def does_key_exists?
				File.file?(@ssh_file)
			end

			def get_public_key
				File.read(@ssh_file + '.pub')
			end

			def return_error_json e
				puts e.backtrace.to_s + " --------> " + e.message
				return {
					'success' => false, 
					'public_key' => nil, 
					'email' => nil,
					'message' => e.message
				}
			end

	end
end