#fpath=(~/lib/zsh ~/.zsh-completions $fpath)

############ options
# CD
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_silent

# Completion
setopt auto_menu
unsetopt list_beep
setopt menu_complete
setopt always_last_prompt
setopt auto_name_dirs
unsetopt cdable_vars
setopt auto_param_keys

# Globing
setopt extended_glob
setopt list_types
setopt magic_equal_subst

# History
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# Input/Output
setopt correct
setopt print_eight_bit
setopt sun_keyboard_hack
#setopt interactive_comments
unsetopt hup

# Prompting
setopt prompt_subst

# ZLE
unsetopt beep


############ env for zsh

ZSHFG=`expr $RANDOM % 250` # initial

setprompt() {
  prompt_vcs='%1(v|%F{green}%1v%f|)'
  gcpproject=`gcloud config get-value project 2> /dev/null`
  #export FACE='✘╹◡╹✘ '
  ZSHFG=`expr \( $ZSHFG + 1 \) % 250`
  SUSHI=$'\U1F363 '
  INVADOR=$'\U1F47E '
  PROMPT="%F{yellow}[%n@%m %2d]%f %F{$ZSHFG}${FACE}%f%(?.${SUSHI}.${INVADOR})< "
  RPROMPT="$prompt_vcs %F{cyan}<$gcpproject>%f"
}

setprompt

HISTFILE=$HOME/.zsh_history
SAVEHIST=10000
HISTSIZE=8192

if [ -z $LANG ]; then
  export LANG=ja_JP.UTF-8
fi

REPORTTIME=10

############ autoload

autoload -U compinit ; compinit
zstyle ':completion:*:default' menu select=1

autoload -U zmv

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%r)-(%b)'
zstyle ':vcs_info:*' actionformats '(%r)-(%b:%a)'

############ bindkey

bindkey -e
bindkey ' ' magic-space
bindkey "^[h" backward-kill-word

bindkey -s maek make
bindkey -s amke make
bindkey -s grpe grep

############ functions

chpwd () {
  ls -F
}

precmd () {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
  setprompt
}

# for screen
# http://www.nijino.com/ari/diary/?20020614

## ghq
# http://qiita.com/strsk/items/9151cef7e68f0746820d
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

zle -C dabbrev-complete menu-complete dabbrev-complete
bindkey '^xn'  dabbrev-complete
bindkey '^x^_'  dabbrev-menu-complete

alias xulfx="TERM=xterm-color /Applications/Firefox.app/Contents/MacOS/firefox -P xuldev -jsconsole"
alias gvim="TERM=xterm-color /Applications/MacPorts/Vim/Vim.app/Contents/MacOS/Vim -g"

alias g='git'
alias gs='git status'
alias t='git status'
alias gup="git stash; git pull --rebase origin master; git stash apply"
alias a='git add'
alias d='git diff'
alias gg='git grep'

alias -g C='`git log --oneline | peco | cut -d" " -f1`'
alias -g IN='`gcloud compute instances list | tail -n +2 | peco | awk '\''{print $1 " --zone " $2}'\''`'
alias -g GCPP='`gcloud projects list | peco | awk '\''{print $1}'\''`'

alias -g PODS='`kubectl get pods | peco | awk '\''{print $1}'\''`'
alias -g POD='`kubectl get pods | grep web-$(kubectl describe svc production | grep "^Selector:" | sed -e '\''s/.*color=\(.*\),.*/\1/'\'') | awk '\''{print $1}'\'' | tail -1 `'
alias -g KUBECON='`kubectl config current-context`'
alias -g KUBECONS='`kubectl config get-contexts -o=name | peco `'

alias gcpch='gcloud config set project GCPP'
alias kubeconch='kubectl config use-context KUBECONS'

#INS() { gcloud compute instances list --project $1 | tail -n +2 | peco; echo } #| echo awk '{ print " --zone " $2 " " $1; }' }

alias b='bundle'
alias be='bundle exec'
alias dbe='dotenv bundle exec'

alias r="rails"
alias rs="rake spec"
alias rr="rake routes"
alias fs="foreman start"

alias s="screen -U"
alias sx="screen -U -x"

alias v=vagrant
alias d=docker
alias dl='docker ps -l -q'
dshell() { docker run --entrypoint /bin/bash -t -i $1 -l }

alias w-rails="watchr ~/rails.watchr"
ffrmig() {
  git config alias.ffr >/dev/null && git ffr $1 $2 && bundle install && rake db:create db:migrate
}

alias cssh="gcloud compute ssh"

alias cf='command functions'

if which direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

source ~/.zshenv
# vim: set sw=2 sts=2 ts=2:
