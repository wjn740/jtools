#!/bin/bash

echo "------------------------------------------------------"
echo "Beijing Servers:"
echo "------------------------------------------------------"
#210 
for number in 43 42 41 40 39 38 27 22 
do
    echo 10.67.130.$number:
    sshpass -p ${password} ssh root@10.67.130.${number} screen -ls 
    retval=$?
    case ${retval} in
        255)
            ssh-keygen -R 10.67.130.${number} -f /home/jnwang/.ssh/known_hosts
            ssh root@10.67.130.${number} screen -ls
            ;;
        6)
            ssh root@10.67.130.${number} screen -ls
            ;;
    esac
done
for number in 11
do
    echo 10.67.131.$number:
    sshpass -p ${password} ssh root@10.67.131.${number} screen -ls 
    retval=$?
    case ${retval} in
        255)
            ssh-keygen -R 10.67.131.${number} -f /home/jnwang/.ssh/known_hosts
            ssh root@10.67.131.${number} screen -ls
            ;;
        6)
            ssh root@10.67.131.${number} screen -ls
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
