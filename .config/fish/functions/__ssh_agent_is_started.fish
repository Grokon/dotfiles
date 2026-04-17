function __ssh_agent_is_started -d "check if ssh agent bridge is already running"
    if not set -q SSH_AUTH_SOCK
        return 1
    end
    set -l pidfile $HOME/.ssh/agent.env.pid
    if test -f $pidfile
        set -l pid (cat $pidfile)
        if kill -0 $pid 2>/dev/null
            return 0
        end
    end
    return 1
end