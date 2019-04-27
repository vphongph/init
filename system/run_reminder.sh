# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    run_reminder.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vphongph <vphongph@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 04:26:41 by vphongph          #+#    #+#              #
#    Updated: 2019/04/27 01:25:50 by vphongph         ###   ########.fr        #
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

if [ $FROM = "birthday" ]
then
	birthday=(`cat reminder_birthday`)
fi

if [ $FROM = "quote" ]
then
	quote=(`cat reminder_quote`)
fi

if [ $FROM = "task" ]
then
	task=(`cat reminder_task`)
fi

date=`date +"%d/%m"`
date2=`date +"%d-%m"`
date_time=`date +"%d/%m %H:%M"`
time=`date +"%H:%M"`

i=0

while ((i < ${#birthday[@]})) && [ $FROM = "birthday" ] 2>/dev/null
do
	if [ $date = ${birthday[i]} ] || [ $time = ${birthday[i]} ] # || [ $date_time = ${birthday[i]} ]
	then
		echo -e "C'est l'anniversaire de"$yellow" ${birthday[i+1]} "$blink"🎂"$reset
	fi
	((i += 1))
done

i=0

while ((i < ${#quote[@]})) && [ $FROM = "quote" ] 2>/dev/null
do
	if [ $date = ${quote[i]} ] # || [ $time = ${quote[i]} ] || [ $date_time = ${quote[i]} ]
	then
		echo -e "${quote[i+1]}"
	fi
	((i += 1))
done

i=0

while ((i < ${#task[@]})) && [ $FROM = "task" ] 2>/dev/null
do
	if [ $date_time = ${task[i]} ] # || [ $time = ${task[i]} ] || [ $date = ${task[i]} ]
	then
		echo -e $green_coa"-> "$reset"${task[i+1]}"
	fi
	((i += 1))
done
