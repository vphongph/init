# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    set_reminder.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vphongph <vphongph@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/26 01:20:45 by vphongph          #+#    #+#              #
#    Updated: 2019/04/26 01:23:58 by vphongph         ###   ########.fr        #
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

printf $blue_light"date ? time ? [dd/mm hh:MM]\n"$reset

printf $blue_light"date ? time ? [dd/mm hh:MM]\n"$reset

printf $yellow
read  lol
printf $reset

lol=`echo $lol | tr -d '\n\t'`

printf $blue_light"task ?\n"$reset

printf $yellow
read  mdr
printf $reset

printf $blue_light"password\n"$reset
printf $yellow
read  -s pass
printf $reset

echo $pass

mdr=`echo $mdr | tr -d '\n\t'`

if [ $lol ]
then
	echo prout
	echo $lol
fi
