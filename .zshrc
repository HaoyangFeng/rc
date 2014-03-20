################## TODO ################## 
# Coloriser
# Completing running task beeps terminal


################## Keymap ################## 
# a : Awk
# b : 
# c : Cat
# d : Directory
# e : Echo - TODO maybe change to Edit and free up v, also consider expanding o
# f : Find
# g : Grep
# h : Help
# i : 
# j : 
# k
# l : List
#*m : MAP
# n
# o : Open
# p
# q
# r
# s : Sed
# t
# u
#*v : Vi - Vue
# w
# x
# y
# z
# td : Todo


################## General OS ################## 

# Environment variables {{{

export REBEL_HOME="/home/haoyang.feng/.IdeaIC11/config/plugins/jr-ide-idea/lib/jrebel"
export MD=/KIWI/datasets/GP/Riegelsville/MAP
export KIWISEA="$MD:/kiwi/progs:/kiwi/sql:/kiwi/scp:/kiwi/bin:/kiwi/etc:/kiwi/work"
export DS="/KIWI/datasets"
export SV="/KIWI/java/sites"
export CM="/KIWI/java/comms"
export TC="/KIWI/java/tomcat"
export WK="/KIWI/java/work"
export IN="/home/haoyang.feng/installers"
export SVN="svn+ssh://corona2/svn/mapjava"
export MSVN="svn+ssh://corona2/svn/map"
export JSVN="svn+ssh://corona2/svn/mapjava"
export WORK="/KIWI/work"
export KWSQL_USER=test
export KWSQL_PASS=test
export MODE=VUE
export TMP="/home/haoyang.feng/Desktop/work/.tmp"
export GREP_COLOR=FULL
export PRINTER=Canon_LBP6780_3580_UFR_II

# }}}

# Aliases {{{

alias ja='mvn clean install'
alias jats='mvn clean install -Dmaven.test.skip'
alias pe='mvn eclipse:eclipse'
alias dp='deploy'
alias jr='jrebel'
alias pls='sudo $(!!)'
alias dp='deploy'
alias tst='maven build-all || cat target/test-reports/*.txt'

alias bc='bc -l'

aliasgrep() {
  if [ "$GREP_COLOR" = "FULL" ]; then
    alias grep='grep -E --color=always'
  else
    alias grep='grep -E --color=none'
  fi
}

aliasgrepnocolor() {
  crc GREP_COLOR NONE
  aliasgrep
  rrc
}

aliasgrepfullcolor() {
  crc GREP_COLOR FULL
  aliasgrep
  rrc
}

aliasgrep

# }}}

# Configuration Files {{{

export ZSHRC=~/rc/.zshrc

# Re-source Zsh
rrc() {
  source ~/.zshrc
}

# Configure Zsh
rc() {
  echo ":set foldmethod=marker" > $TMP/rc.vi
  echo "zR/^$1\(" > $TMP/rc1.vi
  if [ "$1" = "" ]; then
    vi ~/.zshrc -s "$TMP/rc.vi"
  else
    vi ~/.zshrc -s "$TMP/rc1.vi"
  fi
  source ~/.zshrc
}

# Commit and push configuration files
circ() {
  pushd .
  cd ~/rc
  ci $1
  git push origin master
  popd
}

# Help: Keyword function help
# h func : List all function documentation with the keyword func
h() {
  pattern="#.*$(kw $@)"
  cat ~/.zshrc | grep -i $pattern  -C1 | grep -v "\(\)" | grep -v "^$" | grep -v "\{\{\{"
}

# Help: Full precise function help
# fh func : Show the documentation and code of function func
fh() {
  cat ~/.zshrc | grep "^$1\(" -B2  | head -2
  which $1
}

# TODO seem to erase MAP_REV_SOURCE to MAP_REV
# Change variable in Zsh source
crc() {
  rep=$(echo $2 | esr)
  sed -i -r 's/^export '$1'=.*$/export '$1'='$rep'/gi' $ZSHRC
  rrc
}

# Configure Vi
vrc() {
  vi ~/.vimrc
}

# Configure Tmux
trc() {
  vi ~/.tmux.conf
  tmux source-file ~/.tmux.conf
}

# Configure Mutt
mrc() {
  vi ~/.muttrc
}

# Re-source Xmodmap
keyon() {
  xmodmap ~/.Xmodmap
}

# }}}

# Utility functions {{{

# $3 node index from the right, 0 is leaf
rnode() {
    echo $1 | cut -d $2 -f $(echo "$(echo $1 | grep -o $2 | wc -l) + 1 - $3" | bc)
}

# Print previous command
pc() {
  fc -nl 1 | grep -v "^[ef]?[0-9]*$" | tail -1
}

# Run previous command
rpc() {
  eval $(pc)
}

# Produce a numbered menu from the ouput of a command and return the selected line
# $@ the command to execute
menu() {
  eval $@ | nl
  read n
  menu=$(eval $@ | sed -n "$n"p | decolor)
}

# Text Manipulation: Keyword
# kw one two three : Outputs "one.*two.*three"
kw() {
  echo $@ | s "s/ /.*/g"
}

# Text Manipulation: Full PascalCase Abbreviation
# Form a regex for full PascalCase abbreviation
ab() {
  var=`echo $1 | sed 's/./&[^A-Z]*/g'`
  echo $var
}

# Form a regex for partial abbreviation
pab() {
  var=`echo $1 | sed 's/./&.*/g'`
  echo $var
}

esr() {
 sed -e 's/[\/&]/\\&/g'
}

esk() {
  sed -e 's/[]\/()$*.^|[]/\\&/g'
}

# Start second-level cron job
scron() {
  if [ "$2" = "" ]; then
    SLEEP_TIME=1;
  else
    SLEEP_TIME=$2
  fi
  while; do
    eval3 $1
    clear;
    cat3
    sleep $SLEEP_TIME;
  done 
}

# Execute a command with the arguments from a file and open the output in vi
# $1 command to execute
# $2 file that contains all the arguments
# exe sqle queries : Execute sqle with every line in the file "queries" as argument
exe() {
  #IFS="
  #"
  while read args; do
    echo $1 $args
    $1 $args
    echo
  done < $2
}

