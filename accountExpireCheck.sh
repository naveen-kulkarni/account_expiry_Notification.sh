#!/bin/bash

#lcUsers=$(cat paswd |awk  -F ":" '{ if ( $3 > 500 && $3 < 1000) print $1 }')
#echo $lcUsers
lcUsers=$(cat paswd |awk  -F ":" '{ if ( $3 > 500 && $3 < 1000) print $1 }')
#echo $lcUsers
usersIn=($lcUsers)
for users in "${usersIn[@]}"
#for users in naveen
do
 currentdate=$(date +%s)
 #userexp=$(chage -l $i | awk '/^Password expires/ { print $NF }')
 #userexp=$(cat paswd | awk '/^Password expires/ { print $4 $NF }')
 userexp=$(chage -l $users |egrep -w "Password expires" |awk -F":" '{print $2}')
#echo $userexp >ttt

#val=$(cat ttt)
#sal=("$val")

scale="$userexp"
 if [[ ! -z $userexp ]]
  then

#scale=('$userexp')
#if  [[ "$scale" -eq ^[0-9]+$ ]]
 #   then
             # echo "Sorry integers only"
#       echo "Password Never expires for $users"
 #else
        #echo "Its integers"

        # passexp=$(date -d "$userexp" "+%s")
 if [[ "$scale" -eq  "never" ]]
        then
        echo "Password Never expires for $users"   >>passNeveExp-`date +%F`
        #break

 else

         passexp=$(date -d "$userexp" "+%s")
    if [[ $passexp != "never" ]]
    then
      (( exp = passexp - currentdate))

      (( expday =  exp / 86400 ))

      if ((expday < 30 ))
      then
        echo "Password for $users will expire in $expday days i.e, on $userexp"  >> passExpire-`date +%F`
        # | mailx -s "Password for $i will expire in $expday day/s" $rcvr3,$rcvr2
      #  echo "Password Never expires for $users"
        fi
    fi
 fi
fi
done
expiryLogFile=passExpire-`date +%F`
if [ -f $expiryLogFile ]
then
        if [ -s $expiryLogFile ]
        then
                #echo "User alert! "
                cat $expiryLogFile
        else
                echo "Null Value "
        fi
else
           echo "File Not exist"
fi

#done
