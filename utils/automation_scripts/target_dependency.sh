#!/bin/bash
target_packages=('stress' 'make' 'build-essential' 'linux-tools-generic' 'linux-tools-common' 'gcc g++' 'nfs-common' 'automake' 'autoconf' 'openjdk-7-jre' 'openjdk-7-jdk' 'mysql-server' 'libmysqlclient-dev')

clear
echo "TARGET"
echo -e "\n\t\t Target dependency"
for i in `seq 0 $((${#target_packages[@]}-1)) `
do
#checking to see if all the target dependent packages are installed
    check=`dpkg-query -W -f='${Status}' ${target_packages[$i]} | grep -c "ok installed"`
    if [ $check -eq 0 ] 
    then
       if [ $1 == "-f" ]
       then
            choice="y"
       else
           echo "\n\t\t${target_packages[$i]} is not installed, would you like to install(y/n)"
           read choice
       fi
           
       if [ $choice == 'y' ]
       then
            sudo dpkg --configure -a
            sudo apt-get update &
            wait
            sudo apt-get build-dep ${target_packages[$i]} -y &
            wait 
            sudo apt-get install ${target_packages[$i]} -y &
            wait
            if [ $? -ne 0 ]
            then
                echo -e "\n\t\t${target_packages[$i]} is not installed properly"
                exit 1
            fi
       else
            echo "Please install ${target_packages[$i]} and try again"
       fi
    else
       echo "${target_packages[$i]} is installed"
    fi

done

#mount a disk partition for fio testing
if [ ! -d "/mnt/sdb/" ]
then
    echo -e "\nCreating Mount Partition for fio testing\n"
    sudo mkdir -p /mnt/sdb/
	sudo chmod -R 775 /mnt/sdb
	sudo chown -R $USER:$USER /mnt/sdb
	if [ $? -ne 0 ]
	then
       echo -e "\nCreating a Mount Path for Fio testing Failed\n"
	   exit 1
    fi
else
        echo -e "\nMount Partition for fio testing Already exits\n"
fi

#copying the perf 
temp=`ls -lt /usr/lib/linux-tools/ | head -n 2 | awk -F ' ' '{print $9}'`
temp=${temp:1}
cp /usr/lib/linux-tools/$temp/perf /usr/bin/
if [ $? -ne 0 ]
then
    echo -e "\n\t\tFailed to cp the perf path"
    exit 1
fi

