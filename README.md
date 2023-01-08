# Criando pasta de scripts auxiliares

## Este passo não é necesssário, caso você já possua uma forma de organizar os scripts, pode seguir da sua forma porém tenha em mente que precisaremos guardar um script em algum local no Linux (WSL)

1. Acesse a pasta root do seu WSL
    - Ex: `cd /root`
2. Crie uma pasta chamada scritps
    - Ex: `mkdir scripts`

## Salvando script de configuração/inicialização do servidor SQL Server

1. Acesse sua pasta de scripts auxiliares
    - Ex: cd `/root/scripts`
2. Crie um arquivo sh para salvar nosso script
    - Ex: `touch subir_mssql.sh`
3. Pelo Windows ou Linux (WSL), abra o arquivo e cole o código disponibilizado abaixo, altere o parametro de senha do usuario SA `<YourStrong!Passw0rd>` conforme necessario:

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
   echo "         - MSSQL_SA_PASSWORD=<YourStrong!Passw0rd>";
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

# Acessando o Servidor de Banco de dados do Windows 

## Fazendo portproxy para acessar no windows

No powershell em modo administrador, substitua a url pela mesma que você faz o uso para acessar a suite e execute os comandos

```powershell
netsh interface portproxy set v4tov4 listenport=1433 listenaddress=0.0.0.0 connectport=1433 connectaddress=<seu_dominio>
```

***Obs.:** O portproxy só é necessário quando você quer conceder acesso de algo hospedado no WSL da sua maquina para outra máquina da rede que não seja a sua.*

##  Desfazendo portproxy

Execute os seguintes comandos:

```powershell
netsh interface portproxy delete v4tov4 listenport=1433 listenaddress=0.0.0.0
```
## Acessando o servidor de banco de dados no Windows

Basta apenas incluir o `[::1]` como host de conexão e tentar-se conectar com qualquer sistema gerenciador de banco de dados, por exemplo, DBeaver ou SQL Server Management Studio (SSMS).

O [::1] trata-se do endereço **IPv6** representado pelo endereço unicast 0:0:0:0:0:0:0:1 ou ::1 (equivalente ao endereço **IPv4** loopback 127.0.0.1).

# Criando a base de dados

## Fazendo restore de um de uma banco de dados pelo utilitario mssql-tools (Ferramenta de linha de comando do SQL Server no Linux)

Necessario executar o script abaixo, alterando os parametros conforme banco de dados a ser restaurado:

```bash
sudo docker exec -it sqlserver /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P '<YourStrong!Passw0rd>' -Q "RESTORE DATABASE [2-1-7] FROM DISK = N'/var/opt/mssql/restore/eqteste_2_01_07.bak' WITH MOVE 'eqteste_2_01_07' TO '/var/opt/mssql/data/eqteste_2_01_07.mdf', MOVE 'eqteste_2_01_07_Log' TO '/var/opt/mssql/data/eqteste_2_01_07.ldf'"
```

Mais infromações sobre como restaurar um banco de dados SQL Server em um contêiner do Docker em Linux utilizando o mssql-tools clique [aqui!](https://learn.microsoft.com/pt-br/sql/linux/sql-server-linux-setup-tools?view=sql-server-ver16) (este utilitario já esta instalado no container por padrão)

# Dados disponíveis ao usar o container

Dados da base pra conexão com o servidor SQL Server:

- Usuário: sa
- Senha: <YourStrong!Passw0rd>