# Remove line numbers
unl() {
  cut -f2-
}

# Date : Timestamp
# timestamp : Show current time stamp in nano second
timestamp() {
  date +%s%N
}

# }}}

# System functions {{{

# Clear Screen
cs() {
  clear
}

clip() {
  xclip -sel clip
}

decolor() {
  sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" $@
}

eval3() {
  eval $@ &> $TMP/stdbuf/$$
  decolor $TMP/stdbuf/$$ > $TMP/stdbuf/$$.nocolor
  cat3
}

cat3() {
  cat $TMP/stdbuf/$$
}

cat3nc() {
  cat $TMP/stdbuf/$$.nocolor
}

catl3() {
  catl $TMP/stdbuf/$$ $1
}

catl3nc() {
  catl $TMP/stdbuf/$$.nocolor $1
}

# }}}

# Terminal {{{

alias tmo='tmux new -s'
alias tmn='tmux new -ds'
alias tmk='tmux kill-session -t'
alias tma='tmux attach -t'
alias tmr='tmux attach -d -t'
alias tms='tmux switch -t'
alias tml='tmux ls'
alias tmd='tmux detach'
alias tmw='tmux neww -t'
alias tmg='tmux selectw -t'
alias tmt='tmux send -t'

source ~/.bin/tmuxinator.zsh

b() {
 clear
 figlet -f big -w 160 $@
}

std() {

  rrc

  if [ "$1" = "" ]; then
    tmux kill-server
  fi

  BASE="$HOME"
  cd $BASE

  if [[ "$1" = "" || "$1" = "1" ]]; then
    tmk Personal
    tmn Personal -n mutt
    tmw Personal:2 -n irssi
    tmw Personal:3 -n elinks
    tmw Personal:4 -n rc
    tmw Personal:5 -n misc
    tmw Personal:6 -n top
    tmw Personal:7 -n sqlp
    tmw Personal:8 -n jsv
    tmw Personal:9 -n jlg
    tmw Personal:10 -n todo
    tmt Personal:1 "mutt" C-m
    tmt Personal:2 "irssi" C-m
    tmt Personal:3 "elinks" C-m
#   tmt Personal:4 "rc" C-m
#   tmt Personal:5 "work" C-m
    tmt Personal:6 "top" C-m
    tmt Personal:7 "scron sqlp" C-m
    tmt Personal:8 "ss" C-M
    tmt Personal:9 "sv;lg" C-m
    tmt Personal:10 "note todo" C-m
    tmg Personal:1
  fi

  if [[ "$1" = "" || "$1" = "2" ]]; then
    tmk Primary
    tmn Primary -n work
    tmw Primary:2 -n mpj
    tmw Primary:3 -n map
    tmw Primary:4 -n map
    tmw Primary:5 -n jpj
    tmw Primary:6 -n sqlman
    tmw Primary:7 -n sqlcsc
    tmw Primary:8 -n sqlt
    tmw Primary:9 -n note
    tmt Primary:1 "work" C-m
    tmt Primary:2 "m;pj" C-m
    tmt Primary:3 "xl" C-m
    tmt Primary:4 "csc" C-m
    tmt Primary:5 "j;pj" C-m
    tmt Primary:6 "sql man" C-m
    tmt Primary:7 "sql csc" C-m
    tmt Primary:8 "sqlt" C-m
    tmt Primary:9 "note" C-m
    tmg Primary:1
  fi

  if [[ "$1" = "" || "$1" = "3" ]]; then
    tmk Secondary
    tmn Secondary -n Secondary
  fi

  if [[ "$1" = "" || "$1" = "4" ]]; then
    tmk Browsing
    tmn Browsing -n work
    tmw Browsing:2 -n work2
    tmw Browsing:3 -n mpj
    tmw Browsing:4 -n map
    tmw Browsing:5 -n jpj
    tmw Browsing:6 -n sqlman
    tmw Browsing:7 -n sqlcsc
    tmw Browsing:8 -n sqlt
    tmt Browsing:1 "work" C-m
    tmt Browsing:2 "work" C-m
    tmt Browsing:3 "m;pj" C-m
    tmt Browsing:4 "csc" C-m
    tmt Browsing:5 "j;pj" C-m
    tmt Browsing:6 "sql man" C-m
    tmt Browsing:7 "sql csc" C-m
    tmt Browsing:8 "sqlt" C-m
    tmg Browsing:1
  fi

  tma Personal
}

# }}}

# {{{ Irssi

dh() {
  dehilight
}

clog() {
  if [ "$1" = "" ]; then
    #pn "for file in $(find ~/.irclogs -type f); do ls -l $file; done | grep $(date +%F) | cut -d \" \" -f 8 | grep \"\/[^\/]*@\" | nl"
    pn clog "for file in $\(ls\); do echo $file; done"
  else
    aliasgrepnocolor
    o $(for file in $(find ~/.irclogs -type f); do ls -l $file; done | grep $(date +%F) | grep $1 | cut -d " " -f 8 | grep "\/[^\/]*@")
    aliasgrepfullcolor
  fi
}

# }}}

# Echo {{{

# Echo
# e text : Echo "text"
e() {
  echo $@
}

# Eval Echo
# ee {1..3}' r' : Evaluate "1 r" "2 r" "3 r"
eve() {
  eval $(e $@)
}

# }}}

# Sed {{{

# Sed Utility: Sed
# s : Sed
s() {
  sed $@
}

# Sed Utility: inline
# si : Sed inline
si() {
  sed -i $@
}

# }}}

# Grep {{{

g() {
  grep -i $@
}

# Grep Utility: Reverse grep
# gv a : Reverse grep "a"
gv() {
  g -v $@
}

gr() {
  if [ "$2" = "" ]; then
    eval $(echo "grep -irnI $1 .") | nl
  else
    eval $(echo "grep -irnI --include=\"$2\" $1 .") | nl
  fi
}

