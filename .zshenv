PATH=$HOME/bin:$HOME/opt/android-sdk-macosx/platform-tools:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

if [ -d $HOME/.anyenv ] ; then
  PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
fi

# The next line updates PATH for the Google Cloud SDK.
source $HOME/google-cloud-sdk/path.zsh.inc

export PATH
