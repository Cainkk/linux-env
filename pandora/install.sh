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

# Things to do
# 0: done; 1: no; 2: check version
TOOL_DONE=(
    "bash"=0
    "vim"=0
    "cw"=0
    "cscope"=0
    "ctags"=0
    "global"=0
    "xterm"=0
    "tmux"=0
    "git"
)

#Colorful Message
ERROR=$'\e[1;31;47mError: ' #fg: red, bg: white
WARN=$'\e[1;33mWarning: '   #fg: yellow
INFO=$'\e[1;32mInfo: '      #fg: green
MONO=$'\e[0m'

die() { [ "$1" ] && echo -e '\n\t'${ERROR}$*$MONO; exit 1;}
#What happens if yelling at girl;)
yell() { (($?)) || return 0 && die $*;}

pr_err() { [ "$1" ] && echo -e '\n\t'${ERROR}$*$MONO;}

pr_warn() { [ "$1" ] && echo -e '\n\t'${WARN}$*$MONO;}

pr_info() { [ "$1" ] && echo -e '\n\t'${INFO}$*$MONO;}

##################################################
# Beginning...
##################################################
#Pandora: Treasure-trove You Will See...
PANDORAROOT="$(dirname `readlink -ef $0`)"
[ -d "$PANDORAROOT" ] || yell "Not found $PANDORAROOT"

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
    TOOL_DONE["bash"]=0
    pr_info "Bash Configuration DONE"
else
    TOOL_DONE["bash"]=1
    pr_err "NEED Check BASHRC"
fi

##################################################
# VIM CONFIGURATION                              #
# Replace .vimrc to avoid conflict               #
# VIM directory customization                    #
# VIM Plugin file Bakcup surfix: .old            #
##################################################
PANDORA_VIM=${PANDORAROOT}/vim
PANDORA_VIM_LEGACY=${PANDORAROOT}/vim_legacy
VIMRC=$HOME/.vimrc
VIMRC_SAVE=${VIMRC}.save
VIMDIR=$HOME/.vim
VIMDIR_SAVE=$HOME/.vim_save
VIMDIR_RC=${VIMDIR}/vimrc

#Backup old .save file
[ -e "${VIMRC_SAVE}" ] && mv "${VIMRC_SAVE}"{,.`date +%Y-%m-%d-%H-%M-%S`}

#Backup target files
[ -e "$VIMRC" ] && mv ${VIMRC} ${VIMRC_SAVE}
[ -d "$VIMDIR" ] && mv ${VIMDIR} ${VIMDIR_SAVE}

#DO what needs to be done
if [[ "`vim --version | sed -n 1p`" =~ "Vi IMproved "([0-9]+).([0-9]+) ]]; then
    if ((${BASH_REMATCH[1]}>=7 && ${BASH_REMATCH[2]}>=4)); then
        mkdir -p ${VIMDIR}
        cp -r --backup=old ${PANDORA_VIM}/* ${VIMDIR}
        TOOL_DONE["vim"]=0
    else
        cp -r --backup=old ${PANDORA_VIM_LEGACY}/* ${VIMDIR}
        mv ${VIMDIR_RC} ${VIMRC}
        TOOL_DONE["vim"]=2
    fi
else
    pr_err "No vim installed..."
    TOOL_DONE["vim"]=1
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
HOMEBIN_CW=${HOMEBIN}/cw

mkdir -p ${HOMEBIN}

if cp ${PANDORA_CW} ${HOMEBIN_CW}; then
    chmod +x ${HOMEBIN_CW}
    TOOL_DONE["cw"]=0
else
    pr_err "Cannot create ${HOMEBIN_CW}"
    TOOL_DONE["cw"]=1
fi

#Check cscope
if which cscope >/dev/null; then
    if [[ "$(cscope -V 2>&1)" =~ [^0-9]*([0-9]+).([0-9]+) ]]; then
        MAJOR=${BASH_REMATCH[1]}; MINOR=${BASH_REMATCH[2]}
        if let ${MAJOR}>=15 && let ${MINOR}>=8; then
            TOOL_DONE["cscope"]=0
            pr_info "NEW: `cscope -V 2>&1` '>= 15.8'"
        else 
            TOOL_DONE["cscope"]=2
            pr_warn "Check cscope version"
        fi
    else
        TOOL_DONE["cscope"]=1
        pr_warn "Check cscope failed..."
    fi
else
    TOOL_DONE["cscope"]=1
    pr_err "NO cscope, Need install manually..."
fi

#Check ctags
if which ctags >/dev/null; then
    if [[ "$(ctags --version 2>&1)" =~ ^'Exuberant Ctags'.*[0-9]+\.[0-9]+ ]]; then
        TOOL_DONE["ctags"]=0
        pr_info "${BASH_REMATCH[0]}..."
    else
        TOOL_DONE["ctags"]=2
        pr_warn "Not Exuberant-ctags version..."
    fi
else
        TOOL_DONE["ctags"]=1
        pr_err "No Exuberant-ctags installed..."
fi

#Check global
if which gtags >/dev/null; then
    TOOL_DONE["global"]=0
    pr_info "$(global --version | sed -ne '1d')..."
else
    TOOL_DONE["global"]=1
    pr_warn "No GNU Global installed..."
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
    TOOL_DONE["xterm"]=0
    pr_info "Xresources DONE..."
else
    TOOL_DONE["xterm"]=1
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
    TOOL_DONE["tmux"]=0
    pr_info "TMUXCONF DONE..."
else
    TOOL_DONE["tmux"]=1
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
    TOOL_DONE["git"]=0
    pr_info "GITCONFIG DONE..."
else
    TOOL_DONE["git"]=1
    pr_warn "NEED Check GITCONFIG"
fi

##################################################
#ALL COMPLETE, Summary############################
##################################################
echo
cat <<'EOF'
 ____                 _ _           
|  _ \ ___  ___ _   _| | |_ ___   _ 
| |_) / _ \/ __| | | | | __/ __| (_)
|  _ <  __/\__ \ |_| | | |_\__ \  _ 
|_| \_\___||___/\__,_|_|\__|___/ (_)

EOF

tool_results()
{
    [ $# -lt 2 ] || { pr_err "lack parameters"; return 1;}

    local tool=$1
    local done=$2

    case ${done} in
    0) pr_info "${tool}: Done" ;;
    1) pr_err  "${tool}: Unfinish" ;;
    2) pr_warn "${tool}: CHECK version" ;;
    esac
}

for i in ${!TOOL_DONE[@]}
do
    tool_results $i ${TOOL_DONE[$i]}
done

exit $?
