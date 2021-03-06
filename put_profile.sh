#!/usr/bin/env bash

# !! DOTFILE OVERWRITE !!

pathto=$(cd $(dirname $0) && pwd)

switch_env(){
  if [[ "$(uname)" = 'Darwin' ]]; then
    echo $2
  elif [[ "$(uname -r)" =~ ^.*-Microsoft$ ]]; then
    echo $3
  elif [[ "$(uname)" = 'Linux' ]]; then
    echo $1
  elif [[ "$(uname)" = 'FreeBSD' ]]; then
    echo $4
  fi
}

remove_file_or_check_link(){
  if [ -L $1 ]; then
    echo "$1 has already deployed"
    return 1
  elif [ -e $1 ]; then
    rm $1 -rf
  fi
  return 0
}

deploylink(){
  if [ ! -e $pathto/$1 ];then
    echo "$pathto/$1 not exists"
    return 1
  fi
  if remove_file_or_check_link $2/$(basename $1);then
    ln -s $pathto/$1 $2/$(basename $1)
    echo "$(basename $1) was deployed to $2/"
    return 0
  else
    return 1
  fi
}

q_deploylink(){
  echo -n "deploy $(basename $1)? [y/n]: "; read input
  if [[ "$input" = "yes" || "$input" = "y" ]]; then
    return deploylink $@
  else
    return 1
  fi
}

# check tmux version
if which tmux > /dev/null 2>&1; then
  if [ $(echo "$(tmux -V | awk '{print $2}') >= 2.4" | bc) == 1 ]; then
    deploylink tmux-2.4/.tmux.conf $HOME
  else
    deploylink tmux-before2.4/.tmux.conf $HOME
  fi
fi

# deploy dotfiles' symbolic link to $HOME
deploylink .inputrc $HOME
deploylink .gitconfig $HOME
deploylink .gitignore $HOME
deploylink .tmux.conf $HOME
deploylink .vim $HOME
deploylink .shell $HOME
deploylink .gdbinit $HOME
deploylink .config $HOME
deploylink .vrapperrc $HOME
deploylink .latexmkrc $HOME

# link config on environment
deploylink .config/memo/$(switch_env linux mac linux)/config.toml $pathto/.config/memo

# vim-undofile folder
if [ ! -d ~/.vimundo ]; then
  mkdir ~/.vimundo
  echo "mkdir ~/.vimundo"
fi

# let .bashrc read .bashrc_self
grep .bashrc_self ~/.bash_profile 
if ! grep .bashrc_self ~/.bash_profile > /dev/null 2>&1; then
  echo "if [ -f ~/.bashrc_self ]; then source ~/.bashrc_self; fi" >> ~/.bash_profile
fi
. ~/.bash_profile

# Only root user
if [ "$(whoami)" = "root" ]; then

  # deploy systemd service file (for Linux)
  if [ "$(switch_env linux)" = "linux" ]; then
    for service in $(ls $pathto/.services/); do
      if q_deploylink .services/$service /etc/systemd/system; then
        systemctl enable $pathto/.services/$service
      fi
    done
    systemctl daemon-reload
  fi

fi
