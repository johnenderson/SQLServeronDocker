# Criando pasta de scripts auxiliares

## Este passo não é necesssário, caso você já possua uma forma de organizar os scripts, pode seguir da sua forma porém tenha em mente que precisaremos guardar um script em algum local

1. Acesse a pasta root do seu WSL
    - Ex: `cd /root`
2. Crie uma pasta chamada scritps
    - Ex: `mkdir scripts`

## Salvando script de configuração/inicialização do servidor SQL Server

1. Acesse sua pasta de scripts auxiliares
    - Ex: cd `/root/scripts`
2. Crie um arquivo sh para salvar nosso script
    - Ex: `touch subir_mssql.sh`
3. Pelo windows, abra o arquivo e cole o código disponibilizado abaixo:

```bash
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
```

# Subindo o container
1. Para subir o nosso container, basta executar o script auxiliar
    - Ex: `sh ~/scripts/subir_mssql.sh`

# Fazendo portproxy para acessar no windows

No powershell em modo administrador, substitua a url pela mesma que você faz o uso para acessar a suite e execute os comandos

```powershell
netsh interface portproxy set v4tov4 listenport=1433 listenaddress=0.0.0.0 connectport=1433 connectaddress=<seu_dominio>
```

# Desfazendo portproxy
Execute os seguintes comandos:

```powershell
netsh interface portproxy delete v4tov4 listenport=1433 listenaddress=0.0.0.0
```

# Criando a base de dados

## Importando um bkp de base

...

# Dados disponíveis ao usar o container

Dados da base pra conexão com o servidor SQL Server:

Usuário: sa
Senha: Soft@123