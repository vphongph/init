# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    anniv_test.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vphongph <vphongph@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 04:26:41 by vphongph          #+#    #+#              #
#    Updated: 2019/04/25 06:55:16 by vphongph         ###   ########.fr        #
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

hello=`printf "lol lol"`

IFS=$'\n\t'


anniv=(`cat anniv_date`)
# test=("${hello}")
# echo ${test[0]}
# echo ${test[1]}

# quote=(`cat quote`)


# for t in ${anniv[@]}
# do
# 	echo $t
# done
# echo "Read file anniv"
#
# for t in ${quote[@]}
# do
# 	echo $t
# done
# echo "Read file quote"

currentdate=`date +"%d/%m"`
currentdate2=`date +"%d/%m %H:%M"`
currentdate3=`date +"%d-%m"`
currenttime=`date +"%H:%M"`

i=0

while ((i<${#anniv[@]})) || ((i<${#quote[@]}))
do
	if [ $currentdate = ${anniv[i]} ] || [ $currenttime = ${anniv[i]} ]
	then
		printf "C'est l'anniversaire de"$yellow" ${anniv[i+1]} "$blink"🎂"$reset"  !\n"
	fi
	if [ $currentdate3 = ${anniv[i]} ] 2>/dev/null || [ $currentdate2 = ${anniv[i]} ] 2>/dev/null
	then
		printf "${anniv[i+1]}\n"
	fi
	((i+=1))
done

printf $blue_light"Un rappel ? [y/n]\n"$reset

printf $yellow
read -r input
printf $reset

if [ $input = "y" ] 2>/dev/null
then
	echo lol
fi
