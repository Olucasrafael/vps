#! /bin/bash
# Data de criação: 18/04/2021
# Data de atualização: 30/04/2021
# Versão: 0.6
# Testado e homologado para a versão do Ubuntu Server 18.04.x ​​LTS x64
# Kernel >= 4.15.x
# Testado e homologado para a versão do Nginx 1.14, MariaDB 10.1, PHP 7.2.x, Perl 5.26.x, Python 2.x/3.x, PhpMyAdmin 4.6.x
#
#
# NGINX-1.14 (HTTP Server) -Servidor de Hospedagem de Páginas Web: https://www.nginx.com/
# MARIADB-10.1.x (SGBD) - Sistemas de Gerenciamento de Banco de Dados: https://mariadb.org/
# PHP-7.2 (Personal Home Page - PHP: Hypertext Preprocessor) - Linguagem de Programação Dinâmica para Web: http://www.php.net/
# PERL-5.26 - Linguagem de programação multiplataforma: https://www.perl.org/
# PYTHON-2.7 - Linguagem de programação de alto nível: https://www.python.org/
# PHPMYADMIN-4.6 - Aplicativo desenvolvido em PHP para administração do MariaDB pela Internet: https://www.phpmyadmin.net/
#
# Debconf - Sistema de configuração de pacotes Debian
# Site: http://manpages.ubuntu.com/manpages/bionic/man7/debconf.7.html
# Debconf-Set-Selections - insere novos valores no banco de dados debconf
# Site: http://manpages.ubuntu.com/manpages/bionic/man1/debconf-set-selections.1.html
#
# O módulo do PHP Mcrypt na versão 7.2 está descontinuado, para fazer sua instalação é recomendado usar
# o comando o Pecl e adição ou a operação pecl.php.net é instalado baseado em compilação do módulo.
#
#Site oficial: https://www.nginx.com/
#Site oficial: https://mariadb.org/
#Site oficial: https://www.php.net/
#Site oficial: https://pecl.php.net/
# Site oficial: https://www.php.net/manual/pt_BR/install.fpm.php
# Site oficial: https://www.perl.org/
#Site oficial: https://www.python.org/
#Site oficial: https://www.phpmyadmin.net/
#
# Variável da Data Inicial para calcular o tempo de execução do script (VARIÁVEL MELHORADA)
# opção do comando data: +%T (Hora)
HORAINICIAL= $( data +%T )
#
# Variáveis ​​para validar o ambiente, verificando se o usuário e "root", versão do ubuntu e kernel
# opções do comando id: -u (usuário), opções do comando: lsb_release: -r (release), -s (short),
# opções do comando uname: -r (liberação do kernel), opções do comando cut: -d (delimitador), -f (campos)
# opção do carácter: | (piper) Conectar a saída padrão com a entrada padrão de outro comando
# opção do shell script: acento crase ` ` = Executa comandos numa subshell, retornando o resultado
# opção do shell script: aspas simples ' ' = Protege uma string completamente (nenhum caractere é especial)
# opção do shell script: aspas duplas " " = Protege uma string, reconhece mas $, \ e ` como especiais
USUARIO= $( id -u )
UBUNTU= $( lsb_release -rs )
KERNEL= $( uname -r | cut -d ' . ' -f1,2 )
#
# Variável do caminho do Log dos Script utilizado nesse curso (VARIÁVEL MELHORADA)
# $0 (variável de ambiente do nome do comando)
# opção do comando | (piper): (Conecte a saída padrão com a entrada padrão de outro comando)
# opções do comando cut: -d (delimitador), -f (campos)
LOG= " /var/log/ $( echo $0  | cut -d ' / ' -f2 ) "
#
# Variáveis ​​de configuração do usuário root e senha do MariaDB para acesso via console e do PhpMyAdmin
USUÁRIO= " raiz "
SENHA= " pti@2018 "
NOVAMENTE= $SENHA
#
# Variáveis ​​de configuração e liberação de conexão remota para o usuário Root do MariaDB
# opções do comando GRANT: grant (permissão), all (todos privilégios), on (em ou na banco ou tabela),
# *.* (todos os bancos/tabelas) to (para), user@'%' (usuário @ localhost), identificado por (identificado
# por - senha do usuário)
# opções do comando UPDATE: usuário (tabela mysql), SET Senha=SENHA (colunas), WHERE (condição), Usuário (valor)
# opções do comando UPDATE: usuário (tabela mysql), SET plugin (colunas), WHERE (condição), Usuário (valor)
# opção do comando FLUSH privilégios (recarregar as permissões)
GRANTALL= " GRANT ALL ON *.* TO $USER @'%' IDENTIFICADO POR ' $PASSWORD '; "
UPDATE1045= " UPDATE user SET Password=PASSWORD(' $PASSWORD ') WHERE User=' $USER '; "
UPDATE1698= " UPDATE user SET plugin='' WHERE User=' $USER '; "
FLUSH= " PRIVILÉGIOS DE LIMPEZA; "
#
# Variáveis ​​de configuração do PhpMyAdmin
ADMINUSER= $USER
ADMIN_PASS= $SENHA
APP_PASSWORD= $SENHA
APP_PASS= $SENHA
WEBSERVER= " localhost "
#
# Exportando o recurso de Noninteractive do Debconf para não solicitar telas de configuração
export DEBIAN_FRONTEND= " não interativo "
#
# Verificando se o usuário é Root, Distribuição é >=18.04 e Kernel é >=4.15 <IF MELHORADO)
# [ ] = teste de expressão, && = operador lógico AND, == comparação de string, exit 1 = Maioria dos erros comuns na execução
Claro
if [ " $USUARIO "  ==  " 0 " ] && [ " $ UBUNTU "  ==  " 18.04 " ] && [ " $ KERNEL "  ==  " 4.15 " ]
	então
		echo -e " O usuário é Root, continuando com o script... "
		echo -e " Distribuição é >= 18.04.x, continuando com o script... "
		echo -e " Kernel é >= 4.15, continuando com o script... "
		dormir 5
	senão
		echo -e " Usuário não é Root ( $USUARIO ) ou Distribuição não é >=18.04.x ​​( $UBUNTU ) ou Kernel não é >=4.15 ( $ KERNEL ) "
		echo -e " Caso você não tenha cumprido o script com o comando -i "
		echo -e " Execute novamente o script para verificar o ambiente. "
		saída 1
