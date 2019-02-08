PATH=$HOME/bin:$HOME/opt/android-sdk-macosx/platform-tools:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

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

export PATH

export GOPATH=$HOME
