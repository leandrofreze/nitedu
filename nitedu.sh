#!/bin/bash
echo
echo "#############################################"
echo "#############################################"
echo "###                                       ###"
echo "### Configuração para Niterói Educacional ###"
echo "###                                       ###"
echo "#############################################"
echo "#############################################"
echo

# Primeira Parte

# Verificando e copiando o script para uma pasta dentro do /etc

if [ -e "/etc/installer/nitedu.sh" ]; then
	echo
else
	if [ -e "nitedu.sh" ]; then
		if [ -d "/etc/installer/" ]; then
			echo
			sudo chmod -v g=rx,o=rx /etc/installer/
			echo
			sudo cp -av nitedu.sh /etc/installer/nitedu.sh
			echo
			sudo chmod -v +x /etc/installer/nitedu.sh
			echo
		else
			sudo mkdir -v /etc/installer/
			echo
			sudo chmod -v g=rx,o=rx /etc/installer/
			echo
			sudo cp -av nitedu.sh /etc/installer/nitedu.sh
			echo
			sudo chmod -v +x /etc/installer/nitedu.sh
			echo
		fi
	fi
fi

# Verificando se existe atalho no inicio automático após o login
# Se não existir remove o LightLocker, copia atalho para /etc/xdg/autostart/, instala expect e o gksu e atualiza o sistema
# Se existe apaga o arquivo de script em qualquer outra pasta do sistema e continua a configuração

if [ -e "/etc/xdg/autostart/config.desktop" ]; then
	cd /
	ren=`sudo find -name nitedu.sh | grep -v installer `
	if [ -z $ren ]; then
		echo
	else
		sudo rm -v $ren
		echo
	fi
else
	echo
	sudo sed -i '/main/a auth-polkit=false' /etc/NetworkManager/NetworkManager.conf
	echo
	sudo service network-manager restart
	echo
	echo "########################################################"
	echo "###                                                  ###"
	echo "###         Por favor, configure a internet          ###"
	echo "###                                                  ###"
	echo "### Verifique se está habilitado para todos usuários ###"
	echo "###                                                  ###"
	echo "### Tecle ENTER para continuar                       ###"
	echo "###                                                  ###"
	echo "########################################################"
	echo
	read enter
	echo
	sudo rm -v /var/lib/dpkg/lock
	echo
	prog=`dpkg -l | grep megatools | awk '{ print $2 }'`
	if [ -z $prog ]; then
		sudo apt-get update
		echo
		sudo apt-get install -y megatools
		echo
	else
		echo
	fi
	sudo apt-get purge -y thunderbird pidgin pidgin-data transmission-gtk transmission-common gigolo xfce4-notes orage gnome-software
	echo

	# Pergunta se a instalação é em notebook ou desktop
	echo "## A instalação será em notebook? (S/N) ##"
	read note
	
	count=0
	while [ $count = 0 ]; do
		echo
		echo "## Usar apt-mirror? (S/N) ##"
		echo
		read aptmirror
		echo
		cd /etc/installer/
		if [ -e "/etc/installer/sources_xubuntu16.list" ]; then
			echo
		else
			sudo megadl https://mega.nz/#!pSBlTbyK!sTMnnf5igDA8hdNuGth0fTShc-RPUNRLaJXPZ-Yp72o
			echo
		fi
		case $aptmirror in
			S|s)
				if [ -e "/etc/installer/sources_aptmirror.list" ]; then
					echo
				else
					sudo megadl https://mega.nz/#!VKAwxRDT!dX50VvlUeEkAeOEPBAzQSAkWF8s_SFQSiq1yn7c08gA
					echo
				fi
				sudo cp -v sources_aptmirror.list /etc/apt/sources.list
				echo
				count1=0
				while [ $count1 = 0 ]; do
					echo "## Qual ip do servidor apt-mirror? ##"
					echo
					read ip
					echo
					echo "Ip digitado: " $ip
					echo
					ping $ip -c 4
					echo
					echo "# Está correto? (S/N) #"
					read correct
					echo
					case $correct in
						S|s)
							count1=1
							;;
						N|n)
							count1=0
							echo
							;;
						*)
							echo "Desculpe, opção inválida. Por favor, tente novamente..."
							echo
							count1=0
							;;
						esac
				done
				sudo sed -i 's/trocaip/'$ip'/g' /etc/apt/sources.list
				echo
				count=1
			;;
			N|n)
				echo
				sudo cp -v sources_xubuntu16.list /etc/apt/sources.list
				echo
				count=1
			;;
			*)
				echo "Desculpe, opção inválida. Por favor, tente novamente..."
				echo
				count=0
			;;
		esac
	done
	echo
	sudo touch /etc/installer/log
	echo
	sudo chown -v $USER /etc/installer/log
	echo
	echo "### Configuração para Niterói Educacional ###" > /etc/installer/log
	if [ -e "/usr/bin/light-locker" ]; then
		sudo apt-get purge -y light-locker
		echo
	fi
	if [ -e "/etc/xdg/autostart/update-notifier.desktop" ]; then
		sudo mv -v /etc/xdg/autostart/update-notifier.desktop /etc/installer/update-notifier.desktop
		echo
	fi
	if [ -e "/etc/installer/compton.desktop" ]; then
		sudo apt-get install -y compton
		echo
		sudo mv -v /etc/installer/compton.desktop /etc/xdg/autostart/compton.desktop
		echo
	else
		sudo megadl https://mega.nz/#!hKhn2ASB!dtnDRcL_ZMHJbeod7NRz5fHpYR8dEdqAE7T_b6uD_T0
		echo
		sudo apt-get install -y compton
		echo
		sudo mv -v /etc/installer/compton.desktop /etc/xdg/autostart/compton.desktop
		echo
	fi
	if [ -e "/etc/installer/compton.conf" ]; then
		echo
	else
		sudo megadl https://mega.nz/#!JPRBGALa!prGTwUdeMFfOaHU9Gg7LU2p6Ybsdw8TupIZVGSf_Fy0
		echo
	fi
	if [ $note = s ] || [ $note = S ]; then
		if [ -e "/etc/installer/71-numlock.conf" ]; then
			sudo rm -v /etc/installer/71-numlock.conf
			echo
		fi
	else
		if [ -e "/etc/installer/71-numlock.conf" ]; then
			sudo apt-get install -y numlockx
			echo
			sudo mv -v /etc/installer/71-numlock.conf /usr/share/lightdm/lightdm.conf.d/71-numlock.conf
			echo
		else
			sudo megadl https://mega.nz/#!hGw1zDiL!xOCQiYjYO2Xnh6EcKv7DEbV7qy55ocCD6gwf3r7U4b0
			echo
			sudo apt-get install -y numlockx
			echo
			sudo mv -v /etc/installer/71-numlock.conf /usr/share/lightdm/lightdm.conf.d/71-numlock.conf
			echo
		fi
	fi	
	if [ -e "/etc/installer/xfwm4.xml" ]; then
		sudo mv -v /etc/xdg/xdg-ubuntu/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml /etc/xdg/xdg-ubuntu/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml.bkp
		echo
		cp -v /etc/installer/xfwm4.xml /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
		echo
		sudo mv -v /etc/installer/xfwm4.xml /etc/xdg/xdg-ubuntu/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
		echo
	else
		sudo megadl https://mega.nz/#!QHBHUDrJ!d3mw8nolmnu2wzjhoaIPL1Bi6Dll1hjppU0CRzgMKSA
		echo
		sudo mv -v /etc/xdg/xdg-ubuntu/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml /etc/xdg/xdg-ubuntu/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml.bkp
		echo
		cp -v /etc/installer/xfwm4.xml /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
		echo
		sudo mv -v /etc/installer/xfwm4.xml /etc/xdg/xdg-ubuntu/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
		echo
	fi
	cd /etc/installer/
	if [ -e "/etc/installer/release-upgrades" ]; then
		sudo mv -v /etc/update-manager/release-upgrades /etc/update-manager/release-upgrades.bkp
		echo
		sudo mv -v /etc/installer/release-upgrades /etc/update-manager/release-upgrades
		echo
	else
		sudo megadl https://mega.nz/#!xapiFCrD!flFmr6bS-E-pg974_Eyc5fnFtuRJQ2vMXk-mDkZZ2zA
		echo
		sudo mv -v /etc/update-manager/release-upgrades /etc/update-manager/release-upgrades.bkp
		echo
		sudo mv -v /etc/installer/release-upgrades /etc/update-manager/release-upgrades
		echo
	fi	
	if [ -e "/etc/installer/config.desktop" ]; then
		echo
	else
		sudo megadl https://mega.nz/#!RWZQzZqb!EIq9iiKgS1iHhgviXWHd9vvdHS8fvjHgKWPbnivhj78
		echo
	fi	
	sudo chmod -v +x config.desktop
	echo
	sudo mv -v config.desktop /etc/xdg/autostart/
	echo
	echo "#####################################"
	echo "##                                 ##"
	echo "##       Atualizando sistema       ##"
	echo "##                                 ##"
	echo "#####################################"
	echo
	sudo apt-get update
	echo
	sudo apt-get install -y expect gksu
	echo
	if [ -e "/etc/installer/password_root.sh" ]; then
		echo
	else
		sudo megadl https://mega.nz/#!cWhmkYKb!-iLCb9SICsQlu8ONSDnLos_xne86agmPuVnL46Bt2XA
		echo
	fi	
	sudo chmod -v +x password_root.sh
	echo
	sudo ./password_root.sh
	echo
	sudo rm password_root.sh
	echo
	if [ -e "/etc/installer/nopasswd4sudo.sh" ]; then
		echo
	else
		sudo megadl https://mega.nz/#!tPwiVbCK!t-iwg5xh1su9KkxhaJWhdnIbbCxWT2-YyyYIvjQPnf0
		echo
	fi	
	if [ -e "/etc/installer/sudoers.ne" ]; then
		echo
	else
		sudo megadl https://mega.nz/#!tapTCZYK!ISlRpNLaXAyNkFsjMrhI0dK_i9JsDG37s5R2e3nCja8
		echo
	fi	
	sudo mv -v sudoers.ne /etc/sudoers.ne
	echo
	sudo chmod -v +x nopasswd4sudo.sh
	echo
	sudo ./nopasswd4sudo.sh
	echo
	sudo rm -v nopasswd4sudo.sh
	echo
	cd /etc/installer/
	if [ -e "/etc/installer/lightdm.conf.tec" ]; then
		echo
	else
		sudo megadl https://mega.nz/#!oaYgSQja!e-az25tCtx2GAAzqR1JLUM_j6WqfpWi4jq36L9CWeFQ
		echo
	fi	
	sudo cp -v lightdm.conf.tec /etc/lightdm/lightdm.conf
	echo
	sudo apt-get dist-upgrade -y
	echo
	echo "#####################################"
	echo "##                                 ##"
	echo "##      Reiniciando o sistema      ##"
	echo "##                                 ##"
	echo "#####################################"
	echo
	sudo reboot