fi
#
# Script de instalação do LEMP-Server no GNU/Linux Ubuntu Server 18.04.x
# opção do comando echo: -e (habilita) habilita interpretador, \n = (nova linha)
# opção do comando hostname: -I (todos os endereços IP)
# opção do comando sleep: 5 (segundos)
# opção do comando data: + (formato), %d (dia), %m (mês), %Y (ano 1970), %H (hora 24), %M (minuto 60)
# opção do comando cut: -d (delimitador), -f (campos)
echo -e " Início do script $0 em: ` date +%d/%m/%Y- " ( " %H:%M " ) " ` \n "  & >>  $ LOG
Claro
#
echo -e " Instalação do LEMP-SERVER no GNU/Linux Ubuntu Server 18.04.x\n "
echo -e " NGINX (HTTP Server) - Servidor de Hospedagem de Páginas Web - Porta 80/443 "
echo -e " Após a instalação do Nginx acesse a URL: http:// ` hostname -I | cut -d '  ' -f1 ` / "
echo -e " Testar a linguagem HTML acessando a URL: http:// ` hostname -I | cut -d '  ' -f1 ` /teste.html\n "
echo -e " MariaDB (SGBD) - Sistemas de Gerenciamento de Banco de Dados - Porta 3306 "
echo -e " Após a instalação do MariaDB acesse o console: mariadb -u root -p\n "
echo -e " PHP (Personal Home Page - PHP: Hypertext Preprocessor) - Linguagem de Programação Dinâmica para Web "
echo -e " Após a instalação do PHP acesse a URL: http:// ` hostname -I | cut -d '  ' -f1 ` /phpinfo.php\n "
echo -e " PERL - Linguagem de programação multi-plataforma\n "
echo -e " PYTHON - Linguagem de programação de alto nível\n "
echo -e " PhpMyAdmin - Aplicativo desenvolvido em PHP para administração do MariaDB pela Internet "
echo -e " Após a instalação do PhpMyAdmin acessar a URL: http:// ` hostname -I | cut -d '  ' -f1 ` /phpmyadmin\n "
echo -e , esse processo demora um pouco Aguarde do seu Link de Internet\ n "
dormir 5
#
echo -e " Adicionando o Repositório Universal do Apt, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	universo add-apt-repository & >>  $LOG
echo -e " Repositório adicionado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Adicionando o Repositório Multiversão do Apt, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	multiverso add-apt-repository & >>  $LOG
echo -e " Repositório adicionado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Atualizando as listas do Apt, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	apt update & >>  $LOG
echo -e " Listas atualizadas com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Atualizando o sistema, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (sim)
	apt -y atualização & >>  $LOG
echo -e " Sistema atualizado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Removendo softwares, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (sim)
	apt -y autoremove & >>  $LOG
