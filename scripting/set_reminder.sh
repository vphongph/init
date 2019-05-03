#!/bin/bash

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

r_entry=
r_date_time=
r_content=
r_confirmation=

r_crontab=
r_rate=
r_tty=

r_per_month_day=
count=0

file_cr="crontab_"

file_rem="reminder_"
file_rem_b="reminder_birthday"
file_rem_q="reminder_quote"
file_rem_t="reminder_task"
file_rem_o="reminder_output"

bool=0

printf "\nIf you're running this script for the first time, please run all \
the steps in the order.\n\n"$reset

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
	printf "New $r_entry : "$green_coa"$r_date_time $r_content\n"$reset
	printf "Confirm ? "$blue_light"[y/n]\n"$reset
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
		printf "New reminder output : "$green_coa"$r_tty\n"$reset
		printf "Confirm ? "$blue_light"[y/n]\n"$reset
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
	printf "every min ? hour ? day ? month ?"$blue_light" [min/hour/day/month]\n"$reset
	printf $yellow && read r_rate && printf $reset
fi

if [ $r_rate = "min" ] 2>/dev/null || [ $r_rate = "hour" ] 2>/dev/null
then
	printf "New crontab "$green_coa"$r_crontab"$reset" refresh time : \
"$green_coa"every $r_rate\n"$reset
	printf "Confirm ? "$blue_light"[y/n]\n"$reset
	printf $yellow && read r_confirmation && printf $reset
	if [ $r_confirmation = "y" ] 2>/dev/null
	then
		if [ $r_rate = "min" ]
		then
			printf "* * * * * FROM=$r_crontab bash run_reminder.sh > \
\`cat $file_rem_o\`\n" > $file_cr$r_crontab
		else
			printf "0 * * * * FROM=$r_crontab bash run_reminder.sh > \
\`cat $file_rem_o\`\n" > $file_cr$r_crontab
		fi
		bool=1
	fi
fi

if [ $r_rate = "day" ] 2>/dev/null || [ $r_rate = "month" ] 2>/dev/null
then
	if [ $r_rate = "day" ] 2>/dev/null
	then
		printf "What time each day ? "$blue_light"[hh:MM]\n"$reset
	else
		printf "What day and what time each month ? "$blue_light"[dd:hh:MM]\n"$reset
	fi
	printf $yellow && read r_per_month_day[count] && printf $reset
	r_per_month_day[count]=`echo ${r_per_month_day[count]} \
	| sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
fi

while [ ${r_per_month_day[count]} ]
do
	((count += 1))
	if [ $r_rate = "day" ] 2>/dev/null
	then
		printf "Another time ? "$blue_light"[hh:MM] "$reset"Press Enter if NO\n"
	else
		printf "Another day ? time ? "$blue_light"[dd:hh:MM] "$reset"Press Enter if NO\n"
	fi
	printf $yellow && read r_per_month_day[count] && printf $reset
	r_per_month_day[count]=`echo ${r_per_month_day[count]} \
	| sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
done

if [ ${r_per_month_day[0]} ] 2>/dev/null
then
	count=0
	if [ $r_rate = "day" ] 2>/dev/null
	then
		printf "New crontab "$green_coa"$r_crontab"$reset" refresh time, "\
$green_coa"every $r_rate at :\n"$reset
		while [ ${r_per_month_day[count]} ]
		do
			printf $green_coa"- ${r_per_month_day[count]}\n"$reset
			((count += 1))
		done
	else
		printf "New crontab "$green_coa"$r_crontab"$reset" refresh time, "\
$green_coa"every $r_rate on :\n"$reset
		while [ ${r_per_month_day[count]} ]
		do
			printf $green_coa"- `echo ${r_per_month_day[count]} \
			| cut -d':' -f1`th at `echo ${r_per_month_day[count]} \
			| cut -d':' -f2-3`\n"$reset
			((count += 1))
		done
	fi
	count=0
	printf "Confirm ? "$blue_light"[y/n]\n"$reset
	printf $yellow && read r_confirmation && printf $reset
	if [ $r_confirmation = "y" ] 2>/dev/null
	then
		count=0
		if [ $r_rate = "day" ] 2>/dev/null
		then
			printf "`echo ${r_per_month_day[count]} \
			| cut -d':' -f2` `echo ${r_per_month_day[count]} \
			| cut -d':' -f1` * * * FROM=$r_crontab bash run_reminder.sh \
> \`cat $file_rem_o\`\n" > $file_cr$r_crontab
			((count += 1))
			while [ ${r_per_month_day[count]} ]
			do
				printf "`echo ${r_per_month_day[count]} \
				| cut -d':' -f2` `echo ${r_per_month_day[count]} \
				| cut -d':' -f1` * * * FROM=$r_crontab bash run_reminder.sh \
> \`cat $file_rem_o\`\n" >> $file_cr$r_crontab
				((count += 1))
			done
			bool=1
		else
			printf "`echo ${r_per_month_day[count]} \
			| cut -d':' -f3` `echo ${r_per_month_day[count]} \
			| cut -d':' -f2` `echo ${r_per_month_day[count]} \
			| cut -d':' -f1` * * FROM=$r_crontab bash run_reminder.sh \
> \`cat $file_rem_o\`\n" > $file_cr$r_crontab
			((count += 1))
			while [ ${r_per_month_day[count]} ]
			do
				printf "`echo ${r_per_month_day[count]} \
				| cut -d':' -f3` `echo ${r_per_month_day[count]} \
				| cut -d':' -f2` `echo ${r_per_month_day[count]} \
				| cut -d':' -f1` * * FROM=$r_crontab bash run_reminder.sh \
> \`cat $file_rem_o\`\n" >> $file_cr$r_crontab
				((count += 1))
			done
			bool=1
		fi
	fi
fi


if [ $bool = 0 ]
then
	false
else
	true
fi
