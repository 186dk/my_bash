#   -----------------------------
#   Apps
#   -----------------------------
#alfred; command:chrome; parameters: url (without http); description: chrome open url
chrome () {
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "http://$1"
}

#alfred; command:search; parameters: query; description: chrome search query
search() {
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome "https://www.google.com/search?q=$*"
}

#alfred; command:code; parameters: path; description: vs code open folder
code () { VSCODE-CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

# Open current folder or file with phpstorm
# var: dir | file | none
ps () { [[  "$#" == "0" ]] && { pstorm . ; true; } || pstorm "$@" ;}

#   -----------------------------
#   MAKE TERMINAL BETTER
#   -----------------------------
## bash_profile info
## bash function: The semicolon (or newline) following list is required.
## func() { list; }
## or
## func() {
##}

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
export PS1="--------------------------------------------------------------------------------\n \w (\u) \n> "
export PS2="| => "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# bash aliases do accept arguments, but only at the end
# alias with argument alias cmd='_(){ echo "$@" end;unset -f _; }; _'
alias alias_argument='_(){ echo This is cmd with argument "$@" end; unset -f _; }; _'
alias alfred_help='echo "This is alfred help message"'  #alias comment
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias llr='ls -alhr'                        # List files (reverse)
alias lls='ls -alhS'                        # List files by size
alias llsr='ls -alhSr'                      # List files by size (reverse)
alias lld='ls -alht'                        # List files by date
alias lldr='ls -alhtr'                      # List files by date (reverse)
alias lldc='ls -alhtU'                      # List files by date created
alias lldcr='ls -alhtUr'                    # List files by date created (reverse)
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias f='open -a Finder ./'                 # Opens current directory in MacOS Finder
alias ~="cd ~"                              # Go Home
alias c="clear"                             # Clear
alias which='type -all'                     # Find executables
alias path='echo -e ${PATH//:/\\n}'         # Echo all executable Paths
alias show-options='shopt'                  # Show-options: display bash options settings
alias fix-stty='stty sane'                  # Restore terminal settings when screwed up
alias cic='set completion-ignore-case On'   # Make tab-completion case-insensitive
alias DT='tee ~/Desktop/terminalOut.txt'    # Pipe content to file on MacOS Desktop
alias make1mb='mkfile 1m ./1MB.dat'         # Creates a file of 1mb size (all zeros)
alias make5mb='mkfile 5m ./5MB.dat'         # Creates a file of 5mb size (all zeros)
alias make10mb='mkfile 10m ./10MB.dat'      # Creates a file of 10mb size (all zeros)
alias less='less -FSRXc'                    # Preferred 'less' implementation
alias .bp='. ~/.bash_profile'               # Source bash_profile

# Home brew update
alias brewup='brew update && brew upgrade && brew cleanup'

# Home brew update cask
alias brewup-cask='brew update && brew upgrade && brew cleanup && brew cask outdated | awk "{print $1}" | xargs brew cask reinstall && brew cask cleanup'

#Full Recursive Directory Listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# Run last command with sudo
alias sudo-last='sudo $(fc -ln -1)'

#Creates a file of given size (all zeros) and given position
#var: size (eg. 1m, 1g), path
make-file() {
    USAGE="Usage: [-options] [args ...] where options -s: size, -d: directory path"
    size='10m'
    path="./"
    _args() {
       case "$1" in
           -s)
                size=$2
                path="./$size.dat"
               ;;
           -d)
                path="$2$size.dat"
               ;;
           *)
               echo "$USAGE"
               ;;
       esac
    }

   if [  "$#" == "0" ]; then
   	    echo "Create file of 10 mb size in current directory"
   	    path="./$size.dat"
   	    mkfile "$size" "$path"
   	    return
   fi

   if [  "$#" == "1" ]; then
   	    echo "$USAGE"
   	    return
   fi

   while [[ "$#" -ge 2 ]]; do
       _args "$1" "$2"
       shift; shift
   done

   echo "create file of $size in $path"
  mkfile "$size" "$path"
}