echo -e " Software removidos com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Configurando as variáveis ​​do Debconf do MariaDB para o Apt, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando | (piper): (Conecte a saída padrão com a entrada padrão de outro comando)
	echo  " mariadb-server-10.1 mysql-server/root_password senha $PASSWORD "  | debconf-set-selections
	echo  " mariadb-server-10.1 mysql-server/root_password_again password $AGAIN "  | debconf-set-selections
	debconf-show mariadb-server-10.1 & >>  $LOG
echo -e " Variáveis ​​configuradas com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Instalando o LEMP-SERVER, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes), \ (bar left) quebra de linha na opção do apt
	apt -y instalar nginx mariadb-server mariadb-client mariadb-common php-fpm php-mysql \
	perl python mcrypt apt-transport-https & >>  $LOG
echo -e " Instalação do LEMP-SERVER feito com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Instalando as dependências do PHP do LEMP-SERVER, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (yes), \ (bar left) quebra de linha na opção do apt
	apt -y instalar php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc \
	php-zip php-cli php-json php-readline php-imagick php-bcmath php-apcu & >>  $LOG
echo -e " Dependências do PHP do LEMP-SERVER feito com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Configurando as variáveis ​​do Debconf do PhpMyAdmin para o Apt, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando | (piper): (Conecte a saída padrão com a entrada padrão de outro comando)
	echo  " phpmyadmin phpmyadmin/internal/skip-preseed boolean true "  | debconf-set-selections
	echo  " phpmyadmin phpmyadmin/dbconfig-install boolean true "  | debconf-set-selections
	echo  " phpmyadmin phpmyadmin/app-password-confirm password $APP_PASSWORD "  | debconf-set-selections
	echo  " phpmyadmin phpmyadmin/reconfigure-webserver multiselect $ WEBSERVER "  | debconf-set-selections
	echo  " phpmyadmin phpmyadmin/mysql/admin-user string $ADMINUSER "  | debconf-set-selections
	echo  " phpmyadmin phpmyadmin/mysql/admin-pass senha $ADMIN_PASS "  | debconf-set-selections
	echo  " phpmyadmin phpmyadmin/mysql/app-pass senha $APP_PASS "  | debconf-set-selections
	debconf-show phpmyadmin & >>  $LOG
echo -e " Variáveis ​​configuradas com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Instalando o PhpMyAdmin, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando apt: -y (sim)
	apt -y instalar phpmyadmin php-mbstring php-gettext php-dev libmcrypt-dev php-pear pwgen & >>  $LOG
echo -e " Instalação do PhpMyAdmin feita com sucesso!!!, continuando com o script...\n "
dormir 5
#				 
echo -e " Atualizando as dependências do PHP para o PhpMyAdmin, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando echo: | = (faz a função de Enter)
	# opção do comando cp: -v (verbose)
	atualização de canal pecl pecl.php.net & >>  $LOG
	eco  | pecl instalar mcrypt-1.0.1 & >>  $LOG
	cp -v conf/mcrypt.ini /etc/php/7.2/mods-available/ & >>  $LOG
	phpenmod mcrypt & >>  $LOG
	phpenmod mbstring & >>  $LOG
echo -e " Atualização das dependências feita com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Aplicando o Patch de Correção do PhpMyAdmin, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	cp -v conf/sql.lib.php /usr/share/phpmyadmin/libraries/ & >>  $LOG
	cp -v conf/plugin_interface.lib.php /usr/share/phpmyadmin/libraries/ & >>  $LOG
echo -e " Patch de correção aplicado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Criando o Link Simbólico do PhpMyAdmin, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando ln: -v (verboso), -s (simbólico)
	ln -vs /usr/share/phpmyadmin /var/www/html & >>  $LOG
echo -e " Link simbólico criado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Copiando os arquivos de teste do PHP phpinfo.php e do HTML teste.html, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	# opção do comando chown: -v (verbose), www-data (usuário), www-data (grupo)
	cp -v conf/phpinfo.php /var/www/html/phpinfo.php & >>  $LOG
	cp -v conf/teste.html /var/www/html/teste.html & >>  $LOG
	chown -v www-data.www-data /var/www/html/ *  & >>  $LOG
echo -e " Arquivos copiados com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Instalação do LEMP-Server e PhpMyAdmin feito com sucesso!!! pressione <Enter> para continuar. "
ler
dormir 5
#
echo -e " Atualizando os arquivos de configuração do Nginx, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	cp -v /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old & >>  $LOG
	cp -v conf/nginx.conf /etc/nginx/nginx.conf & >>  $LOG
	cp -v conf/default /etc/nginx/sites-available/default & >>  $LOG
