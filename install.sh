#!/bin/bash
# desc  : deploy dotfiles from repository to home dir.
# author: Vivien Didelot aka v0n

REPLACE_ALL=false

function Overwrite {
  rm -rf $2
  ln -sv $1 $2
}

function Deploy {
  if test -e $2 ; then
    if $REPLACE_ALL ; then
      Overwrite $1 $2
    else
      read -p "overwrite $2? [Y/n/a] " QUESTION
      case $QUESTION in
        'Y'|'y')
          Overwrite $1 $2
          ;;
        a)
          REPLACE_ALL=true
          Overwrite $1 $2
          ;;
        *)
          echo "skip $2"
          ;;
      esac
    fi
  else
    read -p "create $2? [Y/n] " QUESTION
    case $QUESTION in
      'Y'|'y')
        test -d `dirname $2` || mkdir -p `dirname $2`
        ln -sv $1 $2
        ;;
      *)
        echo "skip $2"
        ;;
    esac
  fi
}

for FILE in * ; do
  SRC=`pwd`/$FILE
  LINK=$HOME/.$FILE

  case $FILE in
    $0|README.markdown)
      ;; # ignore
    terminator.config)
      LINK=$HOME/.config/terminator/config
      Deploy $SRC $LINK
      ;;
    bin)
      LINK=$HOME/$FILE
      Deploy $SRC $LINK
      ;;
    *)
      Deploy $SRC $LINK
      ;;
  esac
done

exit