fi

# Segunda Parte

# Continua a configuração
# Verifica qual a resolução do monitor e copia os arquivos de plano de fundo e Plymouth

echo
echo "######################################"
echo "##                                  ##"
echo "##     Iniciando a configuração     ##"
echo "##                                  ##"
echo "######################################"
echo
res1=`xrandr | grep current | awk '{ print $8 }'`
res2=`xrandr | grep current | awk '{ print $10 }' | sed 's/,*$//'`
res=`echo "scale=2; $res1 / $res2" | bc`
BC=`echo "$res < 1.33" | bc`
echo
echo "##############################################"
echo "##                                          ##"
echo "##       Configurando papel de parede       ##"
echo "##                                          ##"
echo "##############################################"
echo
case $BC in
	0) 
		cd /etc/installer/
		if [ -e "/etc/installer/desktop-16-9.png" ]; then
			echo
		else
			sudo megadl https://mega.nz/#!UTwywAqB!n6t0MwFMKYDmc-hvNVNWXy5vV8xldepiM5A4Cufe_Vw
			echo
		fi
		sudo mv -v /usr/share/xfce4/backdrops/xubuntu-wallpaper.png /usr/share/xfce4/backdrops/xubuntu-wallpaper.png.bak
		echo
		sudo mv -v desktop-16-9.png /usr/share/xfce4/backdrops/xubuntu-wallpaper.png
		echo
		if [ -e "/etc/installer/desktop-4-3.png" ]; then
			sudo rm -v desktop-4-3.png
			echo
		fi	
		if [ -e "/etc/installer/wallpaper-16-9.png" ]; then
			echo
		else
			sudo megadl https://mega.nz/#!xGwyzIrK!Oj3H1clhUaew_5U8LnTsqQnwO3tUPrOypzytPajYSLo
			echo
		fi	
		sudo mv -v /usr/share/plymouth/themes/xubuntu-logo/wallpaper.png /usr/share/plymouth/themes/xubuntu-logo/wallpaper.png.bak
		echo
		sudo mv -v wallpaper-16-9.png /usr/share/plymouth/themes/xubuntu-logo/wallpaper.png
		echo
		if [ -e "/etc/installer/wallpaper-4-3.png" ]; then
			sudo rm -v wallpaper-4-3.png
			echo
		fi	
	;;
	1) 
		cd /etc/installer/
		if [ -e "/etc/installer/desktop-4-3.png" ]; then
			echo
		else
			sudo megadl https://mega.nz/#!IC5lzZgC!2rOJ0PRk108p6OelYHlMzbTY_vKarjn5BnxfmAfuvNQ
			echo
		fi	
		sudo mv -v /usr/share/xfce4/backdrops/xubuntu-wallpaper.png /usr/share/xfce4/backdrops/xubuntu-wallpaper.png.bak
		echo
		sudo mv -v desktop-4-3.png /usr/share/xfce4/backdrops/xubuntu-wallpaper.png
		echo
		if [ -e "/etc/installer/desktop-16-9.png" ]; then
			sudo rm -v desktop-16-9.png
			echo
		fi	
		if [ -e "/etc/installer/wallpaper-4-3.png" ]; then
			echo
		else
			sudo megadl https://mega.nz/#!EepHHYKJ!rc_C4GRRhaQEeP5L7tZVERte5O74oN9_-NY8bVplQlM
			echo
		fi	
		if [ -e "/etc/installer/wallpaper-16-9.png" ]; then
			sudo rm -v wallpaper-16-9.png
			echo
		fi	
		sudo mv -v /usr/share/plymouth/themes/xubuntu-logo/wallpaper.png /usr/share/plymouth/themes/xubuntu-logo/wallpaper.png.bak
		echo
		sudo mv -v wallpaper-4-3.png /usr/share/plymouth/themes/xubuntu-logo/wallpaper.png
		echo
	;;
