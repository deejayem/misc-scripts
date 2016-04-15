#!/usr/local/bin/bash


yt() {
#    mplayer "http://youtube.com/get_video?$(wget -o/dev/null -O- "${1/v\//watch?v=}"|grep watch_fullscreen|sed 's/.*watch_fullscreen\?//')"
    #mplayer $(youtube-dl -s "${1}"|sed -n 's/.*URL: //p')
    mplayer $(youtube-dl -g "${1}")
}

x() {
    xclip -o
}

xt() {
    #yt `x`
    youtube-viewer `x`
}

xt
