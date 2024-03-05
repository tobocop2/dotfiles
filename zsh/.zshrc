# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_THEME="essembeh"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    brew
    yarn
    docker
    docker-compose
    adb
    npm
    aws
    nvm
)

source $ZSH/oh-my-zsh.sh

# Key beindings
# Enable vi mode
bindkey -v
# Usefeul emacs key bindings retained with vi mode
bindkey '^k' kill-line
bindkey '^w' backward-kill-word
bindkey '^f' forward-word
bindkey '^o' backward-word
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^r' history-incremental-search-backward
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Kills delay when entering vi mode
export KEYTIMEOUT=1

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# Set vim to be default editor

# # Change default LS_COLORS colors for ls and tab completion
# # https://github.com/trapd00r/LS_COLORS
eval $(gdircolors -b $HOME/.dircolors)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

server_cp() {
   scp $1 tobias:

   web_home=/data/https-portal/vhosts/perelste.in

   filename=`basename $1`

   ssh -t tobias "chmod 777 $filename; sudo cp -f $filename $web_home"

   printf "File can be found at:\nhttp://perelste.in/$filename\n"
}

github_token() {
  local github_token=`cat ~/.config/gh/hosts.yml | yq '.[].oauth_token' | sed 's/"//g'`
  echo $github_token
  echo $github_token | pbcopy
}

screencapture(){
    vlc \
        screen://\
        -I dummy --dummy-quiet \
        --screen-left=0 --screen-top=0 --screen-width=1280 --screen-height=720 \
        --no-video :screen-fps=15 :screen-caching=300 \
        --sout "#transcode{vcodec=h264,vb=800,fps=5,scale=1,acodec=none}:duplicate{dst=std{access=file,mux=mp4,dst='$HOME/Desktop/Screencapture $(date +%Y-%m-%d) at $(date +%H.%M.%S).mp4'}}"
}

kill-suspended-jobs() {
  _get_jobs() {
    jobs -l | cut -d " " -f1 | grep -Eo "\d+"
  }
  for job in `_get_jobs`; do kill -9 %$job; done
}

kill-warp() {
  sudo launchctl unload -w  /Library/LaunchDaemons/com.cloudflare.1dot1dot1dot1.macos.warp.daemon.plist
  sudo kill -9 `ps -ax | grep -i warp | grep -Ev "grep"  | awk -F ' ' '{print $1}'`
}

load-warpd() {
  sudo launchctl enable gui/501/com.cloudflare.1dot1dot1dot1.macos.warp.daemon
  sudo launchctl load  -w /Library/LaunchDaemons/com.cloudflare.1dot1dot1dot1.macos.warp.daemon.plist
  sudo launchctl start com.cloudflare.1dot1dot1dot1.macos.warp.daemon
}

ecr-login() {
  aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 008634694210.dkr.ecr.us-east-2.amazonaws.com
}

json-to-ini() {
  
  # Check if jq is installed
  if ! command -v jq &> /dev/null
  then
      echo "jq could not be found. Please install jq to run this script."
      exit 1
  fi
  
  # Check if input file is provided
  if [ "$#" -ne 1 ]; then
      echo "Usage: $0 <json-file>"
      exit 1
  fi
  
  json_file=$1
  ini_file="${json_file%.json}.ini"
  
  # Convert JSON to INI format
  jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" "$json_file" > "$ini_file"
  
  echo "INI file created at $ini_file"


}

# act () { docker run -it --rm --platform=linux/amd64 -v "$PWD:/workspace" -v /var/run/docker.sock:/var/run/docker.sock -w /workspace act-image "$@" }

alias ssh='TERM=screen-256color ssh'
alias node='node --experimental-repl-await'
alias ks='kill-suspended-jobs'
alias firefox='open -a Firefox'
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export WEECHAT_HOME=~/.weechat

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export EDITOR=nvim
alias vim='nvim'
alias vi='nvim'


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

source /Users/tobias/projects/luminopia-github/developer-tools/db-utils.bash

export DOCKER_DEFAULT_PLATFORM=linux/amd64

