#!/bin/bash


USERID=$(id -u) #script execute and store the output in USERID
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPTNAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPTNAME-$TIMESTAMP.log
R="\e[31m" #for red color
G="\e[32m" #for green color
Y="\e[33m"
N="\e[0m" #for normal color
echo "Please enter db password: "
read -s mysql_root_password

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

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE
VALIDATE $? "Removing the default content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading the frontend content in tmp directory"

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "unzipping the fronend content in usr directory"

#check your repo and path
cp /home/ec2-user/Expense-shell/expense.conf /etc/nginx/default.d/expense.conf  #epense.conf consists of api calling to the backend server
VALIDATE $? "Copied expense conf"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"