gs() {
  if [ "$2" = "" ]; then
    pn gs "grep -irnI --exclude-dir={.svn,testsrc,target,.classpath} --exclude=\"*.sql\" \"$1\" ."
  else
    pn gs "grep -irnI --exclude-dir={.svn,testsrc,target,.classpath} --include=\"*$2*\" \"$1\" ."
  fi
}

gsa() {
  if [ "$2" = "" ]; then
    eval $(echo "grep -irnI --exclude-dir={.svn,testsrc,target,.classpath,inf} \"$1\" .") | nl
  else
    eval $(echo "grep -irnI --exclude-dir={.svn,testsrc,target,.classpath,inf} --include=\"*$2*\" \"$1\" .") | nl
  fi
}

gsp() {
  eval $(echo "grep -irnI --exclude-dir={.svn,testsrc,inf} $@ .")
}

gf() {
  eval $(echo "grep \"^[^C].*($1)\" -rin . --include=\"*.f\" -B9999 | grep \"\s\sprogram\s|\s\sfunction\s|\s\ssubroutine\s|^[^C].*($1)\" -i | grep \"^[^C].*($1)\" -B1 -i | grep -v \"\-\-\"") | nl
}

gjf() {
  gs "(private|protected|public)[^=]*$1[^\(]*;"
}

WHC=$TMP/wh/current
WHH=$TMP/wh/history

wh() {
  if [ ! -d $WHH ]; then
    mkdir -p $WHH
  fi
  if [ -f $WHC ]; then
    mv $WHC $WHH/$(ls -1 $WHH | wc -l)
  fi
  $(whs $1) > WHC
  cat $TMP/wh/current | nl
}

whs() {
  gs "private ($1|List<$1>) " | sed "s/^.*\///" | sed "s/\..*List.*$/ */" | cut -d "." -f 1
}

wha() {
  sed -n "$1"p $TMP/wh/current | cut -d " " -f 2
}

# }}}

# Find {{{

# Find by full file name
f() {
  find . -regex ".*/$1" ${@:2} | nl
}

# Find by partial name
fp() {
  f ".*"$1"[^\/]*" ${@:2}
}

# Find source by full name
fs() {
  f $1 -type f ${@:2} ! -path "*/testsrc/*" ! -path "*/classes/*" ! -path "*/target/*" ! -path "*/.svn/*"
}

# Find source by partial name
fps() {
  fp $1 -type f ${@:2} ! -path "*/testsrc/*" ! -path "*/classes/*" ! -path "*/target/*" ! -path "*/.svn/*"
}

# Find source by full PascalCase abbreviated name
fa() {
  fs $(ab $1)
}

# Find source by partial PascalCase abbreviated name
fpa() {
  fps $(pab $1)
}

# Find the most recently modified files
lt() {
  ls -lt | head -10 | tail -9 | nl
}

# }}}

# File {{{

# Tar

z() {
  tar cvfz $1.tar.gz *$1*
}

zr() {
  tar cvfz $1.tar.gz $1
  rm -rf $1
}

uz() {
  if [[ $1 = *.tar.gz ]]; then
    tar xvfz $1
  elif [[ $1 = *.tar ]]; then
    tar xvf $1
  fi
  rm $1
}

# Back Up : Back Up
bu() {
  if [ "$2" = "" ]; then
    cp -r $1 $1.bu
  else
    cp -r $1 $1.bu.$2
  fi
}

# Back Up : Back Up Remove
bur() {
  mv $1 $1.bu
}

# TODO pbr
# Back Up : Put Back
pb() {
  r $1
  if [ $2 = "" ]; then
    cp -r $1.bu $1
  else
    cp -r $1.bu.$2 $1
  fi
}

# TODO
# Directory history
#d() {
#  pn d "dirs -v | head -10"
#}

# Tree
t() {
  tree -f --noreport $@ | nl
}

tl() {
  tree -f --noreport -L $1 ${@:2} | nl
}

for ((i = 0; i < 100; i++)); do
  alias t$i="tl $i"
done

# Tree diff
tdiff() {
  tree -f $1 | sed "s/$1/\./g" > $TMP/tdiff.1
  tree -f $2 | sed "s/$2/\./g" > $TMP/tdiff.2
  vimdiff $TMP/tdiff.1 $TMP/tdiff.2
  rm $TMP/tdiff.1
  rm $TMP/tdiff.2
}

function command_not_found_handler() {
  cs
  echo I don\'t understand: $@
}

# Go to into directory or open file in Vi
o() {
  cs
  if [ -d $1 ]; then
    builtin cd $1
    l
  elif [ -x $1 ]; then
    $1
  elif [ -f $1 ]; then
    if [ "$2" = "" ]; then
      vi $1
    else
      vi +$2 $1
    fi
  fi
}

# List Utility : List
# l : List files in full or brief depending on total number of files
l() {
  if [[ $(lf | wc -l) -lt 30 ]]; then
    lf
  else
    lb
  fi
}

# List Utility: List FlL
# lf : List almost all files
lf() {
  pn l "ls -Alht --color $@ | head -30"
}

# List Utility: List Brief
# lb : List files in brief
lb() {
  pn l "ls -lht --color $@ | head -30"
}

export TRASH=~/.Trash

# Remove Utility: Remove
# r file : Move file to trash
r() {
  if [[ -a $1 ]]; then
    trash=$TRASH/$(timestamp)
    md $trash
    mv $@ $trash
  fi
}

# Remove Utility: Remove list
# rl : List files in trash
rl() {
  l ~/.Trash
}

# Cat Utility: Cat line
# catl file 1 : Cat file line 1
catl() {
  sed -n "$2"p $1
}

# Write Utility: Insert line
# ins file "text" : Insert "text" into line 1 of file
ins() {
  sed -i "1i$2" $1
}

# Directory : Make Directory
md() {
  mkdir -p $@
}

# Directory: Directory
# d ex : Move to directory "ex" even if it doesn't exist
d() {
  if [ ! -d $1 ]; then
    mkdir -p $@
  fi
  o $1
}

# }}}

# Vi {{{

# Find by full name and open with Vi
v() {
  if [ "$2" = "" ]; then
    vi $(f $1 | unl)
  else
    vi +$2 $(f $1 | unl)
  fi
}

