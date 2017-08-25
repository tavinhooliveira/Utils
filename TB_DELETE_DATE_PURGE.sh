#!/bin/bash
#-----------------------------------------------------------------------------------------
#-- Database configuration
#-- Arquivo   : TB_UPDATE_DATE_PURGE.sh
#-- Autor     : Luis Oliveira
#-- Data      : 24/August/2017
#-- Descricao : Script used to purge base records Last Days - TB_TABLE
#-----------------------------------------------------------------------------------------
#
# 
#
#DB CONFIGURATIONS
USER='user';
PASSWORD='senha';
HOST='localhost';
PORT='8080';
SID='';
#
######SET VARIABLES
TABLE='TB_TABELA';
FIELD='CAMPO';
#
#DAYS CONFIGURATIONS
CLEAN_RECORDS_LAST_DAYS=2;
#
SYSDATE=$(date +"%Y-%m-%d %H:%M:%S");
#
#### CLEAN EXPURG RECORDS
#
CLEAN_RECORDS=$( 
echo "
ALTER SESSION ENABLE PARALLEL DML;
DELETE FROM $TABLE
WHERE (TO_DATe((SELECT SYSDATE FROM DUAL)) - TO_DATe($FIELD)) <= $CLEAN_RECORDS_LAST_DAYS;
exit
"  | sqlplus -s $USER/$PASSWORD@$HOST:$PORT/$SID
)
echo "EXECUTED SCRIPT EXPURG CLEAN RECORDS - DATE:$SYSDATE"
echo "DAYS CONFIGURATIONS = $CLEAN_RECORDS_LAST_DAYS"
echo "$CLEAN_RECORDS"
#
#
if [ $? == 0 ]
then
	echo "Script executed successfully."
else
	echo "Script executed with error(s)."
fi
