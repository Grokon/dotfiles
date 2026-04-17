function __ssh_agent_start -d "start socat bridge to Windows SSH agent"
    set -l pidfile $HOME/.ssh/agent.env.pid
    rm -f $SSH_AUTH_SOCK
    setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork >/dev/null 2>&1 &
    echo $last_pid > $pidfile
end