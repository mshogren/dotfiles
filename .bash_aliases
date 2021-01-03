bootstrap_environment() {
  sudo apt-get update && apt-get upgrade -y

  # this is the smallest set of things I can't live without
  sudo apt-get install git rsync vim-nox fzf tmux openssh-client mosh curl gnupg-agent software-properties-common

  # docker allows me to run a bunch of other things too
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io nfs-common cifs-utils
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

update_network() {
  echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf > /dev/null
  ipconfig.exe /all | grep "DNS Servers" | cut -d ":" -f 2 | grep -e '^ [0-9]' | sed 's/^/nameserver/' |tr -d '\r' | sudo tee -a /etc/resolv.conf > /dev/null
}

start_work() {
  export EDITOR=vim
  export DISPLAY=$(ipconfig.exe | grep -m 1 "IPv4 Address" | sed 's/^.*: //' | tr -d '\r' | awk '{print $1":0.0"}')
  export PATH="$HOME/.local/bin/:$HOME/.nodenv/bin/:$HOME/.nodenv/shims:$PATH"
  update_network
  start_ssh_agent
  get_tmux_session laptop dev
}

proxy_up() {
  ssh -fNTD 25564 $1
}

proxy_down() {
  ssh -TO exit $1
}

home_chrome() {
  /mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe --user-data-dir="$(wslvar USERPROFILE)\proxy-profile" --proxy-server="socks5://localhost:25564"
}

docker_run() {
  sudo docker run --rm -it alpine ash -c "$*"
}

terraform() {
  sudo docker run --rm -it -e TF_VAR_pm_pass=$PM_PASS -v $PWD:$PWD -w $PWD/terraform radekg/terraform-ansible:latest $*
}

ansible_toolset() {
  sudo docker run --rm -it -v $PWD:/$PWD -w $PWD -v /var/run/docker.sock:/var/run/docker.sock quay.io/ansible/toolset:main $*
}

molecule() {
  ansible_toolset molecule $*
}

ansible-playbook() {
  sudo docker run --rm -it -v $PWD:/$PWD -v $PWD/keys/id_rsa:/root/.ssh/id_rsa:ro -w $PWD/ansible -e ANSIBLE_HOST_KEY_CHECKING=false quay.io/ansible/toolset:main ansible-playbook $*
}