# Find by partial name and open with Vi
vp() {
  vi $(fp $1 | unl)
}

# Find source by full name and open with Vi
vs() {
  vi $(fs $1 | unl)
}

# Find source by partial name and open with Vi
vps() {
  vi $(fps $1 | unl)
}

# Find source by full PascalCase abbreviated name and open with Vi
va() {
  vi $(fa $1 | awk '{print $2}')
}

# Find source by partial PascalCase abbreviated name and open with Vi
vpa() {
  vi $(fpa $1 | awk '{print $2}')
}

# Find executable in PATH and open with Vi
vw() {
  vi $(which $1)
}

# Vim: Vim Diff
# vd a b : Vim-diff file a and file b
vd() {
  vimdiff $@
}

# }}}

# Numbered Shortcut {{{

pn() {
  echo $1 > $TMP/stdbuf/$$.cmd
  eval3 $2 | nl
}

pnc() {
  cat $TMP/stdbuf/$$.cmd
}

fn() {
  catl3nc $1 | xargs ${@:2}
}

# Numbered shortcut: Run numbered shortcut
# rn 2: Run the numbered shortcut for line 2 of the output of the previous command
rn() {
  n=$(catl3nc $1)
  case $(pnc) in
      d) cd +$1;;
      t) o $(rpc | sed -n "$1"p | cut -d "-" -f 3 | cut -d " " -f 2);;
      note) o $(rpc | sed -n "$1"p | cut -d "-" -f 3 | cut -d " " -f 2);;
      l) case $2 in 
             r) r "$(echo $n | awk '{print $8}')";;
             "") o "$(echo $n | awk '{print $8}')";;
             *) $2 "$(echo $n | awk '{print $8}')" ${@:3};;
         esac;;
      lt) o $(echo $n | awk '{print $8}');;
      f) o $n;;
      fa) o $n;;
      fp) o $n;;
      fps) o $n;;
      fpa) o $n;;
      tca) vimdiff $n $PJ_ROOT/$MB/$n;;
      g) o $(echo $n | cut -d ":" -f 1) $(echo $n | cut -d ":" -f 2);;
      gs) o $(echo $n | cut -d ":" -f 1) $(echo $n | cut -d ":" -f 2);;
      gf) if echo $n | grep -q "^[^ ]*:"; then delim=:; else delim=-; fi; o $(echo $n | cut -d $delim -f 1) $(echo $n | cut -d $delim -f 2);;
      wh) wh $(echo $n | cut -d " " -f 1);;
      clog) o $n;;

      *) echo Done nothing.;;
  esac
}

for ((i = 0; i < 10000; i++)); do
  alias $i="rn $i"
done

for ((i = 0; i < 10000; i++)); do
  alias f$i="fn $i"
done

# }}}


################## Java Development ################## 

# Java Revision {{{

export JPJ_ROOT="/home/haoyang.feng/projects"
export JPJ=mes-7.90.1
export JHD=mes-8.0
export JMB=mes-8.0
export SITE_NAME=$(echo $JPJ | sed "s/[-,\.]/_/g")
export SQL_NAME=$SITE_NAME

# }}}

# Java Navigation {{{

export PJ="/home/haoyang.feng/projects"

# Go to java service directory
sv() {
  o $SV
  o $SITE_NAME
  o current
} 

# Go to java tomcat directory
tc() {
  cd $TC
  cd $SITE_NAME
  cd current
}

# Go to java comms directory
cm() {
  cd $CM
  cd $SITE_NAME
}

# Go to java work directory
wk() {
  cd $WK
  cd $SITE_NAME
}

# TODO BG and put status in prompt
# Start java services
ss() {
  sv
  bin/launcher.sh
}

# Go to java installers directory
in() {
  o $IN
  if [ -d $SITE_NAME ]; then
    o $SITE_NAME
  fi
}

# rmsite : Removes current java revision installation
rmsite() {
  rm -rf $SV/$SITE_NAME
  rm -rf $WK/$SITE_NAME
  rm -rf $TC/$SITE_NAME
  sqlrm csc
  sqlrm pcs
  sqlrm manufacturing
}

