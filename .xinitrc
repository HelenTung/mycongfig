#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then







    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then







    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# see https://unix.stackexchange.com/a/295652/332452
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# see https://wiki.archlinux.org/title/GNOME/Keyring#xinitrc
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK

# see https://github.com/NixOS/nixpkgs/issues/14966#issuecomment-520083836
mkdir -p "$HOME"/.local/share/keyrings


## 登陆后自动启动
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
exec startx
fi

## 登陆后自动设置壁纸
feh --bg-fill ~/wallpaper/wallhaven-l372my.png &

##环境变量的设置
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US

##刷新率的设置
xrandr --output DP-0 --mode 2560x1440 --rate 144.00  

##一些进程的管理
setxkbmap en &
fcitx5 &
xsetroot -cursor_name left_ptr
picom -b -f &
/home/arch/.config/polybar/launch.sh --colorblocks &
rm -rf ~/.config/Code/Cache
exec bspwm
