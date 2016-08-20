#!/bin/bash
#tab=4space

#figlet
cat <<'EOF'
         ____  ____  _____    _    ____  ____  _____ 
        |  _ \|  _ \| ____|  / \  |  _ \|  _ \| ____|
        | |_) | |_) |  _|   / _ \ | |_) | |_) |  _|  
        |  __/|  _ <| |___ / ___ \|  __/|  _ <| |___ 
        |_|   |_| \_\_____/_/   \_\_|   |_| \_\_____|
                                             
         _     _                    ____            _      
        | |   (_)_ __  _   ___  __ | __ )  __ _ ___(_) ___ 
        | |   | | '_ \| | | \ \/ / |  _ \ / _` / __| |/ __|
        | |___| | | | | |_| |>  <  | |_) | (_| \__ \ | (__ 
        |_____|_|_| |_|\__,_/_/\_\ |____/ \__,_|___/_|\___|
                                                           
         _____            _                                      _   
        | ____|_ ____   _(_)_ __ ___  _ __  _ __ ___   ___ _ __ | |_ 
        |  _| | '_ \ \ / / | '__/ _ \| '_ \| '_ ` _ \ / _ \ '_ \| __|
        | |___| | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_ 
        |_____|_| |_|\_/ |_|_|  \___/|_| |_|_| |_| |_|\___|_| |_|\__|

EOF

#Things ToDo
BASH_DONE_FLAG=
VIM_DONE_FLAG=
HOMEBIN_DONE_FLAHG=
XTERM_DONE_FLAG=
TMUX_DONE_FLAG=

#Colorful Message
INFO=$'\e''[1;31;43m' #fg: red, bg: yellow
WARN=$'\e''[1;37;41m' #fg: white, bg: red
EEND=$'\e''[0m'

#Treasure Place You Will See...
PANDORAROOT="$(dirname `readlink -ef $0`)"

##################################################
# BASHRC CONFIGURATION                           #
# Append Customization                           #
# Backup surfix: .save                           #
##################################################
BASHRC=$HOME/.bashrc
BASHRC_SAVE=${BASHRC}.save

#Backup old .save file
if [ -e "${BASHRC_SAVE}" ]; then
    mv "${BASHRC_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}
fi

#Backup target file
[ -e "${BASHRC}" ] && cp ${BASHRC} ${BASHRC_SAVE}

#DO what needs to be done
cat >> "${BASHRC}" < ${PANDORAROOT}/bashrc && {
    BASH_DONE_FLAG=0
    echo -e '\n\t'${INFO}Bash Configuration DONE...$EEND
} || echo -e '\n\t'${WARN}NEED Check BASHRC'!!!'$EEND

##################################################
# VIM CONFIGURATION                              #
# Replace .vimrc to avoid conflict               #
# Append VIM directory customization             #
# VIM Plugin file Bakcup surfix: .old            #
##################################################
VIMRC=$HOME/.vimrc
VIMRC_SAVE=${VIMRC}.save
VIMDIR=$HOME/.vim

#Backup old .save file
if [ -e "${VIMRC_SAVE}" ]; then
    mv "${VIMRC_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}
fi

#Backup target file
[ -e "${VIMRC}" ] && cp ${VIMRC} ${VIMRC_SAVE}

#DO what needs to be done
cp ${PANDORAROOT}/vim/vimrc ${VIMRC} && {
    #copy .vimrc there too for comparison
    mkdir -p ${VIMDIR} && \
    cp --parents --backup=old ${PANDORAROOT}/vim ${VIMDIR}
    [ $? -eq 0 ] && {
        VIM_DONE_FLAG=0
        echo -e '\n\t'${INFO}VIM Configuration DONE...$EEND
    } || echo -e '\n\t'${INFO}Check VIM configuration'!!!'$EEND
} || echo -e '\n\t'${INFO}Check VIM configuration'!!!'$EEND

##################################################
# $HOME/bin/ CONFIGURATION                       #
# Add source code indexer: cw shell script       #
# Could also add cscope/Exuberant ctags/Global   #
#                                                #
# HOMEBIN_DONE_FLAG:                             #
# 0: ALL OK there                                #
# 1: Only cw is OK                               #
# 2: cscope is OK                                #
# 3: Exuberant-ctags is OK                       #
# 4: GNU Global is OK                            #
# 100: NOTHING IS GOOD                           #
##################################################
HOMEBIN=$HOME/bin

mkdir -p ${HOMEBIN}
cp ${PANDORAROOT}/cw ${HOMEBIN} && { # die if no cw

    HOMEBIN_DONE_FLAG=1

    #Check cscope version
    #Tips: expr regex seems like sed, only 6 special character
    which cscope >/dev/null && { # cscope already installed
        [[ "$(cscope -V 2>&1)" =~ [^0-9]*([0-9]+).([0-9]+) ]] && {
            MAJOR=${BASH_REMATCH[1]}
            MINOR=${BASH_REMATCH[2]}
            let ${MAJOR}>=15 && let ${MINOR}>=8 && {
                HOMEBIN_DONE_FLAG=2
                echo -e '\n\t'${INFO}NEW: `cscope -V 2>&1` '>= 15.8'$EEND
            } || echo -e '\n\t'${WARN}Check cscope'!!!'$EEND
        } || echo -e '\n\t'${WARN}Check cscope'!!!'$EEND
    } || echo -e '\n\t'${WARN}NO cscope'!!!'$EEND

    #Check ctags version
    which ctags >/dev/null && { # ctags already installed
        [[ "$(ctags --version 2>&1)" =~ ^'Exuberant Ctags'.*[0-9]+\.[0-9]+ ]] && {
            HOMEBIN_DONE_FLAG=3
            echo -e '\n\t'${INFO}${BASH_REMATCH[0]}...$EEND
        } || echo -e '\n\t'${WARN}Not Exuberant-ctags version'!!!'$EEND
    } || echo -e '\n\t'${WARN}No Exuberant-ctags'!!!'$EEND

    #Check Global, new tool to try
    which gtags >/dev/null && {
        HOMEBIN_DONE_FLAG=4
        echo -e '\n\t'${INFO}"$(global --version | sed -ne '1d')..."$EEND
    } || echo -e '\n\t'${WARN}"No GNU Global"$EEND

} || HOMEBIN_DONE_FLAG=100

if let ${HOMEBIN_DONE_FLAG} == 0; then
    echo -e '\n\t'${INFO}HOMEBIN DONE...$EEND
elif let ${HOMEBIN_DONE_FLAG} == 100; then
    echo -e '\n\t'${WARN}HOMEBIN Empty'!!!'$EEND
else
    echo -e '\n\t'${WARN}NEED Check HOMEBIN'!!!'$EEND
fi


##################################################
# XTERM CONFIGURATION                            #
# Setup in Xresources                            #
##################################################
XRESOURCES=$HOME/.Xresources
XRESOURCES_SAVE=${XRESOURCES}.save

#Backup old .save file
if [ -e "${XRESOURCES_SAVE}" ]; then
    mv "${XRESOURCES_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}
fi

#Backup target file
[ -e "${XRESOURCES}" ] && cp ${XRESOURCES} ${XRESOURCES_SAVE}


#DO what needs to be done
if cp ${PANDORAROOT}/Xresources ${XRESOURCES}; then
    echo -e '\n\t'${INFO}Xresources DONE...$EEND
else
    echo -e '\n\t'${WARN}NEED Check Xresources'!!!'$EEND
fi

##################################################
#         TMUX CONFIGURATION                     #
##################################################
TMUX=$HOME/.tmux.conf
TMUX_SAVE=${TMUX}.save

#Backup old .save file
if [ -e "${TMUX_SAVE}" ]; then
    mv "${TMUX_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}
fi


#Backup target file
[ -e "${TMUX}" ] && cp ${TMUX} ${TMUX_SAVE}

#DO what needs to be done
if cp ${PANDORAROOT}/tmux.conf ${TMUX}; then
    echo -e '\n\t'${INFO}TMUX DONE...$EEND
else
    echo -e '\n\t'${WARN}NEED Check TMUX'!!!'$EEND
fi

##################################################
# GITCONFIG file CONFIGURATOIN                   #
##################################################
GIT=$HOME/.gitconfig
GIT_SAVE=${GIT}.save

#Backup old .save file
if [ -e "${GIT_SAVE}" ]; then
    mv "${GIT_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}
fi


#Backup target file
[ -e "${GIT}" ] && cp ${GIT} ${GIT_SAVE}

#DO what needs to be done
if cp ${PANDORAROOT}/gitconfig ${GIT}; then
    echo -e '\n\t'${INFO}GITCONFIG DONE...$EEND
else
    echo -e '\n\t'${WARN}NEED Check GITCONFIG'!!!'$EEND
fi

##################################################
#ALL COMPLETE, SAY ByeBye#########################
echo -e '\n'${INFO}It's OVER...$EEND
exit $?