# Java Development: Log
# lg : Tail logs
lg() {
  if [[ "$1" = "" ]]; then
    tail -f logs/*
  else
    tail -f logs/$1*.log.txt
  fi
}

# Start tomcat debug
rdb() {
  ps xu | grep tomcat | grep -v grep | awk '{print $2}' | xargs kill -9
  export JPDA_ADDRESS=13066
  export JPDA_TRANSPORT=dt_socket
  bin/catalina.sh jpda run
}

# Edit java fix time
fixtime() {
  vi $SV/$SITE_NAME/current/conf/kiwiplan/time.properties;
  cp $SV/$SITE_NAME/current/conf/kiwiplan/time.properties $TC/$SITE_NAME/current/kiwiconf/kiwiplan/time.properties;
}

# View latest java comms response
cmr() {
  cat kiwi_to_host/$(ls kiwi_to_host -rt | tail -1)
}

# Clear java comms folders
cmc() {
  rm host_to_kiwi/* <<< "y"
  rm kiwi_to_host/* <<< "y"
  rm archive/* <<< "y"
}

# Place java comms request
cmp() {
  cp $1 host_to_kiwi
}

# }}}

# Java Setup {{{

# Java Setup: Check out Java project
# jco mes-8.0 : Check out mes-8.0 projects
jco() {
  j
  pj
  mvn project:workspace << EOF
$SVN/projects/$1

Y
EOF
}

jpj() {
  j
  menu 'svn ls $SVN/projects | grep -v master | grep "\-(7)"'
  crc JPJ $menu
  if [ -d $PJ_ROOT/$PJ ]; then
    pj
  else
    jco $menu
  fi
}

# Copy universal java licence file
# cplic csc : Copy CSC licence to the current directory
cplic() {
  cp ~/Desktop/licence/$1.licence .
}

jsv() {
  j
  menu 'svn ls $SVN/projects | grep -v master | grep "\-(7)" | sed "s/\///"'
  crc JPJ $menu
  jin
}

jup() {
  if [ "$1" = "" ]; then
    TARGET=$JPJ
  else
    TARGET=$1
  fi
  if [ -d ~/installers/$TARGET ]; then
    rm -rf ~/installers/$TARGET
  fi
  mkdir ~/installers/$TARGET
  scp 'installers@nzjenkins:/data/installers/latestsingleinstaller/'$(echo $TARGET | sed "s/-[^-]*$//")'/'$TARGET'-*' ~/installers/$TARGET
  ~/installers/$TARGET/$TARGET-*.sh << EOF
n
$SITE_NAME
y
n
1
n
1
n



e
EOF
  cplic
}

jid() {
  if [ -d $IN/$JPJ ]; then
    rm -rf $IN/$JPJ
  fi
  mkdir $IN/$JPJ
  cd $IN/$JPJ
  scp 'installers@nzjenkins:/data/installers/latestsingleinstaller/'$(echo $JPJ | sed "s/-[^-]*$//")'/'$JPJ'-*' .
  cplic csc
}

jwid() {
  d $IN/$JPJ
  if [ -d windows ]; then
    rm -rf windows
  fi
  scp -r 'installers@nzjenkins:/home/installers/latest/'$JPJ windows
}

# TODO only works for CSC-only
# Java Setup: Fresh Service Installation
# jin : Do a fresh installation of the current java revision
jin() {
  rmsite
  jid

# Run installation
  ./$JPJ-*.sh << EOF
 
$SITE_NAME
 
 
n



y
n
 
admin1
admin1
 








50125



root



2




y

localhost

1
root





e
EOF
}

# Java Setup: Debug Trim
# jdt : Turn on debug for trim
jdt() {
  sv
  cat ~/Desktop/haoyang/trim.log | s "s/SITE_NAME/$SITE_NAME/" >> conf/log4j.properties
}

# }}}


################# MAP Development ################## 

# MAP Revision {{{

export MAP_REV=riegelsville
export MAP_REV=riegelsville
export MAP_DATA_REV=01jul2013
export MAP_TRUNK=trunk
export MAP_BRANCH=dev_branches/messaging
export MPJ_ROOT="/home/haoyang.feng/projects/map"
export MPJ=kiwi_riegelsville
export MHD=kiwi_head
export MMB=kiwi_riegelsville

case $MAP_REV_SRC in
boom_base)
  export MAP_REV_SRC_SERVER=nzboom
  export MAP_REV_SRC_DIR=/src
  ;;
boom_haoyang)
  export MAP_REV_SRC_SERVER=nzboom
  export MAP_REV_SRC_DIR=/home/haoyang.feng/projects
  ;;
esac

# }}}

# MAP Navigation {{{

# Go to MAP work directory
mwk() {
  o $WORK
}

# Switch MAP dataset
lndata() {
  if [ "$1" = "" ]; then
    TARGET=$(pwd)
  else
    TARGET=$1
  fi
# rm /kiwi/data
  if [[ "$TARGET" = *.sql ]]; then
    ln -s $DS/sql /kiwi/data
    TARGET_DB=$(echo $TARGET | sed s/.sql//)
    KWSQL_FILE=$DS/sql/kwsql
    rm $KWSQL_FILE
    echo "DATA=$TARGET" >> $KWSQL_FILE
    echo "HOST=localhost" >> $KWSQL_FILE
    echo "INTERFACE=sql" >> $KWSQL_FILE
    echo "LOG=error" >> $KWSQL_FILE
    echo "LOGPID=1" >> $KWSQL_FILE
  else
#   ln -s $TARGET /kiwi/data
    crc MD $TARGET
  fi
}

# Restore MAP QA ISAM dataset
rest() {
  DIR=$DS/rest/$MAP_DATA_REV
  if [ ! -d  $DIR ]; then
    mkdir -p $DIR
  fi
  if [ ! -d  $DIR/test$1 ]; then
    scp -r ssd@aurora:/mapqa/master_$MAP_DATA_REV/test$1 $DIR
  fi
  lndata $DIR/test$1
}

# Restore MAP QA SQL dataset
restsql() {
  DIR=$DS/rest/$MAP_DATA_REV
  if [ ! -f $DIR/test$1.sql ]; then
    scp ssd@aurora:/mapqa/master_$MAP_DATA_REV/test$1.sql $DIR
  fi
  lndata $DIR/test$1.sql
}


jip() {
  mwk
  jimportpaper
}
jib() {
  mwk
  jimportboard
}
jih() {
  mwk
  jimporthistory
}
pcs() {
  mwk
  pcsmenu
}
csc() {
  mwk
  cscmenu
}
xm() {
  mwk
  xmgen grp=$1
}
ult() {
  mwk
  ult00
}
rss() {
  mwk
  rss01
}
xl() {
  mwk
  echo -e "secr8\n" > .secr8
  xlmain -i .secr8
  rm .secr8
}

# }}}

# MAP Setup {{{

# Update MAP rev
upmap() {
  cd /KIWI/revisions
  if [ -d kiwi_$MAP_REV ]; then
    rm -rf kiwi_$MAP_REV.bk
    mv kiwi_$MAP_REV kiwi_$MAP_REV.bk
  fi
  mkdir kiwi_$MAP_REV
  cd kiwi_$MAP_REV
  scp -r $MAP_REV_SRC_SERVER:$MAP_REV_SRC_DIR/kiwi_$MAP_REV/progs progs
  scp -r $MAP_REV_SRC_SERVER:$MAP_REV_SRC_DIR/kiwi_$MAP_REV/scp scp
  scp -r $MAP_REV_SRC_SERVER:$MAP_REV_SRC_DIR/kiwi_$MAP_REV/sql sql
  scp -r $MAP_REV_SRC_SERVER:$MAP_REV_SRC_DIR/kiwi_$MAP_REV/etc etc
  scp -r $MAP_REV_SRC_SERVER:$MAP_REV_SRC_DIR/kiwi_$MAP_REV/bin bin
}

# Change MAP rev
maprev() {
  menu "echo 'boom_base\nboom_haoyang'"
  crc MAP_REV_SRC $menu
  menu "ssh $MAP_REV_SRC_SERVER ls -1d '$MAP_REV_SRC_DIR/kiwi_*' | sed 's/^.*kiwi_//g'"
  sed -i -r 's/^export MAP_REV.*$/export MAP_REV='$menu'/gi' $ZSHRC
  source ~/.zshrc
  rm /kiwi/kiwilink
  if [ ! -d /kiwi/revisions/kiwi_$menu ]; then
    upmap
  fi
  ln -s /kiwi/revisions/kiwi_$menu /kiwi/kiwilink
}

# Change MAP rev for dataset restores
mapdatarev() {
  menu "ssh ssd@felix ls -1d '/mapqa/master_*' | cut -d _ -f 2"
  sed -i -r 's/^export MAP_DATA_REV.*$/export MAP_DATA_REV='$menu'/gi' $ZSHRC
  source ~/.zshrc
}

# MAP Setup: MAP Work Cleanup
# mwc : Clean up MAP work directory by removing temp files
mwc() {
  rm *.LS
  rm *.TM
  rm *.XXX
  rm *.LOG
  rm *.log
  rm *.LG
  rm *.LG1
  rm *.OK
  rm *.LK
  rm *.lk
  rm *.TXT
  rm *.txt
  rm trim.log.*
  rm *.out
  rm core
}

# }}}

# MAP Workflow {{{

mgmess() {
  m
  pj && rv && up
  svn merge -c 11111 $SVN/trunk
  echo pj
  hd && rv && up
  echo hd
}

# }}}

# MAP Build {{{

# MAP Build: MAP Continuous Integration
# mci : Show the MAP continuous integration status
mci() {
  ssh nzboom ls -lrt /src/CI/logs
}

#}}}
 
################## General Developement ################## 

# General Navigation {{{

# Set general development environment variables
case $MODE in
VUE)
  export SVN=$JSVN
  export PJ_ROOT=$JPJ_ROOT
  export PJ=$JPJ
  export HD=$JHD
  export MB=$JMB
  ;;
MAP)
  export SVN=$MSVN
  export PJ_ROOT=$MPJ_ROOT
  export PJ=$MPJ
  export HD=$MHD
  export MB=$MMB
  ;;
esac

# Selecting the development mode
mode() {
  menu "echo 'VUE\nMAP'"
  crc MODE $menu
}

alias j="mode <<< 1"
alias m="mode <<< 2"

# Go to projects directory, depending on the development mode
pj() {
  cd $PJ_ROOT
  if [ -d $PJ ]; then
    cd $PJ
  fi
}

pjr() {
  cd $PJ_ROOT
}

# Go to the head project directory, depending on the development mode
hd() {
  cd $PJ_ROOT
  if [ -d $HD ]; then
    cd $HD
  fi
}

# }}}

# Data Set {{{

# Data Set: Change Data Set
# cds : Change data set
cds() {
  o $DS
}

# Data Set: Data Set
# ds : Go to the data set
ds() {
  o $MD/..
}

# Data Set: MAP Data Set
# mds : Go to the MAP data set
mds() {
  o $MD
}

# Data Set: Java Data Set
# vds : Go to the Java data set
vds() {
  o $MD/../VUE
}



# }}}

# Workflow {{{

upall() {
  pj
  svn up
  jats
  upjava
  upmap
}

# }}}

# Servers {{{

# Login to nzboom
# If $1 is defined then upload the file to nzboom shared folder
boom() {
  if [ "$1" = "" ]; then
    ssh nzboom
  elif [ -d $1 ]; then
    scp -r $1 nzboom:~/shared
  else
    scp $1 nzboom:~/shared
  fi
}

# Download from boom
# If $1 is defined then download the file to nzboom shared folder
boomdl() {
  cdd boom
  rm -rf *
  if [ "$1" = "" ]; then
    scp -r "nzboom:~/shared/*" .
  else
    scp -r "nzboom:~/shared/$1" .
  fi
}

#TODO Doesn't work
gromblecollect() {
  cdd gromble
  rm -rf *
  scp -r 'gromble:/home/haoyang.feng/support/nzcollect/$1' .
}

release() {
  scp -r ${@:2} gromble:/support/support/revisions/TEST_ONLY/refresh/$1
}

# suboom : Login to nzboom as ssd
suboom() {
  ssh ssd@nzboom
}

# odie : Login to nzodie
odie() {
  ssh ssd@nzodie
}

# 
kpi() {
#  ssh kpi@maven "./haoyang_kpi_export.sh"
  r ~/Desktop/kpi/*
  scp "kpi@maven:/home/kpi/haoyang/*.csv" ~/Desktop/kpi
#  ooffice ~/Desktop/kpi/*.csv
}

# Login to aurora
aurora() {
  ssh ssd@aurora
}

# Demo machine
demo() {
  ssh ssd@nzjavademomsg
}

sci() {
  ssh-copy-id $1
}

# }}}

# SQL {{{

# Run SQL with credentials and database
sql() {
  if [ "$1" = "" ]; then
    DB=""
  else
    DB=$SQL_NAME"_"$1
  fi
  mysql -uroot $DB "${@:2}"
}

# Find table in databases
sqlf() {
  aliasgrepnocolor
  for database in $(mysql -uroot -e "show databases" | grep $SQL_NAME); do if mysql -uroot $database -e "show tables" | grep "^"$1"$"; then echo $database; fi; done | grep -v $1
  aliasgrepfullcolor
}

# Rename SQL database
sqlmv() {
  mysql -uroot -e "create database $2"
  for table in `mysql -uroot -B -N -e "show tables" $1`; do 
    mysql -uroot -e "rename table $1.$table to $2.$table"
  done
  mysql -uroot -e "drop database $1"
}

# Drop SQL database
sqlrm() {
  mysql -uroot -e "drop database "$SQL_NAME"_"$1""
}

# Create SQL database
sqlmk() {
  mysql -uroot -e "create database "$SQL_NAME"_"$1""
}

# TODO CSC only
# Import SQL script to database
# $2 database dump suffix
# sqli tailim : Imports mes_8_csc/man_tailim.sql to mes_8_csc/man if java revision is mes-8
sqli() {
  sqlrm csc
  sqlmk csc
  sqlrm man
  sqlmk man
  sql man < "$SQL_NAME"_man_"$1".sql
  sql csc < "$SQL_NAME"_csc_"$1".sql
}

# TODO CSC only
# Export SQL database to script
# $1 database dump suffix
# sqlo tailim : Exports mes_8_csc/man to mes_8_csc/man_tailim.sql if java revision is mes-8
sqlo() {
  mysqldump --skip-tz-utc -uroot "$SQL_NAME"_csc > "$SQL_NAME"_csc_"$1".sql
  mysqldump --skip-tz-utc -uroot "$SQL_NAME"_man > "$SQL_NAME"_man_"$1".sql
}

# Show SQL process list
sqlp() {
  mysql -uroot -e "show processlist"
}

# Execute SQL in database
sqle() {
  table=$(echo $@ | sed "s/^.*\(from\|desc\|update\) //" | cut -d " " -f1)
  database=$(sqlf $table)
  eval "mysql -uroot $database -e \"$@\""
}

# SQL Utility: Explain a SQL table
# sqlt
sqlt() {
  if [ "$1" = "" ]; then
    while read table; do
      sqlte $table
    done
  else
    sqlte $1
  fi
}
sqlte() {
  database=$(sqlf $1)
  echo Found in $database
  mysql -uroot $database -e "select * from $1 limit 1 \G;" | vi -
}

# }}}

# SVN {{{
unsvn () {
  find . -name ".svn" | xargs /bin/rm -rf
}

reapply() {
  dir=$(pwd)
  cd ..
  rm -rf $dir
  mv $dir.bu $dir
  cd $dir
  dp
}

revert() {
  dir=$(pwd)
  cd ..
  mv $dir $dir.bu
  svn up
  cd $dir
  dp
}

# SVN Revert Utility
# rv : Revert all changes and remove unversioned files
rv() {
  if [ -d .git ]; then
    git reset --hard
  fi
  if [ -d .svn ]; then
    svn -R revert .
    svn st
    svn st | grep \? | awk '{print $2}' | xargs rm -rf
    svn st
  fi
}

# SVN Switch Utility
# sw 7.72 : Switch the current working copy to branch 7.72
sw() {
  svn sw $(svn info | grep URL | cut -d " " -f 2 | sed -r 's/branches\/[^\/]*\//branches\/'$1'\//')
}

# SVN Rollback
# rb 1000 1004 : Roll back changes from revision 1000 to 1004
rb() {
  svn merge -r $2:$1 .
}

# SVN Merge Utility
# mg 7.72 8399 : Merge r8399 from branch 7.72 to the working copy
mg() {
  svn merge -c $2 $(svn info | grep URL | cut -d " " -f 2 | sed -r 's/branches\/[^\/]*/branches\/'$1'/')
}

