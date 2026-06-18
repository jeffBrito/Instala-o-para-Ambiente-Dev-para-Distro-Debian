#!/bin/bash

echo "========================================================="
echo "Iniciando a configuração do Ambiente de Desenvolvimento..."
echo "========================================================="

# Atualiza os pacotes do sistema
echo "-> Atualizando os repositórios e pacotes do sistema..."
sudo apt update && sudo apt upgrade -y

# Instala dependências básicas e o Snap (caso seja um Debian puro ou Mint)
echo "-> Instalando dependências essenciais..."
sudo apt install -y curl wget gpg apt-transport-https software-properties-common snapd

# ---------------------------------------------------------
# 1. Ferramentas via APT (Repositórios Padrões)
# ---------------------------------------------------------
echo "-> Instalando Git e FileZilla..."
sudo apt install -y git filezilla

echo "-> Instalando Java JDK 21..."
sudo apt install -y openjdk-21-jdk

# ---------------------------------------------------------
# 2. Node.js, NPM e NPX (via NodeSource)
# ---------------------------------------------------------
echo "-> Instalando Node.js (LTS) e NPM..."
# O npx já vem embutido por padrão na instalação do npm
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# ---------------------------------------------------------
# 3. Brave Browser
# ---------------------------------------------------------
echo "-> Instalando Brave Browser..."
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

# ---------------------------------------------------------
# 4. AnyDesk
# ---------------------------------------------------------
echo "-> Instalando AnyDesk..."
wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo gpg --dearmor -o /usr/share/keyrings/anydesk-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/anydesk-keyring.gpg] http://deb.anydesk.com/ all main" | sudo tee /etc/apt/sources.list.d/anydesk.list
sudo apt update
sudo apt install -y anydesk

# ---------------------------------------------------------
# 5. Docker e Portainer (GUI do Docker)
# ---------------------------------------------------------
echo "-> Instalando Docker..."
# Utiliza o script oficial da Docker para garantir compatibilidade com qualquer Debian/Ubuntu
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# Adiciona o usuário atual ao grupo docker para não precisar usar 'sudo docker'
sudo usermod -aG docker $USER

echo "-> Instalando Portainer (Interface Gráfica para o Docker)..."
# Inicializa o serviço do Docker caso não esteja rodando
sudo systemctl start docker
sudo systemctl enable docker

# Cria o volume e sobe o contêiner do Portainer
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# ---------------------------------------------------------
# 6. Softwares via SNAP
# ---------------------------------------------------------
echo "-> Instalando Softwares via Snap (IDEs e Comunicação)..."
# O uso de classic é necessário para IDEs terem acesso ao sistema de arquivos de forma global

sudo snap install code --classic
sudo snap install intellij-idea-community --classic
sudo snap install android-studio --classic
sudo snap install dbeaver-ce
sudo snap install postman
sudo snap install spotify
sudo snap install telegram-desktop
sudo snap install discord
sudo snap install obs-studio

echo "========================================================="
echo "Instalação concluída com sucesso!"
echo "IMPORTANTE: O Node.js instalou o NPM e o NPX juntos."
echo "IMPORTANTE: Para aplicar as permissões do Docker, reinicie o computador ou faça logoff."
echo "Para acessar o gerenciador do Docker (Portainer), abra seu navegador em: https://localhost:9443"
echo "========================================================="