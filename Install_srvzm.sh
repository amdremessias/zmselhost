#!/bin/bash

# Este script instala o ZoneMinder no Debian/Ubuntu.
# amdrelmes@gmail.com 19072025.

echo "--- Instalação do ZoneMinder ---"
echo "Este script irá instalar o ZoneMinder no seu sistema."
echo "Certifique-se de que você tem privilégios de sudo."
echo ""
echo "
 ______________
||            ||
||            ||
||            ||
||            ||
||____________||
|______________|
 \\##############\\
  \\##############\\
   \      ____    \   
    \_____\___\____\... Iniciando Automação | @m3ss14s-2025

______________________________________________________

  #####                      ##     ##  ##            ##
  #  #                        ##  ###                 ##
 #  #                         ##  # #                 ##
   #      ##  ### ##   ##     ## ###   ##  ### ##   ###    ## ## ##
   #     #  #  # # #  # #    # #####    #   # # #  #  #   # #  ##
  #     #   #  ##  # ###     #  ## #    #   ##  # #  ##  ###   ##
 #   #  #  #   #  #  #  #    #  #  #    #   #  #  # ###  #  #  #
######  ###   ##  ## ####   ##    ###  ##  ##  ## #####  #### #


______________________________________________________  "

# Pergunta ao usuário se deseja instalar as dependências
read -p "Deseja instalar as dependências necessárias (recomendado)? (s/n): " install_deps

if [[ "$install_deps" =~ ^[Ss]$ ]]; then
    echo "Atualizando a lista de pacotes e instalando dependências..."
    sudo apt update
    sudo apt install -y software-properties-common wget curl
    sudo add-apt-repository -y ppa:iconnor/zoneminder-master
    sudo apt update
    sudo apt install -y zoneminder apache2 php libapache2-mod-php php-mysql php-gd php-imagick php-curl php-mbstring php-xml php-zip mariadb-server mariadb-client
    echo "Dependências instaladas."
else
    echo "Ignorando a instalação das dependências. Certifique-se de que elas estão instaladas manualmente."
fi

echo ""

# Configuração do banco de dados MySQL/MariaDB
echo "--- Configuração do Banco de Dados ---"
echo "O ZoneMinder precisa de um banco de dados."
echo "Será solicitado que você defina a senha para o usuário 'root' do MySQL/MariaDB (se ainda não estiver definida)."
echo "Você também precisará inserir uma senha para o usuário 'zmuser' do ZoneMinder."

read -p "Deseja configurar o banco de dados agora? (s/n): " configure_db

if [[ "$configure_db" =~ ^[Ss]$ ]]; then
    sudo mysql_secure_installation
    echo ""

    read -p "Digite a senha desejada para o usuário 'zmuser' do ZoneMinder: " zmuser_password
    sudo mysql -uroot -p <<MYSQL_SCRIPT
CREATE DATABASE zm;
CREATE USER 'zmuser'@'localhost' IDENTIFIED BY '$zmuser_password';
GRANT ALL PRIVILEGES ON zm.* TO 'zmuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT
    echo "Banco de dados configurado para ZoneMinder."
else
    echo "Ignorando a configuração do banco de dados. Você precisará configurá-lo manualmente."
    echo "Crie um banco de dados chamado 'zm' e um usuário 'zmuser' com acesso total a ele."
fi

echo ""

# Configuração do Apache2
echo "--- Configuração do Apache2 ---"
echo "Habilitando módulos Apache e configurando o ZoneMinder..."

sudo a2enmod cgi
sudo a2enmod rewrite
sudo a2enconf zoneminder
sudo systemctl enable zoneminder
sudo systemctl start zoneminder
sudo systemctl reload apache2

echo "Apache2 configurado para ZoneMinder."

echo ""

# Finalização
echo "--- Instalação Concluída ---"
echo "O ZoneMinder foi instalado com sucesso!"
echo "Você pode acessar a interface web do ZoneMinder através do seu navegador em:"
echo "http://localhost/zm"
echo "Ou, se estiver acessando de outra máquina, substitua 'localhost' pelo endereço IP do seu servidor."
echo ""
echo "É recomendável reiniciar o sistema para garantir que todas as configurações entrem em vigor."
read -p "Deseja reiniciar agora? (s/n): " reboot_now

if [[ "$reboot_now" =~ ^[Ss]$ ]]; then
    sudo reboot
else
    echo "Lembre-se de reiniciar o sistema mais tarde."
fi

echo "Script concluído."
echo "FIM - Parabens a Instalação e configuração do Viseron concluídas. "
echo "___________________________________________________________________"
"
echo "
   _____
  | ___ |
  ||   ||  M.C.
  ||___||
  |   _ |
  |_____|
 /_/_|_\_\----.
/_/__|__\_\   )
             (
             []


By
               /      \                     _/  |/  |  /  |          
 _____  ____  /$$$$$$  |  _______  _______ / $$ |$$ |  $$ |  _______ 
/     \/    \ $$ ___$$ | /       |/       |$$$$ |$$ |__$$ | /       |
$$$$$$ $$$$  |  /   $$< /$$$$$$$//$$$$$$$/   $$ |$$    $$ |/$$$$$$$/ 
$$ | $$ | $$ | _$$$$$  |$$      \$$      \   $$ |$$$$$$$$ |$$      \ 
$$ | $$ | $$ |/  \__$$ | $$$$$$  |$$$$$$  | _$$ |_     $$ | $$$$$$  |
$$ | $$ | $$ |$$    $$/ /     $$//     $$/ / $$   |    $$ |/     $$/ 
$$/  $$/  $$/  $$$$$$/  $$$$$$$/ $$$$$$$/  $$$$$$/     $$/ $$$$$$$/  

"
