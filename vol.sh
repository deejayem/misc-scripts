#!/bin/sh

change_vol() {
    #cur_master_l=$(mixer|grep vol|awk '{print $7}'|cut -d: -f1)
    #cur_master_l=$(mixer|grep vol|cut -d' ' -f13|cut -d: -f1)
    cur_master_l=$(mixer|sed -n 's/Mixer vol *is currently set to *\([0-9]*\):[0-9]*/\1/p')
    cur_master_r=$(mixer|grep vol|cut -d: -f2)

    #cur_pcm_l=$(mixer|grep pcm|awk '{print $7}'|cut -d: -f1)
    #cur_pcm_l=$(mixer|grep pcm|cut -d' ' -f13|cut -d: -f1)
    cur_pcm_l=$(mixer|sed -n 's/Mixer pcm *is currently set to *\([0-9]*\):[0-9]*/\1/p')
    cur_pcm_r=$(mixer|grep pcm|cut -d: -f2)

    # should use set_vol, but this way not everything has to be
    # set to the same value
    new_master_l=$(($cur_master_l $2 $1))
    new_master_r=$(($cur_master_r $2 $1))

    new_pcm_l=$(($cur_pcm_l $2 $1))
    new_pcm_r=$(($cur_pcm_r $2 $1))

    mixer vol $new_master_l:$new_master_r
    mixer pcm $new_pcm_l:$new_pcm_r
}

# sets everything to the same value, 'cause that's how I like it
# (and that was the original purpose of this script)
set_vol() {
    mixer vol $1
    mixer pcm $1
}

if [ $# -eq 0 ] ; then
    mixer
else
    #[[ $1 = +* ]] && change_vol "${1#+}" "+"  && exit # not POSIX sh
    #[[ $1 = -* ]] && change_vol "${1#-}" "-"  && exit # not POSIX sh
    if [ $(expr -- "$1" : "[+-]") -eq 1 ] ; then
        # change_vol ${1:1} ${1:0:1} # much nicer but bash/ksh only
        #change_vol ${1#[+-]} ${1%${1#[+-]}} # my eyes!
        change_vol ${1#?} ${1%${1#?}} # my eyes!
    else
        set_vol $1
    fi
fi

