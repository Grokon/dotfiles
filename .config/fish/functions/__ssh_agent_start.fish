# https://gist.github.com/WillianTomaz/a972f544cc201d3fbc8cd1f6aeccef51
function __ssh_agent_start -d "start a new ssh agent"
    set -x SSH_AUTH_SOCK $HOME/.ssh/agent.env.sock
    setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork >/dev/null 2>&1 &
end