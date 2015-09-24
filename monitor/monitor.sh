#!/bin/bash

echo "------------------------------------------------------"
echo "Beijing Servers:"
echo "------------------------------------------------------"
for number in 210 211 209 163 114
do
    echo 147.2.207.$number:
    sshpass -p ${password} ssh root@147.2.207.${number} screen -ls 
    retval=$?
    case ${retval} in
        255)
            ssh-keygen -R 147.2.207.${number} -f /home/jnwang/.ssh/known_hosts
            ssh root@147.2.207.${number} screen -ls
            ;;
        6)
            ssh root@147.2.207.${number} screen -ls
            ;;
    esac
done

echo "------------------------------------------------------"
echo "Nuermberg Servers:"
echo "------------------------------------------------------"

for number in 54 53
do
    echo 10.162.2.$number:
    sshpass -p ${password} ssh root@10.162.2.${number} screen -ls 
    retval=$?
    case ${retval} in
        255)
            ssh-keygen -R 10.162.2.${number} -f /home/jnwang/.ssh/known_hosts
            ssh root@10.162.2.${number} screen -ls
            ;;
        6)
            ssh root@10.162.2.${number} screen -ls
            ;;
    esac
done
