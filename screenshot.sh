#!/bin/sh

#xwd -frame|convert xwd:- screenshot`date "+%Y-%m-%d_%H:%M:%S"`.png
xwd -frame|xwdtopnm|pnmtopng>screenshot`date "+%Y-%m-%d_%H:%M:%S"`.png