esac
if [ -e "/etc/installer/logo_16bit.png" ]; then
	echo
else
	sudo megadl https://mega.nz/#!lbJhwAbR!BfidmxU89G6a_nsKc6ktISSkUucYrBjO368r0hU_GHo
	echo
fi	
if [ -e "/etc/installer/logo.png" ]; then
	echo
else
	sudo megadl https://mega.nz/#!USAGxCLD!ZJzs_lt6Bo3Mi0gp8kziIxg3vnNidEMFUPQCHR5dGIQ
	echo
fi	
sudo mv -v /usr/share/plymouth/themes/xubuntu-logo/logo_16bit.png /usr/share/plymouth/themes/xubuntu-logo/logo_16bit.png.bak
echo
sudo mv -v /usr/share/plymouth/themes/xubuntu-logo/logo.png /usr/share/plymouth/themes/xubuntu-logo/logo.png.bak
echo
sudo mv -v /etc/installer/logo_16bit.png /usr/share/plymouth/themes/xubuntu-logo/logo_16bit.png
echo
sudo mv -v /etc/installer/logo.png /usr/share/plymouth/themes/xubuntu-logo/logo.png
echo
echo -n "5 " && sleep 1 && echo -n "4 " && sleep 1 && echo -n "3 " && sleep 1 && echo -n "2 " && sleep 1 && echo -n "1 " && sleep 1 && echo "0"
echo

# Copia os arquivos de configuração do painel, menus e imagens (para ser usado no skel)

echo
echo "########################################"
echo "##                                    ##"
echo "##     Configurando Painel e Menu     ##"
echo "##                                    ##"
echo "########################################"
echo
cd /etc/installer/
if [ -e "/etc/installer/panel.tar" ]; then
	echo
else
	sudo megadl https://mega.nz/#!lLI2TbRL!3ptzhrifA92JOrn4e7HCZj51GaonULMnfa9OIQK9Izc
	echo
fi	
if [ -d "/home/"$USER"/.config/xfce4/panel/" ]; then
	echo
else
	mkdir -v /home/"$USER"/.config/xfce4/panel/
	echo
fi	
echo
cp -v panel.tar /home/"$USER"/.config/xfce4/panel/panel.tar
echo
cd /home/"$USER"/.config/xfce4/panel/
sudo tar -xvf panel.tar
echo
sudo rm -v panel.tar
echo
sudo rm -v /etc/installer/panel.tar
echo
cd /etc/installer
if [ -e "/etc/installer/xfce4-panel.xml" ]; then
	echo
else
	sudo megadl https://mega.nz/#!8epmADDR!ppqJc30yqwVcyTuUAy8C8gZPDUmn9fddwViTpuMuR9A
	echo
fi	
if [ -e "/etc/installer/xfce4-desktop.xml" ]; then
	echo
else
	sudo megadl https://mega.nz/#!QOJhGbgK!1L0fBGTijbbdRE4KZUsREcMp47Q_OtUEOpUZ937z0tk
	echo
fi	
sudo cp -v /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml.bak
echo
sudo cp -v /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml.bak
echo
cp -v xfce4-panel.xml /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
echo
cp -v xfce4-desktop.xml /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml 
echo
sudo rm -v xfce4-desktop.xml
echo
sudo rm -v xfce4-panel.xml
echo
if [ -e "/etc/installer/icons.tar" ]; then
	echo
else
	sudo megadl https://mega.nz/#!xTZ20LBI!gcryLaBETgEr4XaWhke520Aq478i1c-KzyCF0GiduCk
	echo
fi	
sudo mv -v icons.tar /usr/share/icons/icons.tar
echo
cd /usr/share/icons/
sudo tar -xvf icons.tar
echo
sudo rm -v icons.tar
echo
cd /etc/installer/
if [ -e "/etc/installer/ne-logo.png" ]; then
	echo
else
	sudo megadl https://mega.nz/#!AGZz2DQQ!DgeCYFU0yzOJvM0WACb9gb9m7kAAI7RrfoZ7rE0JS5M
	echo
fi	
sudo cp -v ne-logo.png /usr/share/icons/ne-logo.png
echo
sudo mv -v ne-logo.png /usr/share/pixmaps/ne-logo.png
echo
if [ -e "/etc/installer/libwhiskermenu.so" ]; then
	echo
else
	sudo megadl https://mega.nz/#!pGYUFZhS!aevDkydagf-OmDSykFXBtIJWeGTGuO6_3fkDmtkXLzU
	echo
fi
sudo mv -v /usr/lib/i386-linux-gnu/xfce4/panel/plugins/libwhiskermenu.so /usr/lib/i386-linux-gnu/xfce4/panel/plugins/libwhiskermenu.so.bkp
echo
sudo mv -v libwhiskermenu.so /usr/lib/i386-linux-gnu/xfce4/panel/plugins/libwhiskermenu.so
echo
echo -n "5 " && sleep 1 && echo -n "4 " && sleep 1 && echo -n "3 " && sleep 1 && echo -n "2 " && sleep 1 && echo -n "1 " && sleep 1 && echo "0"
echo
echo "Tecle ENTER para continuar."
read enter

# Instala todos os programas ou aplicativo para escolher quais programas

