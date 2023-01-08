# Criando pasta de scripts auxiliares

# Este passo não é necesssário, caso você já possua uma forma de organizar os scripts, pode seguir da sua forma porém tenha em mente que precisaremos guardar um script em algum local

Acesse a pasta do seu usuário
Ex: cd /home/compiani
Crie uma pasta chamada scritps
Ex: mkdir scripts

# Salvando script de configuração/inicialização da base

Acesse sua pasta de scripts auxiliares
Ex: cd /home/compiani/scripts
Crie um arquivo sh para salvar nosso script
Ex: touch subir_pg.sh
Pelo windows, abra o arquivo e cole o código disponibilizado abaixo


# Subindo o container
Para subir o nosso container, basta executar o script auxiliar
    Ex: sh ~/scripts/subir_pg.sh

# Fazendo portproxy para acessar no windows

No powershell em modo administrador, substitua a url pela mesma que você faz o uso para acessar a suite e execute os comandos
netsh interface portproxy set v4tov4 listenport=5432 listenaddress=0.0.0.0 connectport=5432 connectaddress=MUDE_AQUI.softexpert.com.br
netsh interface portproxy set v4tov4 listenport=9999 listenaddress=0.0.0.0 connectport=9999 connectaddress=MUDE_AQUI.softexpert.com.br

# Desfazendo portproxy
Execute os seguintes comandos:
netsh interface portproxy delete v4tov4 listenport=9999 listenaddress=0.0.0.0
netsh interface portproxy delete v4tov4 listenport=5432 listenaddress=0.0.0.0

# Criando a base de dados

# Importando um bkp de base

Acesse Q:\BackupBDs\PostgreSQL e copie um backup
Pelo window, acesse a pasta do seu usuário, observe que agora você possui uma pasta "postgres"
Ex:  \\wsl$\home\compiani
Acesse a pasta postgres/restore e coloque o backup da base
Ex: \\wsl$\home\compiani\postgres\restore
Execute no terminal do wsl o comando abaixo que irá importar o backup (Atenção para o nome da base e nome do arquivo a ser importado)
No exemplo abaixo estamos usando uma base nomeada dev
No exemplo abaixo estamos importando um arquivo nomeado 20200207_sesuite2_01_02.backup

# Dados disponíveis ao usar o container

Usuário do pgadmin: admin@admin.com
Senha do pgadmin: 111111


Dados da base pra conexão (sesuite):

Usuário: sesuite
Senha: 111111

Exemplo de uso no xml de configuração