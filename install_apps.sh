#! /usr/bin/env bash
# https://github.com/Karmenzind/

# delete the app you don't need

# --------------------------------------------
# apps
# --------------------------------------------

_basic=(
    #vim # replace with gvim in graphical env
    aria2
    curl    
    git
    wget
    mlocate
    neofetch
    os-prober
    ntfs-3g
    gvfs
    v2ray
    v2raya
)

# basic Chinese fonts
_fonts=(
    adobe-source-han-sans-cn-fonts
    adobe-source-han-serif-cn-fonts
    wqy-microhei
    wqy-zenhei
    noto-fonts-emoji
)
#Fcitx5
_Fcitx5=(
    fcitx5-im 
    fcitx5-chinese-addons 
    fcitx5-material-color
)

_desktop=(
    firefox
    firefox-i18n-zh-cn
    chromium
    thunderbird
    thunderbird-i18n-zh-cn 
    telegram-desktop
    obs-studio
    shotcut
    gimp
    flameshot
)

_aur=(
    joplin-desktop
    teamviewer
)

# appearance
_themes=(
    papirus-icon-theme

)
_aur_themes=(
    zuki-themes
    paper-gtk-theme-git
    paper-icon-theme-git
    grub2-theme-archxion
)


# pip
_py_general=()


# --------------------------------------------
# Manually install
# --------------------------------------------

# manually install pkg from aur
# $1    the app to install
install_aur_app() {
    local aur_tmp=/tmp/_my_aur
    [[ -z "$1" ]] && exit_with_msg "Invalid argument: $1"
    local app=$1
    do_install git

    mkdir -p $aur_tmp 
    cd $aur_tmp 
    git clone "https://aur.archlinux.org/${app}.git" $app 
    cd $app 
    makepkg -sri --noconfirm
    cd ~
    rm -rf $aur_tmp
}

install_yay() {
    command -v yay >/dev/null && return
    do_install 'go'
    install_aur_app 'yay'
}


install_officials() {
    echo "Install offcial apps with pacman? (Y/n)"
    check_input yn
    [[ ! $ans = 'y' ]] && return

    do_install ${_basic[*]} 
    do_install ${_fonts[*]} 
    do_install ${_desktop[*]} 
    do_install ${_themes[*]} 
    sudo pacman -Sc 
}

install_aurs() {
    aur_helper=yay
    echo "Install apps from AUR with $aur_helper? (Y/n)"
    check_input yn
    [[ ! $ans = 'y' ]] && return

    install_yay
    $aur_helper -S -v --needed --noconfirm ${_aur[*]} 
    $aur_helper -S -v --needed --noconfirm ${_aur_themes[*]} 
    $aur_helper -Sc
}

# TODO
install_fcitx5() {
    echo "Install fcitx5 and Chinese input method? (Y/n)"
    check_input yn
    [[ ! $ans = 'y' ]] && return
    do_install ${_Fcitx5[*]} 
    sudo pacman -Sc 
}

# --------------------------------------------

# official
install_officials
# others
install_fcitx5
# aur
install_aurs



