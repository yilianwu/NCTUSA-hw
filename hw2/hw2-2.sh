#!/bin/sh
DIALOG_OK=0
DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0
EDITOR=vim

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}
while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "System Information" \
    --title "SYS INFO" \
    --clear \
    --cancel-label "Cancel" \
    --menu "Please select:" $HEIGHT $WIDTH 5 \
    "1" "CPU INFO" \
    "2" "MEMORY INFO" \
    "3" "NETWORK INFO" \
    "4" "FILE BROWSER" \
    "5" "CPU INFO"\
    "6" "My number"\
    2>&1 1>&3)

  exit_status=$?
  exec 3>&-

  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      echo 0
      exit
      ;;
$DIALOG_ESC)
	exit
	;;

     * )
      echo $?
      ;;
  esac
  case $selection in
   # 0 )
    #  clear
     # echo "Program terminated."
      #;;
    1 )
      result=$(sysctl hw.model hw.machine hw.ncpu | sed 's/hw.model/CPU Model/g'|
	sed 's/hw.machine/CPU Machine/g' | sed 's/hw.ncpu/CPU Core/g')
      display_result "CPU Info"
      ;;
    2 )
	    var=0
      while [ ${#var} -ne 0 ] ;do
      totalmem=$(sysctl -n hw.physmem)
      usedmem=$(sysctl -n hw.usermem)
      freemem=`expr $totalmem - $usedmem`
      PERCENT=`expr 100 \* $usedmem / $totalmem`

      if [ $totalmem -gt 1048576 ] && [ $totalmem -lt 1073741824 ]; then
	    total=`echo "scale=2; $totalmem/1048576" | bc`
	    totalunit=MB
    elif [ $totalmem -gt 1073741824 ] && [$totalmem -lt 109951162776]; then
	    total=`echo "scale=2; $totalmem/1073741824" | bc`
	    totalunit=GB
    elif [ $totalmem -gt 1024 ] && [$totalmem -lt 1048576 ]; then
	    total=`echo "scale=2; $totalmem/1024" | bc`
	    totalunit=KB
      else
	    totalunit=Byte
      fi
      if [ $usedmem -gt 1048576 ] && [ $usedmem -lt 1073741824 ]; then
	    used=`echo "scale=2; $usedmem/1048576" | bc`
	    usedunit=MB
    elif [ $usedmem -gt 1073741824 ] && [$usedmem -lt 109951162776]; then
	    used=`echo "scale=2; $usedmem/1073741824" | bc`
	    usedunit=GB
    elif [ $usedmem -gt 1024 ] && [$usedmem -lt 1048576 ]; then
	    used=`echo "scale=2; $usedmem/1024" | bc`
	    usedunit=KB
      else
	    usedunit=Byte
      fi
      if [ $freemem -gt 1048576 ] && [ $freemem -lt 1073741824 ]; then
	    free=`echo "scale=2; $freemem/1048576" | bc`
	    freeunit=MB
    elif [ $freemem -gt 1073741824 ] && [$freemem -lt 109951162776]; then
	    free=`echo "scale=2; $freemem/1073741824" | bc`
	    freeunit=GB
    elif [ $freemem -gt 1024 ] && [$freemem -lt 1048576 ]; then
	    free=`echo "scale=2; $freemem/1024" | bc`
	    freeunit=KB
      else
	    freeunit=Byte
      fi
     # var=0
     # while [ ${#var} -ne 0 ] ;do
     	echo $PERCENT | dialog  \
	      --title "Memory Info and Usage" \
	      --gauge "Total : $total $totalunit \nUsed : $used $usedunit \nFree : $free $freeunit" 20 50 0

	read -t 1 var
      done
      ;;
    3 )
	    while true;do
	    exec 4>&1
	   net_select=$(dialog \
		   	--clear \
			--cancel-label "Cancel" \
		   	--menu "Network Interfaces" 20 50 4 \
		    	1 "$(ifconfig -l | cut -d ' ' -f 1)" \
		    	2 "$(ifconfig -l | cut -d ' ' -f 2)" \
		    	3 "$(ifconfig -l | cut -d ' ' -f 3)" \
		    	4 "$(ifconfig -l | cut -d ' ' -f 4)" 2>&1 1>&4)
	   exec 4>&-

	   case $net_select in
		   1 )  dialog \
			   --title "1" \
			   --msgbox "Interface Name : $(ifconfig -l | cut -d ' ' -f 1) \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 1) | grep ether | awk '{print "MAC:"$2}') \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 1) | grep "inet " | awk '{print "IPv4:"$2}') \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 1) | grep netmask | awk '{print "Netmask:"$4}') \n" 0 0
			;;
		   2 )	dialog \
			   --title "1" \
			   --msgbox "Interface Name : $(ifconfig -l | cut -d ' ' -f 2) \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 2) | grep ether | awk '{print "MAC:"$2}') \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 2) | grep "inet " | awk '{print "IPv4:"$2}') \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 2) | grep netmask | awk '{print "Netmask:"$4}') \n" 0 0
			;;
		   3 )	dialog \
			   --title "1" \
			   --msgbox "Interface Name : $(ifconfig -l | cut -d ' ' -f 3) \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 3) | grep ether | awk '{print "MAC:"$2}') \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 3) | grep "inet " | awk '{print "IPv4:"$2}') \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 3) | grep netmask | awk '{print "Netmask:"$4}') \n" 0 0
			;;
		   4 )	dialog \
			   --title "4" \
			   --msgbox "Interface Name : $(ifconfig -l | cut -d ' ' -f 4) \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 4) | grep ether | awk '{print "MAC:"$2}') \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 4) | grep "inet " | awk '{print "IPv4:"$2}') \n\
			   $(ifconfig -L $(ifconfig -l | cut -d ' ' -f 4) | grep netmask | awk '{print "Netmask:"$4}') \n" 0 0
			;;
		   * )
			break
			;;
		esac
	done
      ;;
    4 )
	    choose=1
	    while true;do
		    exec 5>&1
		    path=$(pwd)
	    up_list=$(file --mime-type .* | awk -F':' '{print $1 "\t" $2}')
	    down_list=$(file --mime-type * | awk -F':' '{print $1 "\t" $2}')
	    echo '@'$path'@'\n'@'$up_list'@'\n'@'$down_list'@'
	    choose=$(
	    dialog \
		    --clear \
		    --cancel-label "Cancel" \
		    --menu "$path" 20 50 0 \
		    $up_list \
		    $down_list 2>&1 1>&5)
	    5>&-
	    echo '%'$choose'$'
	    echo '$'${#choose}'%'
	    if [ ${#choose} -ne 0 ];then
	   	filetype=$(file -b --mime-type $choose | awk -F'/' '{print $1}')
	   	filename=$(file --mime-type ${choose} | awk -F':' '{print $1}')
		fileinfo=$(file $filename | awk -F': ' '{print $2}')
	   	filesize=$(wc -c $filename | awk '{print $1}')

		if [ $filesize -gt 1048576 ] && [ $filesize -lt 1073741824 ]; then
	    	fsize=`echo "scale=2; $filesize/1048576" | bc`
	    	funit=MB
    		elif [ $filesize -gt 1073741824 ] && [$filesize -lt 109951162776]; then
	    	fsize=`echo "scale=2; $filesize/1073741824" | bc`
	    	funit=GB
    		elif [ $filesize -gt 1024 ] && [$filesize -lt 1048576 ]; then
	    	fsize=`echo "scale=2; $filesize/1024" | bc`
	    	funit=KB
      		else
		fsize=$filesize
	    	funit=Byte
      	     fi
	   # echo '%'$filename'%'
	    else
	   	break;
	    fi
	    echo '@'$filetype'@'
	    case $filetype in
		   text )
			   thetime=$(stat -f %Sa $filename)
			  if dialog --title "It's a TXT file!" --yes-label "OK" --no-label "Touch" --yesno "<File Name>:$filename\n<File Info>:$fileinfo\n<File Size>:$fsize $funit\n<Time>:$thetime" 0 0; then
				 # break
			  else
				 # dialog --title "Info" --msgbox "False" 6 44
				# $EDITOR $filename
				touch $filename
			  fi

			    ;;
		    * )
			    break
			    ;;

	    esac

	    done

#	   dialog --title "text" --fselect /path/to/dir height width
#FILE=$(dialog --stdout --title "Please choose a file" --fselect $HOME/ 14 48)
#echo "${FILE} file chosen."

      ;;
5 )
	val=0
	while [ ${#val} -ne 0 ]; do
		cpu_usage=$(top -P | grep '^CPU' | awk -F', ' '{print $1 $3 " "$5}')
		cpu_used=$(top -P | grep '^CPU' | awk -F',' '{print $5}' | awk -F'%' '{print int($1)}')
		cpup=`echo "100-$cpu_used" | bc`
		echo "percent:" $cpup
		#dialog --clear;
		#sleep 0.1;
		echo $cpup | dialog  --title "CPU Loading..." \
			--gauge "$cpu_usage" 20 50 0;
		#sleep 0.5;

		read -t 1 val;
	done

	;;
6 ) 
		dialog --title \
			--no-collapse \
			--msgbox "W081001" 0 0;
		read -t 1 val;
	#	if [ ${#val} -eq 0 ]; then
	#		exit;
	#	fi


		
	#	stat -f %Sa
	#	touch 
	
	

	;;

    * )
      echo $?
      ;;
  esac
done
