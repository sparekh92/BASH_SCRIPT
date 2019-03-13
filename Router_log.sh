#!/bin/bash
# Script to compare output of two files Pre.txt and Post.txt output from router 
# Created by Shailesh Parekh 
# Date: 03/05/2019  Rev:1

PS3='Please enter your choice: '
options=("Option 1" "Option 2" "Option 3" "Quit")
select opt in "${options[@]}"
do
	case $opt in
			"Option 1")
				echo "You Select choic 1"
				echo "Parse file -- Output file is "Pre_Parse.out" and "Post_Parse.out""
				/bin/rm -rf Pre_Parse.out
				while read -r line; do
					# Reading each line
					awk '{print $2}' | egrep ^[0-9]  >> Pre_Parse.out
					awk '{print $3}' | egrep ^[0-9]  >> Pre_Parse.out
					echo $line
				done < Pre.txt
				/bin/rm -rf Post_Parse.out
				while read -r line; do
					# Reading each line
					awk '{print $2}' | egrep ^[0-9]  >> Post_Parse.out
					awk '{print $3}' | egrep ^[0-9]  >> Post_Parse.out
					echo $line
				done < Post.txt
				;;
			"Option 2")
				echo "You Select choic 2"
				echo "What Routes are added or removed" 
				/bin/rm path_removed
				/bin/rm path_added
				diff Pre_Parse.out Post_Parse.out > diff_out
				egrep ^\< diff_out  | awk '{print $2}' > path_removed
				egrep ^\> diff_out  | awk '{print $2}' > path_added
				list=`cat path_removed`
				echo "Following Path removed"
				for i in $list
				do
					grep $i Pre.txt
				done
				list=`cat path_added`
				echo "Following Path Added"
				for i in $list
				do
					grep $i Post.txt
				done
				;;

			"Option 3")
				echo "You Select choice 3"
				echo "Summarize how many types of route there are -- BGP, OSPF, Connected"
				sed -e '1,8d' Pre.txt > Total_Route.txt
				sed -e '1,8d' Post.txt >> Total_Route.txt
				echo "Total "BGP" Uniq paths are"
				egrep   "^B [EI] |^ B [EI] |^  B [EI]" Total_Route.txt  | sort | uniq | wc -l
				echo "Total "OSPF" Uniq paths are"
				egrep  "^O+ |^O  [E|N][12]|^ O [EN][12]|^  O [EN][12] " Total_Route.txt | sort| uniq | wc -l
				echo "Total "Connected" uniq paths are"
				egrep "^[CSK]|^ [CSK]|^  [CSK]" Total_Route.txt | sort | uniq | wc -l
				;;
			"Quit")
				break
				;;
			*) echo "invalid option $REPLY";;
		esac
	done
