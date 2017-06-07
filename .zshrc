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

export ZSHFG=`expr $RANDOM % 250` # initial

setprompt() {
  prompt_vcs='%1(v|%F{green}%1v%f|)'
  gcpproject=`gcloud config get-value project 2> /dev/null`
  #export FACE='✘╹◡╹✘ '
  export FACE='ØωØ '
  export ZSHFG=`expr \( $ZSHFG + 1 \) % 250`
  export SUSHI=$'\U1F363 '
  export INVADOR=$'\U1F47E '
  export PROMPT="%F{yellow}$PROMPT_AWS%f[%n@%m %2d] %F{$ZSHFG}${FACE}%f%(?.${SUSHI}.${INVADOR})< "
  RPROMPT="$prompt_vcs %F{cyan}<$gcpproject>%f"
}

setprompt
export HISTFILE=$HOME/.zsh_history
export SAVEHIST=10000
export HISTSIZE=8192
if [ -z $LANG ]; then
  export LANG=ja_JP.UTF-8
fi

#export WORDCHARS='*?_.[]~=&;!#$%^(){}<>'

############ autoload

autoload -U compinit ; compinit
zstyle ':completion:*:default' menu select=1

autoload -U zmv

autoload -Uz vcs_info
#zstyle ':vcs_info:*' formats '(%r)-(%b)-(%S)'
#zstyle ':vcs_info:*' actionformats '(%r)-(%b:%a)-(%S)'
zstyle ':vcs_info:*' formats '(%r)-(%b)'
zstyle ':vcs_info:*' actionformats '(%r)-(%b:%a)'

############ bindkey

bindkey -e
bindkey ' ' magic-space
bindkey "^[h" backward-kill-word

bindkey-e-inline() {
  zle vi-insert
  local pos
  pos=$CURSOR
  zle push-line
  bindkey -e
  zle get-line
  CURSOR=$pos
}

bindkey-v-inline() {
  local pos
  pos=$CURSOR
  zle push-line
  bindkey -v
  zle get-line
  zle vi-cmd-mode
  CURSOR=$pos
}

zle -N bindkey-e-inline
bindkey -M viins "^E" bindkey-e-inline
bindkey -M vicmd "^E" bindkey-e-inline
zle -N bindkey-v-inline
bindkey "^xv" bindkey-v-inline

bindkey -s maek make
bindkey -s amke make
bindkey -s grpe grep
bindkey -s 'sv ndi' 'svn di'
bindkey -s 'sv nst' 'svn st'


#bindkey -v
#bindkey '^r' history-incremental-search-backward


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

if [ "$TERM" = "screen" ]; then
  chpwd () { echo -n "k`dirs`\\" }
  preexec() {
    # see [zsh-workers:13180]
    # http://www.zsh.org/mla/workers/2000/msg03993.html
    emulate -L zsh
    local -a cmd; cmd=(${(z)2})
    case $cmd[1] in
      fg)
        if (( $#cmd == 1 )); then
          cmd=(builtin jobs -l %+)
        else
          cmd=(builtin jobs -l $cmd[2])
        fi
      ;;
      %*)
        cmd=(builtin jobs -l $cmd[1])
      ;;
      sudo)
        if (($#cmd == 2)); then
          echo -n "k(sudo)$cmd[2]:t\\"
          return
        else
          echo -n "k$cmd[1]:t\\"
          return
        fi
      ;;
      *)
        echo -n "k$cmd[1]:t\\"
        return
      ;;
    esac

    local -A jt; jt=(${(kv)jobtexts})

    echo $cmd
    $cmd >>(read num rest
    cmd=(${(z)${(e):-\$jt$num}})
    echo -n "k$cmd[1]:t\\") 2>/dev/null
  }
  chpwd
fi

# dabbrev
HARDCOPYFILE=/tmp/${USERNAME}-screen-hardcopy
touch $HARDCOPYFILE

dabbrev-complete () {
  local reply lines=80
  screen -X eval "hardcopy -h $HARDCOPYFILE"
  reply=($(sed '/^$/d' $HARDCOPYFILE | sed '$ d' | tail -$lines))
  compadd - "${reply[@]%[*/=@|]}"
}

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

alias gcpch='gcloud config set project GCPP'

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

. ~/.zshenv
# vim: set sw=2 sts=2 ts=2:
