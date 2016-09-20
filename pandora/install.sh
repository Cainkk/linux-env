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
ERROR=$'\e[1;31;47mError: ' #fg: red, bg: white
WARN=$'\e[1;33mWarning: '   #fg: yellow
INFO=$'\e[1;32mInfo: '      #fg: green
MONO=$'\e[0m'
EEND=$'\e[0m'

die() { [ "$1" ] && echo -e '\n\t'${ERROR}$*$MONO; exit 1;}
#What happens if yelling at girl;)
yellat() { (($?)) || return 0 && die $*;}

pr_err() { [ "$1" ] && echo -e '\n\t'${ERROR}$*$MONO;}

pr_warn() { [ "$1" ] && echo -e '\n\t'${WARN}$*$MONO;}

pr_info() { [ "$1" ] && echo -e '\n\t'${INFO}$*$MONO;}

##################################################
# Beginning...
##################################################
#Pandora: Treasure-trove You Will See...
PANDORAROOT="$(dirname `readlink -ef $0`)"

##################################################
# BASHRC CONFIGURATION                           #
# Append Customization                           #
# Backup surfix: .save                           #
##################################################
PANDORA_BASHRC=${PANDORAROOT}/bashrc
BASHRC=$HOME/.bashrc
BASHRC_SAVE=${BASHRC}.save

#Backup old .save file
[ -e "${BASHRC_SAVE}" ] && mv "${BASHRC_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}

#Backup target file
[ -e "${BASHRC}" ] && cp ${BASHRC} ${BASHRC_SAVE}

#DO what needs to be done
if cat >> "${BASHRC}" < ${PANDORA_BASHRC}; then
    BASH_DONE_FLAG=0
    pr_info "Bash Configuration DONE"
else
    pr_warn "NEED Check BASHRC"
fi

##################################################
# VIM CONFIGURATION                              #
# Replace .vimrc to avoid conflict               #
# Append VIM directory customization             #
# VIM Plugin file Bakcup surfix: .old            #
##################################################
PANDORA_VIM=${PANDORAROOT}/vim
PANDORA_VIMRC=${PANDORA_VIM}/vimrc
VIMRC=$HOME/.vimrc
VIMRC_SAVE=${VIMRC}.save
VIMDIR=$HOME/.vim

#Backup old .save file
[ -e "${VIMRC_SAVE}" ] && mv "${VIMRC_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}

#Backup target file
[ -e "${VIMRC}" ] && cp ${VIMRC} ${VIMRC_SAVE}

#DO what needs to be done
if cp ${PANDORA_VIMRC} ${VIMRC}; then
    if mkdir -p ${VIMDIR}; then
        #copy .vimrc there too for comparison
        cp --parents --backup=old ${PANDORA_VIM} ${VIMDIR}
    fi

    if [ $? -eq 0 ]; then
        VIM_DONE_FLAG=0
        pr_info "VIM Configuration DONE..."
    else
        pr_warn "Check VIM configuration"
    fi
else
    pr_warn "Check VIM configuration"
fi


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
PANDORA_CW=${PANDORAROOT}/cw
HOMEBIN=$HOME/bin

mkdir -p ${HOMEBIN}

if cp ${PANDORA_CW} ${HOMEBIN}; then
    HOMEBIN_DONE_FLAG=1
    #Tips: expr seems like sed, only 6 special RE character
    #Check cscope version
    if which cscope >/dev/null; then # cscope already installed
        if [[ "$(cscope -V 2>&1)" =~ [^0-9]*([0-9]+).([0-9]+) ]]; then
            MAJOR=${BASH_REMATCH[1]}; MINOR=${BASH_REMATCH[2]}
            if let ${MAJOR}>=15 && let ${MINOR}>=8; then
                HOMEBIN_DONE_FLAG=2
                pr_info "NEW: `cscope -V 2>&1` '>= 15.8'"
            else 
                pr_warn "Check cscope"
            fi
        else
            pr_warn "Check cscope"
        fi
    else
        pr_warn "NO cscope"
    fi

    #Check ctags version
    if which ctags >/dev/null; then # ctags already installed
        if [[ "$(ctags --version 2>&1)" =~ ^'Exuberant Ctags'.*[0-9]+\.[0-9]+ ]]; then
            HOMEBIN_DONE_FLAG=3
            pr_info "${BASH_REMATCH[0]}..."
        else
            pr_warn "Not Exuberant-ctags version"
        fi
    else
            pr_warn "No Exuberant-ctags"
    fi

    
    if which gtags >/dev/null; then #Check Global, new tool to try
        HOMEBIN_DONE_FLAG=4
        pr_info "$(global --version | sed -ne '1d')..."
    else
        pr_warn "No GNU Global"
    fi

else
    HOMEBIN_DONE_FLAG=100
fi


if ((${HOMEBIN_DONE_FLAG}==0)); then
    pr_info "HOMEBIN DONE..."
elif ((${HOMEBIN_DONE_FLAG}==100)); then
    pr_warn "HOMEBIN Empty"
else
    pr_warn "NEED Check HOMEBIN"
fi


##################################################
# XTERM CONFIGURATION                            #
# Setup in Xresources                            #
##################################################
PANDORA_XRESOURCES=${PANDORAROOT}/Xresources
XRESOURCES=$HOME/.Xresources
XRESOURCES_SAVE=${XRESOURCES}.save

#Backup old .save file
if [ -e "${XRESOURCES_SAVE}" ]; then
    mv "${XRESOURCES_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}
fi

#Backup target file
[ -e "${XRESOURCES}" ] && cp ${XRESOURCES} ${XRESOURCES_SAVE}


#DO what needs to be done
if cp ${PANDORA_XRESOURCES} ${XRESOURCES}; then
    pr_info "Xresources DONE..."
else
    pr_warn "NEED Check Xresources"
fi

##################################################
#         TMUX CONFIGURATION                     #
##################################################
PANDORA_TMUXCONF=${PANDORAROOT}/tmux.conf
TMUXCONF=$HOME/.tmux.conf
TMUXCONF_SAVE=${TMUX}.save

#Backup old .save file
[ -e "${TMUXCONF_SAVE}" ] && mv "${TMUXCONF_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}

#Backup target file
[ -e "${TMUXCONF}" ] && cp ${TMUXCONF} ${TMUXCONF_SAVE}

#DO what needs to be done
if cp ${PANDORA_TMUXCONF} ${TMUXCONF}; then
    pr_info "TMUXCONF DONE..."
else
    pr_warn "NEED Check TMUXCONF"
fi

##################################################
# GITCONFIG file CONFIGURATOIN                   #
##################################################
PANDORA_GITCONFIG=${PANDORAROOT}/gitconfig
GITCONFIG=$HOME/.gitconfig
GITCONFIG_SAVE=${GITCONFIG}.save

#Backup old .save file
if [ -e "${GITCONFIG_SAVE}" ]; then
    mv "${GITCONFIG_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}
fi

#Backup target file
[ -e "${GITCONFIG}" ] && cp ${GITCONFIG} ${GITCONFIG_SAVE}

#DO what needs to be done
if cp ${PANDORA_GITCONFIG} ${GITCONFIG}; then
    pr_info "GITCONFIG DONE..."
else
    pr_warn "NEED Check GITCONFIG"
fi

##################################################
#ALL COMPLETE, SAY ByeBye#########################
pr_info "It's OVER..."
exit $?

