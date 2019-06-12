# avoid /etc/zprofile in login shell
setopt no_global_rcs

# system-wide environment settings for zsh(1)
if [ -x /usr/libexec/path_helper ]; then
   eval `/usr/libexec/path_helper -s`
fi

PATH=$HOME/bin:$PATH

if [ -f /usr/local/share/kube-ps1.sh ]; then
  source /usr/local/share/kube-ps1.sh
fi

if [ -x /usr/local/bin/rbenv ]; then
  eval "$(/usr/local/bin/rbenv init - )"
fi

if [ -d $HOME/.anyenv ] ; then
  PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
fi

if [ -d $HOME/google-cloud-sdk ] ; then
  source $HOME/google-cloud-sdk/path.zsh.inc
fi

if [ -f $HOME/.environments ]; then
  source $HOME/.environments
fi

if [ -f $HOME/.environments.local ]; then
  source $HOME/.environments.local
fi

PATH="/usr/local/opt/mysql@5.7/bin:$PATH"

export PATH

export GOPATH=$HOME
