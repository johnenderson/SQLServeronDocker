#!/bin/bash

DEFAULT_USER_PATH="/root"
sqlServerFile=$DEFAULT_USER_PATH/scripts/sqlserver.yml

echo "Creating directories for MSSQL"
sudo mkdir -p  $DEFAULT_USER_PATH/mssql/data $DEFAULT_USER_PATH/mssql/restore $DEFAULT_USER_PATH/mssql/log $DEFAULT_USER_PATH/mssql/secrets

echo "Setting permissions on MSSQL directories"
sudo chmod -R 777 $DEFAULT_USER_PATH/mssql 
sudo chown -R 999:999 $DEFAULT_USER_PATH/mssql

echo "Navigating to sqlserver folder"
cd $DEFAULT_USER_PATH/scripts

if [ ! -f "$sqlServerFile" ]; then
  echo "Creating sqlserver configuration file"
  {
   echo "version: '3'";
   echo "";
   echo "services:";
   echo "   sqlserver":
   echo "      container_name: sqlserver";
   echo "      hostname: sqlserver";
   echo "      image: mcr.microsoft.com/mssql/server:2019-latest";
   echo "      environment:";
   echo "         - ACCEPT_EULA=Y";
   echo "         - MSSQL_SA_PASSWORD=Soft@123";
   echo "         - MSSQL_PID=Developer";
   echo "      ports:";
   echo "         - \"1433:1433\"";
   echo "      volumes:";
   echo "         - /root/mssql/data:/var/opt/mssql/data";
   echo "         - /root/mssql/restore:/var/opt/mssql/restore";
   echo "         - /root/mssql/log:/var/opt/mssql/log";
   echo "         - /root/mssql/secrets:/var/opt/mssql/secrets";
  } >> sqlserver.yml
fi

sudo docker-compose -f $sqlServerFile up -d