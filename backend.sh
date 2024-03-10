source common.sh

Print_Task_Heading "Adding Application User"
id expense &>>$LOG
if [ $? -ne 0 ]; then
  useradd expense &>>$LOG
fi
Check_Status $?

Print_Task_Heading "Copy Backend Service file"
cp backend.service /etc/systemd/system/backend.service &>>$LOG
Check_Status $?

App_PreReq

Print_Task_Heading "Download NodeJS Dependencies"
cd /app &>>$LOG
npm install &>>$LOG
Check_Status $?

Print_Task_Heading "Start Backend Service"
systemctl daemon-reload &>>$LOG
systemctl enable backend &>>$LOG
systemctl start backend &>>$LOG
Check_Status $?

Print_Task_Heading "Install MySQL Client"
dnf install mysql -y &>>$LOG
Check_Status $?

Print_Task_Heading "Load Schema"
mysql -h mysql-dev.angadicnc.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOG
Check_Status $?