# Clear a directory
cleardir() {
    while true; do
        read -ep 'Completely clear current directory? [y/N] ' response
        case $response in
            [Yy]* )
                bash -c 'rm -rfv ./*'
                bash -c 'rm -rfv ./.*'
                break;;
            * )
                echo 'Skipped clearing the directory...'
                break;;
        esac
    done
}

# Copy current local files to a remote server
dir-to-remote() { rsync -avz . $1; }

# Run a bash shell as another user
bash-as() { sudo -u $1 /bin/bash; }

# List disk usage of all the files in a directory (use -hr to sort on server)
disk-usage() { du -hs "$@" | sort -nr; }

# Compare the contents of 2 directories
# var: dir1, dir2
dir-diff() { diff -u <( ls "$1" | sort)  <( ls "$2" | sort ); }

#Find a command in your grep history
#var: file name
h () { history | grep "$@" ; }

# Count of non-hidden files in current dir
# var: none | path
# output: number of files
cf () {
  cd "$1" || return
  echo $(ls -1 | wc -l)
}

# Moves a file to the MacOS trash
# parameters: path
trash () { command mv "$@" ~/.Trash ; }

# Opens any file in MacOS Quicklook Preview
# parameters: file
ql () { qlmanage -p "$*" >& /dev/null; }

 # Makes new Dir and jumps inside
 # parameter: new folder name
mcd () { mkdir -p "$1" && cd "$1"; }

#kill process with given port number
#var: port
killp(){
    pid=$(lsof -i:"$1" | grep LISTEN | awk '{print $2}')
    if [[ -z "$pid" ]]
    then
      echo "No found any process with port $1"
    else
      kill -9 "$pid"
      echo "Killed process $pid"
    fi
}

#cd to path and ls
function cl() {
    DIR="$*";
        # if no DIR given, go home
        if [[ $# -lt 1 ]]; then
                DIR=$HOME;
    fi;
    builtin cd "${DIR}" && \
    # use your preferred ls command
        ls -alh
}

# Display the weather using wttr.in
weather() {
    location="$1"
    if [ -z "$location" ]; then
        location="dsm"
    fi

    curl http://wttr.in/$location?lang=en
}

# Download a website
dl-website() {
    polite=''

    if [[ $* == *--polite* ]]; then
        polite="--wait=2 --limit-rate=50K"
    fi

    wget --recursive --page-requisites --convert-links --user-agent="Mozilla" $polite "$1";
}

# mans:   Search manpage given in
#var: argument '1' for term given in argument '2'
# (case insensitive)
# displays paginated result with colored search terms and two lines surrounding each hit.
# Example: mans cd name
mans () {
        man "$1" | grep -iC2 --color=always "$2" | less
}

 # To create a ZIP archive of a folder
 # var: folder name
zipf () { zip -r "$1".zip "$1" ; }

#cd to front most window of MacOS Finder
cdf () {
        currFolderPath=$( /usr/bin/osascript <<EOT
            tell application "Finder"
                try
            set currFolder to (folder of the front window as alias)
                on error
            set currFolder to (path to desktop folder as alias)
                end try
                POSIX path of currFolder
            end tell
EOT
        )
        echo "cd to \"$currFolderPath\""
        cd "$currFolderPath" || return
}

#Extract most know archives with one command
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf "$1"     ;;
        *.tar.gz)    tar xzf "$1"     ;;
        *.bz2)       bunzip2 "$1"     ;;
        *.rar)       unrar e "$1"     ;;
        *.gz)        gunzip "$1"      ;;
        *.tar)       tar xf "$1"      ;;
        *.tbz2)      tar xjf "$1"     ;;
        *.tgz)       tar xzf "$1"     ;;
        *.zip)       unzip "$1"       ;;
        *.Z)         uncompress "$1"  ;;
        *.7z)        7z x "$1"        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# split a directory files to  sub dir with size lime