echo -e " Arquivo atualizado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Editando o arquivo de configuração: nginx.conf, pressione <Enter> para continuar... "
	# opção do comando sleep: 3 (segundos)
	ler
	dormir 3
	vim /etc/nginx/nginx.conf
echo -e " Arquivo editado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Editando o arquivo de configuração: default, pressione <Enter> para continuar... "
	# opção do comando sleep: 3 (segundos)
	ler
	dormir 3
	vim /etc/nginx/sites-available/default
echo -e " Arquivo editado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Atualizando os arquivos de configuração do PHP-FPM, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	# opção do comando sleep: 3 (segundos)
	cp -v /etc/php/7.2/fpm/php.ini /etc/php/7.2/fpm/php.ini.old & >>  $LOG
	cp -v conf/php.ini /etc/php/7.2/fpm/php.ini & >>  $LOG
echo -e " Arquivos atualizados com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Editando o arquivo de configuração: php.ini, pressione <Enter> para continuar... "
	# opção do comando sleep: 3 (segundos)
	ler
	dormir 3
	vim /etc/php/7.2/fpm/php.ini
echo -e " Arquivo editado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Reinicializando os serviços do PHP-FPM e Nginx, aguarde... "
	systemctl reinicie php7.2-fpm & >>  $LOG
	systemctl reinicie o nginx & >>  $LOG
echo -e " Serviços restaurados com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Permitindo o Root do MariaDB se autenticar, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando mysql: -u (usuário), -p (senha) -e (executar), mysql (banco de dados)
	mariadb -u $USER -p $PASSWORD -e " $GRANTALL " mysql & >>  $LOG
	mariadb -u $USER -p $PASSWORD -e " $UPDATE1045 " mysql & >>  $LOG
	mariadb -u $USER -p $PASSWORD -e " $UPDATE1698 " mysql & >>  $LOG
	mariadb -u $USER -p $PASSWORD -e " $FLUSH " mysql & >>  $LOG
echo -e " Permissão alterada com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Atualizando o arquivo de configuração do MariaDB, aguarde... "
	# opção do comando: &>> (redirecionar a saída padrão)
	# opção do comando cp: -v (verbose)
	cp -v /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.old & >>  $LOG
	cp -v conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf & >>  $LOG
echo -e " Arquivo atualizado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Editando o arquivo de configuração: 50-server.cnf, pressione <Enter> para continuar... "
	# opção do comando sleep: 3 (segundos)
	ler
	dormir 3
	vim /etc/mysql/mariadb.conf.d/50-server.cnf
echo -e " Arquivo editado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Reinicializando o serviço do MariaDB, aguarde... "
	systemctl reinicie mariadb & >>  $LOG
echo -e " Serviço reinicializado com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Verificando as portas de Conexão do Nginx e do MariaDB, aguarde... "
	# opção do comando netstat: a (todos), n (numérico)
	# opção do comando grep: ' ' (aspas simples) protege uma string, \| (Escape e opção OU)
	netstat -an | grep ' 80\|3306 '
echo -e " Portas verificadas com sucesso!!!, continuando com o script...\n "
dormir 5
#
echo -e " Instalação do LEMP-SERVER feito com Sucesso!!! "
	# script para calcular o tempo gasto (SCRIPT MELHORADO, CORRIGIDO FALHA DE HORA:MINUTO:SEGUNDOS)
	# opção do comando data: +%T (Hora)
	HORAFINAL= ` data +%T `
	# opção do comando data: -u (utc), -d (data), +%s (segundo desde 1970)
	HORAINICIAL01= $( date -u -d " $HORAINICIAL " + " %s " )
	HORAFINAL01= $( date -u -d " $HORAFINAL " + " %s " )
	# opção do comando data: -u (utc), -d (data), 0 (comando de string), sec (força segundo), +%H (hora), %M (minuto), %S (segundo),
	TEMPO= ` data -u -d " 0 $HORAFINAL01 seg - $HORAINICIAL01 seg " + " %H:%M:%S " `
	# $0 (variável de ambiente do nome do comando)
	echo -e " Tempo gasto para execução do script $0 : $TEMPO "
echo -e pressione " <Enter> para o processo completo. "
# opção do comando data: + (formato), %d (dia), %m (mês), %Y (ano 1970), %H (hora 24), %M (minuto 60)
echo -e " Fim do script $0 em: ` date +%d/%m/%Y- " ( " %H:%M " ) " ` \n "  & >>  $LOG
ler
saída 1