# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    set_reminder.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vphongph <vphongph@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/26 01:20:45 by vphongph          #+#    #+#              #
#    Updated: 2019/04/26 19:44:17 by vphongph         ###   ########.fr        #
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

entry=""
date_time=""
content=""
confirmation=""

crontab=""
rate=""
tty=""

file_cr="crontab_"
file_cr_b="crontab_birthday"
file_cr_q="crontab_quote"
file_cr_t="crontab_task"

file_rem="reminder_"
file_rem_b="reminder_birthday"
file_rem_q="reminder_quote"
file_rem_t="reminder_task"
file_rem_o="reminder_output"

printf "Wanna add entry ?"$blue_light" [birthday/quote/task]\n"$reset
printf "Wanna update reminder output ?"$blue_light" [output]\n"$reset
printf "Wanna update crontab refresh time ?"$blue_light" [refresh]\n"$reset

printf $yellow && read entry && printf $reset

#__________________________________add_entry____________________________________

if [ $entry = "birthday" ] 2>/dev/null	\
	|| [ $entry = "quote" ] 2>/dev/null	\
	|| [ $entry = "task" ] 2>/dev/null
then
	if [ $entry = "task" ] 2>/dev/null
	then
		printf "date ? time ?"$blue_light" [dd/mm hh:MM]\n"$reset
	else
		printf "date ?"$blue_light" [dd/mm]\n"$reset
	fi
	printf $yellow && read date_time && printf $reset
	printf "$entry : "
	printf $yellow && read content && printf $yellow
fi

date_time=`echo $date_time | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
content=`echo $content | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`

if [ $date_time ] && [ $content ] 2>/dev/null
then
	printf "New $entry : "$green_coa"`echo $date_time $content`\n"$reset
	printf "Confirm ? [y/n]\n"
	printf $yellow && read confirmation && printf $reset
fi

if [ $confirmation = "y" ] 2>/dev/null
then
	if [ $entry = "birthday" ] 2>/dev/null
	then
		printf "$date_time	$content\n" >> $file_rem$entry
	else
		printf "\n$date_time\n$content\n" >> $file_rem$entry
	fi
fi

#___________________________________refresh_____________________________________

if [ $entry = "refresh" ] 2>/dev/null
then
	printf "birthday ? quote ? task ?"$blue_light" [birthday/quote/task]\n"$reset
	printf $yellow && read crontab && printf $reset
fi

if [ $crontab = "birthday" ] 2>/dev/null \
	|| [ $crontab = "quote" ] 2>/dev/null \
	|| [ $crontab = "task" ] 2>/dev/null
then
	printf "every min ? day ? month ?"$blue_light" [min/day/month]\n"$reset
	printf $yellow && read rate && printf $reset
fi


if [ $rate = "min" ] 2>/dev/null
then
	printf "* * * * * FROM=$crontab bash run_reminder.sh > \`cat $file_rem_o\`" > $file_cr$crontab
fi

if [ $rate = "day" ] 2>/dev/null
then
	echo
fi

if [ $rate = "hour" ] 2>/dev/null
then
	echo
fi

#____________________________________output_____________________________________

if [ $entry = "output" ] 2>/dev/null
then
	printf $purple"\nall the tty's : \n"$reset
	who
	printf $purple"\nyours : "$reset"`tty`\n"
	printf "\ntty output ?\n"
	printf $yellow && read tty && printf $reset
	tty=`echo $tty | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
	if [ $tty ] 2>/dev/null
	then
		printf "New crontab output : "$green_coa"`echo $tty`\n"$reset
		printf "Confirm ? [y/n]\n"
		printf $yellow && read confirmation && printf $reset
		if [ $confirmation = "y" ] 2>/dev/null
		then
			printf "$tty\n" > $file_rem_o
		fi
	fi
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