# SVN Merge Out Utility
# mo : Merge out the changes from head branch to base
mo() {
  crc MMB $MHD
  crc JMB $JHD
  pj
  svn merge $PJ_ROOT/$MB
}

# SVN Merge In Utility
# mi : Merge in the changes from base to head branch
mi() {
  crc MMB $MPJ
  crc JMB $JPJ
  hd
  if [ "$1" = "" ]; then
    svn merge --reintegrate $PJ_ROOT/$MB
  else
    svn merge -c r$1 $PJ_ROOT/$MB
  fi
}

# SVN Tree Conflict: List Add Conflicts
# tca : List tree conflicts for "local add, incoming add"
tca() {
  svn st | grep ">   local add, incoming add upon merge" -B1 | grep -v ">" | grep -v "\-\-" | cut -c9- | nl
}

# SVN Tree Conflict: Resolve Identical Add Conflicts
# tcar : Resolve tree conflicts for "local add, incoming add" by accepting local, where the files are identical
tcar() {
  for tc in $(svn st | grep ">   local add, incoming add upon merge" -B1 | grep -v ">" | grep -v "\-\-" | cut -c9-); do
    if [ "$(diff $tc $PJ_ROOT/$MB/$tc)" = "" ]; then
      svn resolve --accept working $tc
    fi
  done
}

