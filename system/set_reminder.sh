# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    set_reminder.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vphongph <vphongph@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/26 01:20:45 by vphongph          #+#    #+#              #
#    Updated: 2019/04/27 01:49:58 by vphongph         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#! /bin/bash

blink="\033[5:m"
blue="\033[38;5;26m"
blue_light="\033[38;5;39m"
purple_dark="\033[38;5;62m"
purple="\033[38;5;98m"
green="\033[38;5;70m"
green_coa="\033[38;5;47m"
green_dark="\033[38;5;28m"
red="\033[38;5;196m"
red_dark="\033[38;5;88m"
grey="\033[38;5;242m"
yellow="\033[38;5;178m"
reset="\033[0m"

IFS=$'\n\t'

r_entry=""
r_date_time=""
r_content=""
r_confirmation=""

r_crontab=""
r_rate=""
r_tty=""

file_cr="crontab_"
# file_cr_b="crontab_birthday"
# file_cr_q="crontab_quote"
# file_cr_t="crontab_task"

file_rem="reminder_"
file_rem_b="reminder_birthday"
file_rem_q="reminder_quote"
file_rem_t="reminder_task"
file_rem_o="reminder_output"

bool=0

printf "\nIf you're running this script for the first time, please run all the steps in the order.\n\n"$reset

printf "Wanna add entry ?"$blue_light" [birthday/quote/task]\n"$reset
printf "Wanna update reminder output ?"$blue_light" [output]\n"$reset
printf "Wanna update crontab refresh time ?"$blue_light" [refresh]\n"$reset

printf $yellow && read r_entry && printf $reset

#__________________________________add_entry____________________________________

if [ $r_entry = "birthday" ] 2>/dev/null	\
	|| [ $r_entry = "quote" ] 2>/dev/null	\
	|| [ $r_entry = "task" ] 2>/dev/null
then
	if [ $r_entry = "task" ] 2>/dev/null
	then
		printf "date ? time ?"$blue_light" [dd/mm hh:MM]\n"$reset
	else
		printf "date ?"$blue_light" [dd/mm]\n"$reset
	fi
	printf $yellow && read r_date_time && printf $reset
	printf "$r_entry : "
	printf $yellow && read r_content && printf $yellow
fi

r_date_time=`echo $r_date_time | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
r_content=`echo $r_content | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`

if [ $r_date_time ] && [ $r_content ] 2>/dev/null
then
	printf "New $r_entry : "$green_coa"`echo $r_date_time $r_content`\n"$reset
	printf "Confirm ? [y/n]\n"
	printf $yellow && read r_confirmation && printf $reset
fi

if [ $r_confirmation = "y" ] 2>/dev/null
then
	if [ $r_entry = "birthday" ] 2>/dev/null
	then
		printf "$r_date_time	$r_content\n" >> $file_rem$r_entry
	else
		printf "\n$r_date_time\n$r_content\n" >> $file_rem$r_entry
	fi
	bool=1
fi

#____________________________________output_____________________________________

if [ $r_entry = "output" ] 2>/dev/null
then
	printf $purple"\nall the tty's : \n"$reset
	who
	printf $purple"\nyours : "$reset"`tty`\n"
	printf "\ntty output ?\n"
	printf $yellow && read r_tty && printf $reset
	r_tty=`echo $r_tty | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
	if [ $r_tty ] 2>/dev/null
	then
		printf "New reminder output : "$green_coa"`echo $r_tty`\n"$reset
		printf "Confirm ? [y/n]\n"
		printf $yellow && read r_confirmation && printf $reset
		if [ $r_confirmation = "y" ] 2>/dev/null
		then
			printf "$r_tty\n" > $file_rem_o
			bool=1
		fi
	fi
fi

#___________________________________refresh_____________________________________

if [ $r_entry = "refresh" ] 2>/dev/null && ! [ -f $file_rem_o ]
then
	printf "Please update reminder output first\n"
	false
	exit
fi

if [ $r_entry = "refresh" ] 2>/dev/null
then
	printf "birthday ? quote ? task ?"$blue_light" [birthday/quote/task]\n"$reset
	printf $yellow && read r_crontab && printf $reset
fi

if ([ $r_crontab = "birthday" ] 2>/dev/null && ! [ -f $file_rem_b ])		\
	|| ([ $r_crontab = "quote" ] 2>/dev/null	&& ! [ -f $file_rem_q ])	\
	|| ([ $r_crontab = "task" ] 2>/dev/null && ! [ -f $file_rem_t ])
then
	printf "Please add $r_crontab entry first\n"
	false
	exit
fi

if [ $r_crontab = "birthday" ] 2>/dev/null	\
	|| [ $r_crontab = "quote" ] 2>/dev/null	\
	|| [ $r_crontab = "task" ] 2>/dev/null
then
	printf "every min ? day ? month ?"$blue_light" [min/day/month]\n"$reset
	printf $yellow && read r_rate && printf $reset
fi

if [ $r_rate = "min" ] 2>/dev/null
then
	printf "New crontab $r_crontab refresh time : "$green_coa"`echo every $r_rate`\n"$reset
	printf "Confirm ? [y/n]\n"
	printf $yellow && read r_confirmation && printf $reset
	if [ $r_confirmation = "y" ] 2>/dev/null
	then
		printf "* * * * * FROM=$r_crontab bash run_reminder.sh > \`cat $file_rem_o\`" > $file_cr$r_crontab
		bool=1
	fi
fi

if [ $r_rate = "day" ] 2>/dev/null
then
	echo
fi

if [ $r_rate = "hour" ] 2>/dev/null
then
	echo
fi


if [ $bool = 0 ]
then
	false
else
	true
fi


# lol=`echo $lol | tr -d '\n\t'`
#
# printf $blue_light"task ?\n"$reset
#
# printf $yellow
# read  mdr
# printf $reset
#
# printf $blue_light"password\n"$reset
# printf $yellow
# read  -s pass
# printf $reset
#
# echo $pass
#
# mdr=`echo $mdr | tr -d '\n\t'`
#
# if [ $lol ]
# then
# 	echo prout
# 	echo $lol
# fi