echo
echo "# Instalação de programas #"
echo
cd /etc/installer/
if [ -e "/etc/installer/ppa.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!tDo1FA6a!BRSPd-r0gN66KLMIITVpK9GhLANtUZjO0VHQZaWpw6g
	echo
fi
sudo chmod -v +x /etc/installer/ppa.sh
echo
if [ -e "/etc/installer/install.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!9KA0BR6K!26UOCVKLFZGMKdRujw8TnvXmmCj-zmwEdPSErYc3er0
	echo
fi
sudo chmod -v +x /etc/installer/install.sh
echo
if [ -e "/etc/installer/dpkg.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!dC5GyDZT!L830uiZ_HpzcuAoE9UAvJzTN9T57_rC1lQM2-RItL8Y
	echo
fi
sudo chmod -v +x /etc/installer/dpkg.sh
echo
if [ -e "/etc/installer/download.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!9b5CWbyb!2PEvC936Ct4adzHvwXePYBnv5wbrVfO1KGVJfIln_NI
	echo
fi
sudo chmod -v +x /etc/installer/download.sh
echo
if [ -e "/etc/installer/wine.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!xWQDHSba!9XQ8-2u5Un1WjIK3Xxg93F66e8wR3TNFqlNAGezetTs
	echo
fi
sudo chmod -v +x /etc/installer/wine.sh
echo
echo "Tecle ENTER para continuar."
read enter
sudo ./download.sh
echo
echo "Tecle ENTER para continuar."
read enter
sudo ./ppa.sh
echo
echo "Tecle ENTER para continuar."
read enter
sudo apt-get update
echo
echo "Tecle ENTER para continuar."
read enter
sudo ./install.sh
echo
echo "Tecle ENTER para continuar."
read enter
sudo ./dpkg.sh
echo
echo "Tecle ENTER para continuar."
read enter
echo
sudo rm -v download.sh
echo
sudo rm -v ppa.sh
echo
sudo rm -v install.sh
echo
sudo rm -v dpkg.sh
echo

# Verifica alguns arquivos e move para as pastas desejadas

cd /etc/installer/
if [ -e "/etc/installer/Getting-Started-Guide-Scratch2.pdf" ]; then
	if [ -d "/opt/Scratch 2/exemplos/" ]; then
		echo
	else
		sudo mkdir -v /opt/Scratch\ 2/exemplos/
		echo
	fi
	sudo mv -v /etc/installer/Getting-Started-Guide-Scratch2.pdf /opt/Scratch\ 2/exemplos/Getting-Started-Guide-Scratch2.pdf
	echo
fi
if [ -e "/etc/installer/Scratch2Cards.pdf" ]; then
	if [ -d "/opt/Scratch 2/exemplos/" ]; then
		echo
	else
		sudo mkdir -v /opt/Scratch\ 2/exemplos/
		echo
	fi
	sudo mv -v /etc/installer/Scratch2Cards.pdf /opt/Scratch\ 2/exemplos/Scratch2Cards.pdf
	echo
fi
if [ -e "/etc/installer/Scratch2StarterProjects.tar" ]; then
	if [ -d "/opt/Scratch 2/exemplos/" ]; then
		echo
	else
		sudo mkdir -v /opt/Scratch\ 2/exemplos/
		echo
	fi
	sudo mv -v /etc/installer/Scratch2StarterProjects.tar /opt/Scratch\ 2/exemplos/Scratch2StarterProjects.tar
	echo
	cd /opt/Scratch\ 2/exemplos/
	sudo tar -xvf Scratch2StarterProjects.tar
	echo
	sudo rm -v /opt/Scratch\ 2/exemplos/Scratch2StarterProjects.tar
	echo
	cd /etc/installer
fi
if [ -e "/etc/installer/edu.media.mit.scratch2editor.desktop" ]; then
	if [ -d "/opt/Scratch 2/share/META-INF/AIR/" ]; then
		echo
	else
		sudo mkdir -v /opt/Scratch\ 2/share/META-INF/AIR/
		echo
	fi
	sudo mv -v /etc/installer/edu.media.mit.scratch2editor.desktop /opt/Scratch\ 2/share/META-INF/AIR/
	echo
fi
if [ -d "/opt/PhET/" ]; then
	cd /opt/PhET/
	sudo chown -v $USER PhET\ Simulations.desktop
	echo
	sudo chmod -v +w PhET\ Simulations.desktop
	echo
	echo "Categories=Education" >> PhET\ Simulations.desktop
	echo
	sudo chmod -v -w PhET\ Simulations.desktop
	echo
	sudo chown -v root PhET\ Simulations.desktop
	echo
	sudo cp -v /opt/PhET/PhET\ Simulations.desktop /usr/share/applications/PhET\ Simulations.desktop
	echo
	cd /etc/installer/
fi
if [ -d "/home/"$USER"/.local/share/applications/" ]; then
	echo
else
	mkdir -v /home/"$USER"/.local/share/applications/
	echo
fi
if [ -e "/etc/installer/applications.tar" ]; then
	sudo mv -v /etc/installer/applications.tar /home/"$USER"/.local/share/applications/applications.tar
	echo
	cd /home/"$USER"/.local/share/applications/ 
	echo
	sudo tar -xvf applications.tar
	echo
	sudo rm -v applications.tar
	echo
	cd /etc/installer/
	echo
	sudo chown -v -R "$USER":"$USER" /home/"$USER"/.local/share/applications/
	echo
fi

echo "parada de verificação"
read enter

if [ -d "/usr/local/Physion/" ]; then
	if [ -e "/home/"$USER"/Área de Trabalho/Physion-desktop.desktop" ]; then
		sudo rm -v /home/"$USER"/Área\ de\ Trabalho/Physion-desktop.desktop
		echo
	fi
	if [ -e "/etc/installer/Run.sh" ]; then
		echo
	else
		sudo megadl https://mega.nz/#!wLxDUTrZ!NiW6fEaARF-w-FoOX9n2dqgJdjUgH3qqNuKZrtcM1Tc
		echo
	fi
	sudo mv -v /etc/installer/Run.sh /usr/local/Physion/
	echo
fi
if [ -d "/usr/share/muan/" ]; then
	sudo rm -v /home/"$USER"/Área\ de\ Trabalho/muan.desktop
	echo
fi
if [ -e "/etc/installer/klettresrc" ]; then
	if [ -d "/home/"$USER"/.kde/" ]; then
		echo
		if [ -d "/home/"$USER"/.kde/share/" ]; then
			echo
			if [ -d "/home/"$USER"/.kde/share/config/" ]; then
				echo
			else
				mkdir -v /home/"$USER"/.kde/share/config/
				echo
			fi
		else
			mkdir -v /home/"$USER"/.kde/share/
			echo
			mkdir -v /home/"$USER"/.kde/share/config/
			echo
		fi
	else
		mkdir -v /home/"$USER"/.kde/
		echo
		mkdir -v /home/"$USER"/.kde/share/
		echo
		mkdir -v /home/"$USER"/.kde/share/config/
		echo
	fi
	sudo mv -v /etc/installer/klettresrc /home/"$USER"/.kde/share/config/klettresrc
	echo
	sudo chown -v -R "$USER":"$USER" /home/"$USER"/.kde/share/config/klettresrc
	echo
fi
if [ -e "/etc/installer/audacity.cfg" ]; then
	if [ -d "/home/"$USER"/.audacity-data/" ]; then
		echo
	else
		mkdir -v /home/"$USER"/.audacity-data/
		echo
	fi
	sudo mv -v /etc/installer/audacity.cfg /home/"$USER"/.audacity-data/audacity.cfg
	echo
	sudo chown -v "$USER":"$USER" /home/"$USER"/.audacity-data/audacity.cfg
	echo
fi
if [ -e "/etc/installer/klettres-pt_BR.tar" ]; then
	if [ -d "/home/"$USER"/.local/" ]; then
		echo
		if [ -d "/home/"$USER"/.local/share/" ]; then
			echo
			if [ -d "/home/"$USER"/.local/share/klettres/" ]; then
				echo
			else
				mkdir -v /home/"$USER"/.local/share/klettres/
				echo
			fi
		else
			mkdir -v /home/"$USER"/.local/share/
			echo
			mkdir -v /home/"$USER"/.local/share/klettres/
			echo
		fi
	else
		mkdir -v /home/"$USER"/.local/
		echo
		mkdir -v /home/"$USER"/.local/share/
		echo
		mkdir -v /home/"$USER"/.local/share/klettres/
		echo
	fi
	sudo mv -v /etc/installer/klettres-pt_BR.tar /home/"$USER"/.local/share/klettres/
	echo
	sudo chown -v "$USER":"$USER" /home/"$USER"/.local/share/klettres/klettres-pt_BR.tar
	echo
	cd /home/"$USER"/.local/share/klettres/
	echo
	tar -xvf klettres-pt_BR.tar
	echo
	cd /etc/installer/
	echo
	sudo rm -v /home/"$USER"/.local/share/klettres/klettres-pt_BR.tar
	echo
	sudo chown -vR "$USER":"$USER" /home/"$USER"/.local/share/klettres/
	echo
fi
if [ -d "/opt/luzdosaber_infantil" ]; then
	sudo rm -v /home/"$USER"/Área\ de\ Trabalho/luzdosaber_infantil_ubuntu.desktop
	echo
fi
if [ -d "/opt/PdV1/" ]; then
	sudo mv -v /etc/installer/PdV1.desktop /usr/share/applications/PdV1.desktop
	echo
fi
if [ -d "/opt/PdV2.B1/" ]; then
	sudo mv -v /etc/installer/PdV2.B1.desktop /usr/share/applications/PdV2.B1.desktop 
	echo
fi
if [ -d "/opt/PdV2.B2/" ]; then
	sudo mv -v /etc/installer/PdV2.B2.desktop /usr/share/applications/PdV2.B2.desktop 
	echo
fi
if [ -d "/opt/PdV2.B3/" ]; then
	sudo mv -v /etc/installer/PdV2.B3.desktop /usr/share/applications/PdV2.B3.desktop 
	echo
fi
if [ -d "/home/"$USER"/.config/menus" ]; then
	cp -v /etc/installer/xfce-applications.menu /home/"$USER"/.config/menus/
	echo
	sudo rm -v /etc/installer/xfce-applications.menu
	echo
else
	mkdir /home/"$USER"/.config/menus
	echo
	cp -v /etc/installer/xfce-applications.menu /home/"$USER"/.config/menus/
	echo
	sudo rm -v /etc/installer/xfce-applications.menu
	echo
fi
cd /etc/installer/
if [ -e "/etc/installer/tux_std.png" ]; then
	sudo mv -v /etc/installer/tux_std.png /home/"$USER"/.face
	echo
	sudo chown -v "$USER":"$USER" /home/"$USER"/.face
	echo
else
	sudo megadl https://mega.nz/#!9eJEQDbC!DgeCYFU0yzOJvM0WACb9gb9m7kAAI7RrfoZ7rE0JS5M
	echo
	sudo mv -v /etc/installer/tux_std.png /home/"$USER"/.face
	echo
	sudo chown -v "$USER":"$USER" /home/"$USER"/.face
	echo
fi
if [ -e "/etc/installer/tux_teacher.png" ]; then
	echo
else
	sudo megadl https://mega.nz/#!FOhlmQhR!YWlifuhNwB93rfcqaPmoIIj_4GQIBd1qsXDDLtxHjTY
	echo
fi
if [ -e "/etc/installer/tux_tech.png" ]; then
	echo
else
	sudo megadl https://mega.nz/#!NKZzSDhC!_etku0lhXh-1jgXiAGvOL4ADpKGPkhHe5fyLBLoMcV0
	echo
fi
if [ -e "/etc/installer/directory.tar" ]; then
	echo
else
	megadl https://mega.nz/#!BGxxRbTC!srSXolu00WF9vGzHdVIi8rI0xWIqRRDgxXJSe0yNW4Y
	echo
fi
if [ -d "/home/"$USER"/.local/share/desktop-directories/" ]; then
	echo
else
	mkdir -v /home/"$USER"/.local/share/desktop-directories/
	echo
fi
cp -v /etc/installer/directory.tar /home/"$USER"/.local/share/desktop-directories/directory.tar
echo
cd /home/"$USER"/.local/share/desktop-directories/
tar -xvf directory.tar
echo
rm directory.tar
echo
sudo rm -v /etc/installer/directory.tar
echo
echo -n "5 " && sleep 1 && echo -n "4 " && sleep 1 && echo -n "3 " && sleep 1 && echo -n "2 " && sleep 1 && echo -n "1 " && sleep 1 && echo "0"
echo
echo "Tecle ENTER para continuar."
read enter
cd /etc/installer

#if [ -e "/etc/installer/xfce4-panel.xml" ]; then
#	echo
#else
#	sudo megadl https://my.syncplicity.com/share/hy0cizeb0dqvznj/xfce4-panel.xml
#	echo
#fi	
#cp -v xfce4-panel.xml /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
#echo


# Copia o conteudo da home para o skeleton

sudo rsync -av /home/"$USER"/ /etc/skel/
echo
sudo rm -v /etc/skel/Desktop
echo
echo -n "5 " && sleep 1 && echo -n "4 " && sleep 1 && echo -n "3 " && sleep 1 && echo -n "2 " && sleep 1 && echo -n "1 " && sleep 1 && echo "0"
echo
echo "Tecle ENTER para continuar."
read enter

# Instala programas do Wine, se foram selecionados no instalador
# Isso foi necessário pois só é possivel instalar aplicativos do wine com usuario atual (sem sudo ou su)

if [ -e "/etc/installer/wine.sh" ]; then
	cd /etc/installer
	echo
	./wine.sh
	echo
	if [ -e "/etc/installer/hq_banco_de_imagens.tar" ]; then
		cp -v /etc/installer/hq_banco_de_imagens.tar /home/"$USER"/.wine/drive_c/Program\ Files/HagaQue/hq_banco_de_imagens.tar
		echo
		cd /home/"$USER"/.wine/drive_c/Program\ Files/HagaQue/
		tar -xvf hq_banco_de_imagens.tar
		echo
		sudo rm -v /home/"$USER"/.wine/drive_c/Program\ Files/HagaQue/hq_banco_de_imagens.tar
		echo
		cd /etc/installer/
	fi
	if [ -e "/etc/installer/hq1.05_install.exe" ]; then
		rm -v /home/"$USER"/Área\ de\ Trabalho/HagáQuê.desktop
		echo
		rm -v /home/"$USER"/Área\ de\ Trabalho/HagáQuê.lnk
		echo
	fi
	if [ -e "/etc/installer/Pivot_3.1_portugues.exe" ]; then
		if [ -e "/home/"$USER"/Área de Trabalho/Pivot Brasil.lnk" ]; then
			rm -v /home/"$USER"/Área\ de\ Trabalho/Pivot\ Brasil.lnk
			echo
		fi
		if [ -e "/home/"$USER"/Área de Trabalho/Pivot Brasil.desktop" ]; then
			rm -v /home/"$USER"/Área\ de\ Trabalho/Pivot\ Brasil.desktop
			echo
		fi
	fi
fi
echo
echo -n "5 " && sleep 1 && echo -n "4 " && sleep 1 && echo -n "3 " && sleep 1 && echo -n "2 " && sleep 1 && echo -n "1 " && sleep 1 && echo "0"
echo
echo "Tecle ENTER para continuar."
read enter

# Pergunta qual o modelo de PC está sendo instalado (Terminal simples ou multiterminal)

echo
echo "#############################################"
echo "##                                         ##"
echo "##     Configurando tipo de instalação     ##"
echo "##                                         ##"
echo "#############################################"
echo
count=0
cd /etc/installer/
while [ $count = 0 ]; do
	echo
	echo "Qual tipo de terminal?"
	echo
	echo "1 - Terminal simples"
	echo "2 - Multiterminal"
	echo
	read multi
	case $multi in
		1)
			# Configura o terminal simples, adicionando usuário aluno1 e professor e respectivas senhas
			echo
			echo "#####################################"
			echo "##                                 ##"
			echo "##     Configurando o terminal     ##"
			echo "##      Adicionando usuários       ##"
			echo "##                                 ##"
			echo "#####################################"
			echo
			sudo addgroup aluno
			echo
			sudo addgroup professor
			echo
			sudo useradd -g aluno -m -s /bin/bash aluno1
			echo
			sudo useradd -g professor -m -s /bin/bash professor
			echo
			sudo usermod -a -G tty aluno1
			echo
			sudo usermod -a -G dialout aluno1
			echo
			sudo usermod -a -G tty professor
			echo
			sudo usermod -a -G dialout professor
			echo
			if [ -e "/etc/installer/password.sh" ]; then
				echo
			else
				sudo megadl https://mega.nz/#!FK4CTCKK!txxu1l_kbsDWh47Zb9Qy4YsWVMqyv1o6M0wmSyHShvk
				echo
			fi	
			echo
			sudo chmod -v +x password.sh
			echo 
			sudo ./password.sh
			echo 
			sudo rm -v /etc/installer/password.sh
			echo
			if [ -e "/etc/installer/password_3.sh" ]; then
				sudo rm -v /etc/installer/password_3.sh
				echo
			fi
			if [ -e "/etc/installer/password_5.sh" ]; then
				sudo rm -v /etc/installer/password_5.sh
				echo
			fi

			# Configura a inicialização automática do sistema para logar automaticamente no usuário aluno1

			echo
			echo "########################################"
			echo "##                                    ##"
			echo "##     Configurando inicialização     ##"
			echo "##                                    ##"
			echo "########################################"
			echo
			if [ -e "/etc/installer/lightdm.conf.1term" ]; then
				echo
			else
				sudo megadl https://mega.nz/#!IaBDFTSY!zqnp0WRRB1B1stl1oT_BENFcUEEygrFON10Qw9eUlnk
				echo
			fi	
			sudo cp -v lightdm.conf.1term /etc/lightdm/lightdm.conf	
			echo
			if [ -e "/etc/installer/lightdm.conf.3term" ]; then
				sudo rm -v /etc/installer/lightdm.conf.3term
				echo
			fi
			if [ -e "/etc/installer/lightdm.conf.5term" ]; then
				sudo rm -v /etc/installer/lightdm.conf.5term
				echo
			fi
			count=1
		;;
		2)
			echo
			echo "##########################################"
			echo "##                                      ##"
			echo "##     Configurando o multiterminal     ##"
			echo "##        Adicionando repositório       ##"
			echo "##             Atualizando              ##"
			echo "##              Instalando              ##"
			echo "##                                      ##"
			echo "##########################################"
			echo
			sudo apt-add-repository -y ppa:oiteam/oi-lab
			sudo apt-get update
			sleep 3
			sudo apt-get install -y oi-lab-proinfo-multi-seat-utils oi-lab-userful-rescue
			echo
			cd /etc/installer/
			echo 
			echo " Quantos terminais serão usados (3 ou 5)?"
			count1=0
			while [ $count1 = 0 ]; do
				read opmult
				echo
			
			# Configura o multiterminal, adicionando usuários: aluno1, aluno2, aluno3, aluno4, aluno5, professor e respectivas senhas
			
				echo "# Adicionando usuários #"
				echo 
				sudo addgroup aluno
				echo 
				sudo addgroup professor
				echo 
				case $opmult in
					3)
						sudo useradd -g aluno -m -s /bin/bash aluno1
						echo 
						sudo useradd -g aluno -m -s /bin/bash aluno2
						echo 
						sudo useradd -g aluno -m -s /bin/bash aluno3
						echo 
						sudo useradd -g professor -m -s /bin/bash professor
						echo 
						sudo usermod -a -G tty aluno1
						echo
						sudo usermod -a -G dialout aluno1
						echo
						sudo usermod -a -G tty aluno2
						echo
						sudo usermod -a -G dialout aluno2
						echo
						sudo usermod -a -G tty aluno3
						echo
						sudo usermod -a -G dialout aluno3
						echo
						sudo usermod -a -G tty professor
						echo
						sudo usermod -a -G dialout professor
						echo
						if [ -e "/etc/installer/password_3.sh" ]; then
							echo
						else
							sudo megadl https://mega.nz/#!xfATBCJJ!ptWeXSNz8kq5n1yPhaxyeSrDNpLG2k7b4-33TgHYk8o
							echo
						fi	
						sudo chmod -v +x password_3.sh
						echo 
						sudo ./password_3.sh
						echo 
						sudo rm -v password_3.sh
						echo 
						if [ -e "/etc/installer/password.sh" ]; then
							sudo rm -v password.sh
							echo 
						fi
						if [ -e "/etc/installer/password_3.sh" ]; then
							sudo rm -v password_5.sh
							echo 
						fi
						echo "# Configurando inicialização #"
						echo 
						if [ -e "/etc/installer/lightdm.conf.3term" ]; then
							echo
						else
							sudo megadl https://mega.nz/#!RKBEHaRS!oiCDfGz64rrLXZ_N814zEoASY4g4pX6wnKY96zYRI-8
							echo
						fi	
						sudo cp -v lightdm.conf.3term /etc/lightdm/lightdm.conf
						echo 
						if [ -e "/etc/installer/lightdm.conf.1term" ]; then
							sudo rm -v lightdm.conf.1term
							echo 
						fi
						if [ -e "/etc/installer/lightdm.conf.5term" ]; then
							sudo rm -v lightdm.conf.5term
							echo			
						fi
						count1=1
					;;
					5)
						sudo useradd -g aluno -m -s /bin/bash aluno1
						echo 
						sudo useradd -g aluno -m -s /bin/bash aluno2
						echo 
						sudo useradd -g aluno -m -s /bin/bash aluno3
						echo 
						sudo useradd -g aluno -m -s /bin/bash aluno4
						echo 
						sudo useradd -g aluno -m -s /bin/bash aluno5
						echo 
						sudo useradd -g professor -m -s /bin/bash professor
						echo 
						sudo usermod -a -G tty aluno1
						echo
						sudo usermod -a -G dialout aluno1
						echo
						sudo usermod -a -G tty aluno2
						echo
						sudo usermod -a -G dialout aluno2
						echo
						sudo usermod -a -G tty aluno3
						echo
						sudo usermod -a -G dialout aluno3
						echo
						sudo usermod -a -G tty aluno4
						echo
						sudo usermod -a -G dialout aluno4
						echo
						sudo usermod -a -G tty aluno5
						echo
						sudo usermod -a -G dialout aluno5
						echo
						sudo usermod -a -G tty professor
						echo
						sudo usermod -a -G dialout professor
						echo
						if [ -e "/etc/installer/password_5.sh" ]; then
							echo
						else
							sudo megadl https://mega.nz/#!MOBgAZLR!0u9Yul_ev7TjXs0onrDdTlAJnzENWWczVuyUA5lIdmY
							echo
						fi	
						sudo chmod -v +x password_5.sh
						echo 
						sudo ./password_5.sh
						echo 
						sudo rm -v password_5.sh
						echo 
						if [ -e "/etc/installer/password.sh" ]; then
							sudo rm -v password.sh
							echo 
						fi
						if [ -e "/etc/installer/password_3.sh" ]; then
							sudo rm -v password_3.sh
							echo 
						fi
						echo "# Configurando inicialização #"
						echo 
						if [ -e "/etc/installer/lightdm.conf.5term" ]; then
							echo
						else
							sudo megadl https://mega.nz/#!MOBgAZLR!0u9Yul_ev7TjXs0onrDdTlAJnzENWWczVuyUA5lIdmY
							echo
						fi	
						sudo cp -v lightdm.conf.5term /etc/lightdm/lightdm.conf
						echo
						if [ -e "/etc/installer/lightdm.conf.1term" ]; then
							sudo rm -v lightdm.conf.1term
							echo 
						fi
						if [ -e "/etc/installer/lightdm.conf.3term" ]; then
							sudo rm -v lightdm.conf.3term
							echo			
						fi
						count1=1
					;;
				esac
			done
			count=1
		;;
		*)
			echo "Desculpe, o número escolhido é inválido. Por favor, tente novamente..."
			echo
			count=0
		;;
	esac
