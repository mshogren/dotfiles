bootstrap_environment() {
  sudo apt-get update && apt-get upgrade -y

  # this is the smallest set of things I can't live without
  sudo apt-get install git rsync vim-nox fzf tmux openssh-client mosh curl
}

start_ssh_agent() {
  if [ -z "$(pgrep ssh-agent)" ]; then
    rm -rf /tmp/ssh-*
    eval $(ssh-agent -s) > /dev/null
  else
    export SSH_AGENT_PID=$(pgrep ssh-agent)
    export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
  fi

  if [ "$(ssh-add -l)" == "The agent has no identities." ]; then
    ssh-add
  fi
}

get_tmux_session() {
  tmux has-session -t $1 2>/dev/null
  if [ "$?" -eq 1 ] ; then
    # Use -d to allow the rest of the function to run
    tmux new-session -d -s $1 -n Main
    if [ -n $2 ] ; then
      # -d to prevent current window from changing
      tmux new-window -d -n $2 mosh $2
    fi
    # -d to detach any other client (which there shouldn't be,
    # since you just created the session).
    tmux attach-session -d -t $1
  else
    tmux attach-session -d -t $1
  fi
}

start_work() {
  export EDITOR=vim
  export DISPLAY=:0.0
  start_ssh_agent
  get_tmux_session laptop dev
}