# var: $1 dir name, $2 size limit
split(){
  directory="$1"
sizelimit="$2" # in MB
sizesofar=0
dircount=1
du -s  "$directory"/* | while read -r size file
do
  if ((sizesofar + size > sizelimit))
  then
    (( dircount++ ))
    sizesofar=0
  fi
  (( sizesofar += size ))
  mkdir -p -- "$directory/sub_$dircount"
  mv -- "$file" "$directory/sub_$dircount"
done
}

# copy file to clipboard, only accept first parameter
# var: full path of file name
cpf() {
    case $1 in
        /*) file_name=$1;;
        ~/*) file_name=$1;;
        *) file_name=$PWD/$1;;
    esac

    if [[ ! -f "$file_name" ]]; then
      echo Error: "$file_name" not found!
      return
    fi

    osascript \
        -e 'on run args' \
        -e 'set the clipboard to POSIX file (first item of args)' \
        -e end \
        "$file_name"
}

# copy file content to clipboard, only accept first parameter
# var: full path of file name
cpc() {
    case $1 in
        /*) file_name=$1;;
        ~/*) file_name=$1;;
        *) file_name=$PWD/$1;;
    esac

    if [[ ! -f "$file_name" ]]; then
      echo Error: "$file_name" not found!
      return
    fi

   pbcopy < "$file_name"
}

#   ---------------------------
#   4. SEARCHING
#   ---------------------------

# Quickly search for file
# var: file name
alias qf="find . -name "

#Find file under the current directory
# var: file name
ff () { /usr/bin/find . -name "$@" ; }

#Find file whose name starts with a given string
# var: file name
ffs () { /usr/bin/find . -name "$@"'*' ; }

#Find file whose name ends with a given string
# var: file name
ffe () { /usr/bin/find . -name '*'"$@" ; }

#spotlight: Search for a file using MacOS Spotlight's metadata
# var: file name
spot () { mdfind "kMDItemDisplayName == '$@'wc"; }

#   ---------------------------
#   5. PROCESS MANAGEMENT
#   ---------------------------

#Find out the pid of a specified process
#Note that the command name can be specified via a regex
#E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#Without the 'sudo' it will only find processes of the current user
findPid () { lsof -t -c "$@" ; }

#Find memory hogs
alias memHogsTop='top -l 1 -o rsize | head -20'
#Find memory hogs
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#cpuHogs:  Find CPU hogs
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#Continual 'top' listing (every 10 seconds)
alias topForever='top -l 9999999 -s 10 -o cpu'

#Recommended 'top' invocation to minimize resources
alias ttop="top -R -F -s 10 -o rsize"

#List processes owned by my user:
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

#   ---------------------------
#   6. NETWORKING
#   ---------------------------

alias myip='curl ip.appspot.com; echo '             # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#Display useful host related information
ii() {
        echo -e "\nYou are logged on ${RED}$HOST"
        echo -e "\nAdditionnal information:$NC " ; uname -a
        echo -e "\n${RED}Users logged on:$NC " ; w -h
        echo -e "\n${RED}Current date :$NC " ; date
        echo -e "\n${RED}Machine stats :$NC " ; uptime
        echo -e "\n${RED}Current network location :$NC " ; scselect
        echo -e "\n${RED}Public facing IP Address :$NC " ;myip
        #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
        echo
}


#   ---------------------------------------
#   7. SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#Recursively delete .DS_Store files
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#Show hidden files in Finder
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'

#Hide hidden files in Finder
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

#Run a screen saver on the Desktop
alias coffee='/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

# Add a spacer to the dock
alias add-dock-spacer='defaults write com.apple.dock persistent-apps -array-add "{'tile-type'='spacer-tile';}" && killall Dock'

# Show the Dashboard
alias show-dashboard='defaults write com.apple.dashboard mcx-disabled -boolean NO && killall Dock'
# Hide the Dashboard
alias hide-dashboard='defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock'
# Enable Spotlight
alias show-spotlight='sudo mdutil -a -i on'
# Disable Spotlight
alias hide-spotlight='sudo mdutil -a -i off'
# Get history facts about the day
alias today='grep -h -d skip `date +%m/%d` /usr/share/calendar/*'
# Merge PDF files - Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

alias task-complete='say -v "Zarvox" "Task complete"'



