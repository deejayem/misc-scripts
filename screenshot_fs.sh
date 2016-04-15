#!/bin/sh

#xwd -root|convert xwd:- screenshot`date "+%Y-%m-%d_%H:%M:%S"`.png
xwd -root|xwdtopnm|pnmtopng>screenshot`date "+%Y-%m-%d_%H:%M:%S"`.png