done

# Adicionando instalador de programas e programa para travar/destravar usuarios, na área de trabalho do usuario tecnico

cd /etc/installer/
if [ -e "/etc/installer/freeze_NE.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!oG4khIpY!nHBMNXNLNNIL-Hf6zFSIUVn7EqHsAn2U2LGA8qkKTC4
	echo
fi	
sudo chmod -v +x freeze_NE.sh
echo
if [ -e "/etc/installer/freeze.desktop" ]; then
	echo
else
	sudo megadl https://mega.nz/#!QTAjmC5R!uB_Rss1B5ec-8ns2h-Em3lTdy8YyLKVj6aSdHJxtX3E
	echo
fi	
sudo mv -v freeze.desktop /home/"$USER"/Área\ de\ Trabalho/freeze.desktop
echo
sudo chmod -v +x /home/"$USER"/Área\ de\ Trabalho/freeze.desktop
echo
sudo chown -v "$USER":"$USER" /home/"$USER"/Área\ de\ Trabalho/freeze.desktop
echo
	
# Configurando painel e menu para usuario tecnico (com mais opções)

echo "# Configurando painel e menu para usuário técnico #"
echo
cd /etc/installer
if [ -e "/etc/installer/whiskermenu-1.rc" ]; then
	echo
else
	sudo megadl https://mega.nz/#!1TQ3xSAD!oXNobQwTBXeCTPIiFw0iJQZitiiBG8i-o34Cq6iNxmE
	echo
fi	
sudo rm -v /home/"$USER"/.config/xfce4/panel/whiskermenu-1.rc
echo
sudo mv -v whiskermenu-1.rc /home/"$USER"/.config/xfce4/panel/whiskermenu-1.rc
echo
if [ -e "/etc/installer/xfce4-panel.xml.tec" ]; then
	echo
else
	sudo megadl https://mega.nz/#!AO4QAJqS!hnLPlfDIwmEn5cdlB7f3AlbYGh3RjegCR9TUkIFmEds
	echo
fi	
sudo mv -v xfce4-panel.xml.tec /home/"$USER"/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
echo
if [ -e "/etc/installer/xfce-applications.menu.tec" ]; then
	echo
else
	sudo megadl 
	echo
fi
rm -v /home/"$USER"/.config/menus/xfce-applications.menu
echo
cp -v /etc/installer/xfce-applications.menu.tec /home/"$USER"/.config/menus/xfce-applications.menu
echo
sudo rm -v /etc/installer/xfce-applications.menu.tec
echo

# Configurando programas instalados

if [ -d "/opt/Scratch\ 2/" ]; then
	sudo chown -v -R professor:aluno /opt/Scratch\ 2/
	echo
	sudo chmod -v -R g-w,o-w /opt/Scratch\ 2/
	echo
fi
if [ -d "/opt/childsplay/" ]; then
	sudo chown -v -R professor:aluno /opt/childsplay/
	echo
	sudo chmod -v -R g-w,o-w /opt/childsplay/
	echo
fi
if [ -d "/opt/PdV1/" ]; then
	#sudo mv -v /etc/installer/PdV1.desktop /home/"$USER"/Área\ de\ Trabalho/PdV1.desktop
	echo
	sudo chown -v -R professor:aluno /opt/PdV1/
	echo
	sudo chmod -v -R g-w,o-w /opt/PdV1/
	echo
fi
if [ -d "/opt/PdV2.B1/" ]; then
	#sudo mv -v /etc/installer/PdV2.B1.desktop /home/"$USER"/Área\ de\ Trabalho/PdV2.B1.desktop 
	echo
	sudo chown -v -R professor:aluno /opt/PdV2.B1/
	echo
	sudo chmod -v -R g-w,o-w /opt/PdV2.B1/
	echo
fi
if [ -d "/opt/PdV2.B2/" ]; then
	#sudo mv -v /etc/installer/PdV2.B2.desktop /home/"$USER"/Área\ de\ Trabalho/PdV2.B2.desktop 
	echo
	sudo chown -v -R professor:aluno /opt/PdV2.B2/
	echo
	sudo chmod -v -R g-w,o-w /opt/PdV2.B2/
	echo
fi
if [ -d "/opt/PdV2.B3/" ]; then
	#sudo mv -v /etc/installer/PdV2.B3.desktop /home/"$USER"/Área\ de\ Trabalho/PdV2.B3.desktop 
	echo
	sudo chown -v -R professor:aluno /opt/PdV2.B3/
	echo
	sudo chmod -v -R g-w,o-w /opt/PdV2.B3/
	echo
fi
echo
echo "########################################"
echo "##                                    ##"
echo "##     Finalizando a Configuração     ##"
echo "##                                    ##"
echo "########################################"
echo
cd /etc/installer/
sudo rm -v /etc/xdg/autostart/config.desktop
echo 
if [ -e "/etc/installer/config2.desktop" ]; then
	echo
else
	sudo megadl https://mega.nz/#!EfAyDYQJ!PfEN2wJFhnN0kCnuoEC21gP3QSvmIBpi9aH5C6zrKCw
	echo
fi	
if [ -e "/etc/installer/config3.desktop" ]; then
	echo
else
	sudo megadl https://mega.nz/#!BSpklIoT!XDnDr6d8isJOKgWQx1bvhopVCLnOfG9RYF7NwySRMz4
	echo
fi
if [ -e "/etc/installer/rebootaluno.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!4HJAALDD!P_A2uLkXyrvZTJd6_kGODdRrvL5fmYUTIYfnaGg7mB0
	echo
fi
if [ -e "/etc/installer/lightdm.conf.prof" ]; then
	echo
else
	sudo megadl https://mega.nz/#!AP42hLaR!n192pBhwptHOt5AYZ74kawvJ-3ObCtYQ5STS99bc3Lo
	echo
fi
if [ -e "/etc/installer/config4.desktop" ]; then
	echo
else
	sudo megadl https://mega.nz/#!0ORUmCzA!yPilM87RMZi_8PHho595f2NuicjQ-ZXZ6l-J7bcqAt0
	echo
fi
if [ -e "/etc/installer/travar2.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!8aZCBYSR!EVYQgUqXY33Jo7PfqJbaYQc8Z4KFg0e55nOj6yhBG1s
	echo
fi
if [ -e "/etc/installer/rebootprof.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!IbZVWQJD!qjaQmjAhGgoDvmWgp-A3KkG7X35GGCh_aVo-en5pvlI
	echo
fi
if [ -e "/etc/installer/config5.desktop" ]; then
	echo
else
	sudo megadl https://mega.nz/#!1bgzWQ5R!_O5pf0zToeL6H-FuDx4a2fqnT8BX3OvCSHiJHra0rAY
	echo
fi
if [ -e "/etc/installer/rede_pos_clone.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!BXhADa6b!ZKbRooehD1zBu5xXfc3ClHD68estzx_TT5clm6k66DQ
	echo
fi
if [ -e "/etc/installer/rede.sh" ]; then
	echo
else
	sudo megadl https://mega.nz/#!IKBAjBDA!cpeYwZFRxM8CrbCpMffOippM30WDGZ9CRii1eYj2a4o
	echo
fi
if [ -e "/etc/installer/10periodic" ]; then
	echo
else
	sudo megadl https://mega.nz/#!8SQSQKrJ!dWGVagkXhyhUqSgtk6W_GpAow3V6zOyuXnndiuzJSsk
	echo
fi
if [ -e "/etc/installer/50unattended-upgrades" ]; then
	echo
else
	sudo megadl https://mega.nz/#!cLJ2TaAK!8Ft40ZWxppysEpBDXtjro2WT-SP3UbNT4G4qunW4adY
	echo
fi
if [ -e "/etc/installer/update_month" ]; then
	echo
else
	sudo megadl https://mega.nz/#!dXwDnbBS!7OQfpTru030ams18jVA4LJapakJw9Yyq5nqczHBj_Uc
	echo
fi
if [ -e "/etc/installer/update_week" ]; then
	echo
else
	sudo megadl https://mega.nz/#!caRwFQYY!dM9QaGxZq2aOf57LQUASCt8DnuJR8R0GKp5ttiZzlr0
	echo
fi
sudo mv -v /etc/installer/10periodic /etc/apt/apt.conf.d/10periodic
echo
sudo mv -v /etc/installer/50unattended-upgrades /etc/apt/apt.conf.d/50unattended-upgrades
echo
sudo chmod -v +x rede.sh
echo
sudo chmod -v +x rede_pos_clone.sh
echo 
sudo chmod -v +x rebootaluno.sh
echo 
sudo chmod -v +x config2.desktop
echo 
sudo chmod -v +x config3.desktop
echo 
sudo chmod -v +x config4.desktop
echo 
sudo chmod -v +x config5.desktop
echo 
sudo chmod -v +x travar2.sh
echo 
sudo chmod -v +x rebootprof.sh
echo 
sudo mv -v /etc/installer/config2.desktop /etc/xdg/autostart/config2.desktop
echo 

# O sistema irá reiniciar, entrar automaticamente no usuário 'aluno' e reiniciar novamente. 
# Após isso, entrará novamente no usuário técnico, congelando o sistema, reiniciando por definitivo. 

echo
echo -n "5 " && sleep 1 && echo -n "4 " && sleep 1 && echo -n "3 " && sleep 1 && echo -n "2 " && sleep 1 && echo -n "1 " && sleep 1 && echo "0"
echo
echo "Tecle ENTER para continuar."
read enter
echo "# Reiniciando o sistema #"
echo
sudo reboot
