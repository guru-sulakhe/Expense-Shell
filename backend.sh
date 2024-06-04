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

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enablinng nodjes version 20"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"

#useradd expense &>>$LOGFILE
#VALIDATE $? "Adding user expense"

#use the below code for idempotent nature in script

id expense &>>$LOGFILE # this is used for checking whether the expense user is created or not,and analysing the exit status
if [ $? -ne 0 ] #if the exit status is 1,then we need create expense user,if the exit status is 0 then expense user is already created skipping
then
    useradd expense &>>$LOGFILE
    VALIDATE $? "Adding user expense"
else
    echo -e "User is already created.. $Y SKIPPING $N"
fi