# SVN Tree Conflict: Accept Incoming
# tcaa : Accept incoming files for tree conflicts for "local add, incoming add"
tcaa() {
  for tc in $(svn st | grep ">   local add, incoming add upon merge" -B1 | grep -v ">" | grep -v "\-\-" | cut -c9-); do
    cp $PJ_ROOT/$MB/$tc $tc
  done
}

# SVN Tree Conflict: List Other Conflicts (Non-add)
# tco : List Tree conflicts other than "local add, incoming add"
tco() {
  svn st | grep -v ">   local add, incoming add upon merge" | grep ">()" -B1 | grep -v ">" | grep -v "\-\-" | cut -c9-
}

svncomment() {
  svn propset svn:log --revprop -r $1 $2 $SVN
}

svnlog() {
  if [ "$1" = "" ]; then
    svn log | head -40 | head -40
  else
    svn log | grep $1 -C2 | head -40 | head -40
  fi
}

svndi() {
  svn di -c $1 *
}

st() {
  if [ -d .git ]; then
    git status
  fi
  if [ -d .svn ]; then
    svn status
  fi
}

stm() {
  st | grep "^M" | nl
}

dt() {
  if [ -d .git ]; then
    git difftool $@
  fi
  if [ -d .svn ]; then
    svn diff $@
  fi
}

ci() {
  if [ -d .git ]; then
    git commit -a -m $1
  fi
  if [ -d .svn ]; then
    if [[ $(svn st | grep "^C") = "" ]]; then
      svn ci -m $1
    else
      echo ci: Couldn\'t commit due to following conflicts
      svn st | grep "^C"
      return 1
    fi
  fi
}

up() {
  if [ -d .git ]; then
    git up
  fi
  if [ -d .svn ]; then
    svn up
  fi
}

svnst() {
  svn di -r 31094:31095 $SVN/trunk/$1 | grep Index | cut -d " " -f2
}

