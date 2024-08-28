#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "\nWelcome to My Salon, How can I help you?"
SERVICES() {
SERVICES=$($PSQL "select service_id, name from services order by service_id")

echo "$SERVICES" | while read SERVICE_ID BAR SERVICE
do
  echo "$SERVICE_ID) $SERVICE"
done
read SERVICE_ID_SELECTED
REQUESTED_SERVICE_ID=$($PSQL "select service_id from services where service_id='$SERVICE_ID_SELECTED'")
REQUESTED_SERVICE_NAME=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")
if [[ -z $REQUESTED_SERVICE_ID ]]
then
  SERVICES "I could not find that service. What would you like today?"
else
echo -e "\nYou have selected $REQUESTED_SERVICE_NAME"
echo -e "What's your phone number?"
read CUSTOMER_PHONE
NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
if [[ -z $NAME ]]
then
echo -e "\nWhat is your name ?"
read CUSTOMER_NAME
INSERT_CUSTOMER_INFO=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
else
echo -e "\nPlease choose a Appointment time"
read SERVICE_TIME
CUSTOM_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
echo "$CUSTOM_ID"
SERVICE_TIME_CHECK=$($PSQL "select time from appointments where time='$SERVICE_TIME'")
if [[ -z $SERVICE_TIME_CHECK ]]
then
  INSERT_APPOINTMENT_TIME=$($PSQL "insert into appointments(customer_id,service_id,time) values('$CUSTOM_ID','$REQUESTED_SERVICE_ID','$SERVICE_TIME')")
  echo "I have put you down for a $REQUESTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
else
  SERVICES "Sorry this time has taken please make an appointment to a different date"
fi
fi
fi
}
SERVICES
