function __ssh_agent_is_started -d "check if ssh agent is already started"
	if set -q SSH_AUTH_SOCK
		# ssh-add returns:
        #   0 = agent running, has keys
        #   1 = agent running, no keys
        #   2 = agent not running
		ssh-add -l > /dev/null 2>&1 || [ $status -eq 1 ]
	else
		false
	end
end