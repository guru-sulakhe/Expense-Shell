#!/bin/bash

USERID=$(id -u) #script execute and store the output in USERID
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m" #for red color
G="\e[32m" #for green color
Y="\e[33m"
N="\e[0m" #for normal color

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2.. $R FAILED $N"
    else
        echo -e "$2.. $G SUCCESSFUL $N" 
    fi
}

if [ $USERID -ne 0 ]
then
    echo "You dont have accees,only root user have access to install"
else
    echo "You are a super user"
fi

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysql"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysql"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
VALIDATE $? "Setting root password"