svndil() {
  for file in $(svnst $(rnode $(pwd) / 0)); do vimdiff $1/$file $file; done
}

# Blame
bl() {
  svn blame $(find . -name $1) | less
}

# }}}

# Misc Navigation {{{

# Go to desktop folder
cdd() {
  o ~/Desktop/$1
}

# Go to the desktop work directory
work() {
  cdd work
  if [[ "$1" != "" ]]; then
    d $1
  fi
}

export NOTE=~/note

# Edit note
note() {
  cd $NOTE
  if [ "$1" = "" ]; then
    t -rt
  else
    vi $1
  fi
}

# }}}

################## Application ################## 

# Todo {{{

export TD_TODO=$NOTE/td/todo
export TD_DONE=$NOTE/td/done

# Todo Utility: Edit
# tde : Edit the TODO list
tde() {
  vi $TD_TODO
}

# Todo Utility: Add to the top of the TODO list
tdn() {
  task="$@"
  sed -i "1i$task" $TD_TODO
}

# Todo Utility: Add to the bottom of the TODO list
tda() {
  task="$@"
  echo $task >> $TD_TODO
}

# Todo Utility: Add to the middle of the TODO list
tdi() {
  task="${@:2}"
  sed -i "$1"i"$task" $TD_TODO
}

# Todo Utility: List tasks on the TODO list
tdl() {
  cat $TD_TODO | nl
}

# Todo Utility: Delete current task
tdd() {
  if [ "$1" = "" ]; then
    line="1"
  else
    line=$1
  fi
  sed -i "$line"d $TD_TODO
}

# Todo Utility: Finish
# tdf : Finish current task
tdf() {
  ins $TD_DONE "$(catl $TD_TODO 1)"
  tdd
}

# Todo Utility: Undo finish
# tduf : Undo finish of previous task
tduf() {
  ins $TD_TODO "$(catl $TD_DONE 1)"
  si 1d $TD_DONE
}

# Todo Utility: List tasks on the DONE list
tdlf() {
  cat $TD_DONE | tail -30 | nl
}


# }}}

################## Other ################## 

# Experimental {{{

dj() {
  jarname=`ab $1`".jar"
  find ~/.maven/repository -name $jarname | xargs cp --target-directory .
}

# }}}

# Misc {{{
#export _JAVA_OPTIONS='-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
#export HISTCONTROL=ignoredups
#export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd"

if [ -d "$HOME/projects/maven-misc/bin" ] ; then
    PATH="$HOME/projects/maven-misc/bin:$PATH"
fi
if [ -d "/usr/local/java/maven3/bin" ] ; then
    PATH="/usr/local/java/maven3/bin:$PATH"
fi
if [ -d "~/.local/bin" ] ; then
    PATH="~/.local/bin:$PATH"
fi
PATH="/home/haoyang.feng/bin/Sencha/Cmd/3.0.0.250:$PATH"
# }}}


################## ZSH ################## 

# Startup {{{
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="blinks"
# CASE_SENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
# DISABLE_LS_COLORS="true"
DISABLE_AUTO_TITLE="true"
# COMPLETION_WAITING_DOTS="true"
#plugins=(svn vi-mode history-substring-search)
plugins=(svn vi-mode)
source $ZSH/oh-my-zsh.sh
# }}}

# Color {{{
autoload colors
colors
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
eval _$color='%{$terminfo[bold]$fg[${(L)color}]%}'
eval $color='%{$fg[${(L)color}]%}'
eval T$color='$fg[${(L)color}]'
(( count = $count + 1 ))
done
FINISH="%{$terminfo[sgr0]%}"
# }}}

# Prompt {{{  

add-zsh-hook precmd prompt_precmd

prompt_precmd() {
  echo
  echo "---  $TRED$(rnode $MD \/ 2) $(rnode $MD \/ 1) | $MODE   $TBLUE$PJ   $TCYAN$MAP_REV | $MAP_DATA_REV"
}

add-zsh-hook preexec o_preexec

o_preexec() {
  cs
  echo $1
  echo
  if [[ -a $1 ]]; then
    o $1
    exec zsh
  elif [[ "$(pnc)" = "l" ]]; then
 # | awk '{print $8}'
    #echo ZZZZZZZZZ
    #echo $1 | sed -e 's/ [0-9]\+ /& $(catl3nc &)/g'
    #echo ZZZZZZZZZ
  fi
}
zle-enter() {
  print -s ${(z)BUFFER}
  BUFFER="eve $BUFFER"
  zle accept-line
}
zle -N zle-enter
bindkey "^T" zle-enter

PROMPT="$TYELLOW%/ $ $FINISH"

# }}}

# Editor {{{
export EDITOR=vim
# }}}

# Syntax {{{
setopt extended_glob
TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'do' 'time' 'strace')
 
recolor-cmd() {
   region_highlight=()
   colorize=true
   start_pos=0
   for arg in ${(z)BUFFER}; do
       ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
       ((end_pos=$start_pos+${#arg}))
       if $colorize; then
           colorize=false
           res=$(LC_ALL=C builtin type $arg 2>/dev/null)
           case $res in
               *'reserved word'*)   style="fg=magenta";;
               *'alias for'*)       style="fg=cyan";;
               *'shell builtin'*)   style="fg=yellow";;
               *'shell function'*)  style='fg=green';;
               *"$arg is"*)
                   [[ $arg = 'sudo' ]] && style="fg=red" || style="fg=blue";;
               *)                   style='none';;
           esac
           region_highlight+=("$start_pos $end_pos $style")
       fi
       [[ ${${TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
       start_pos=$end_pos
   done
}

expand-cmd() {
}

self-insert() { zle .self-insert && expand-cmd && recolor-cmd}
backward-delete-char() { zle .backward-delete-char && recolor-cmd }
 
zle -N self-insert
zle -N backward-delete-char
# }}}

# History {{{
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zhistory
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt EXTENDED_HISTORY     
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
# }}}

# Development Environment {{{
PATH=$PATH:$HOME/.rvm/bin:~/bin # Add RVM to PATH for scripting
source ~/.rvm/scripts/rvm

# }}}
