#!/bin/sh
# ###############################################################################################
# #									      ___		#
# # SCRIPT DE GESTION DES DEPANNAGES INFORMATIQUES			     /\  \    		#
# #									     \:\  \   		#
# #									      \:\  \  		#
# #									      /::\  \  		#
# # 									     /:/\:\__\		#
# # Auteur : Tonyontheroad						    /:/  \/__/		#
# # 									   /:/  /		#
# # Contact : anthony CHEZ geimer POINT ovh				   \/__/		#
# #												#
# ###############################################################################################



# ###############################################################################################
# #												#
# #					MENU PRINCIPAL						#
# #												#
# ###############################################################################################

main_menu() {
	op_title=" -| Menu principal |- "
	menu_item=$(dialog --nocancel --ok-button "Ok" --menu "Eléments du menu :" 20 60 9 \
		"Clients" "" \
		"Matériels" "" \
		"OS" "" \
		"Logiciels" "" \
		"Interventions" "" \
		"FAQ" "" \
		"Quitter" "" 3>&1 1>&2 2>&3)

	case "$menu_item" in
		"Clients")	clients_menu;; # FAIT
		"Matériels")	materiels_menu;; # FAIT
		"OS")		OS_menu;; # FAIT
		"Logiciels")	logiciels_menu;; # FAIT
		"Interventions")	interventions_menu;; # FAIT
		"FAQ")		FAQ_menu;; # FAIT
		"Quitter")	quitter;; # FAIT
	esac
}

# ###############################################################################################
# #												#
# #				            CLIENTS						#
# #												#
# ###############################################################################################

clients_menu() {
	op_title=" -| clients |- "
	clients_item=$(dialog --nocancel --ok-button "Ok" --menu "Action sur les clients :" 20 60 9 \
		"Voir" "" \
		"Editer" "" \
		"Ajouter" "" \
		"Supprimer" "" \
		"Revenir" "" 3>&1 1>&2 2>&3)

	case "$clients_item" in
		"Voir")		voir_client;; # FAIT
		"Editer")	editer_client;; # FAIT
		"Ajouter")	ajouter_client;; # FAIT
		"Supprimer")	supprimer_client;; # FAIT
		"Revenir")	main_menu;; # FAIT
	esac
}

voir_client() {
	op_title=" -| liste clients |- "

	liste_clients=$(cat ./clients/* | grep "NOM\|ID" | tr '\n' '|' | sed -r 's/\|ID/\nID/g' | sed -r 's/\|PRENOM ://g' | sed -r 's/\|$//g')

	dialog --ok-button "Ok" --clear \
		--msgbox "$liste_clients" 30 90

	clients_menu
}

editer_client() {
	op_title=" -| édition client |- "

	num_client=$(dialog --cancel-button "Annuler" --ok-button "Ok" --inputbox "Numéro ID du client :" 20 60 000 3>&1 1>&2 2>&3)
	fichier_client="./clients/cl$num_client"
	if ! [ -f $fichier_client ]; then
		dialog --nocancel --ok-button "Ok" --msgbox "Le client numéro $num_client n'existe pas !" 20 60
		clients_menu
	elif [ -f $fichier_client ]; then
		old_nom_cl=$(cat $fichier_client | egrep '^NOM :' | sed -r 's/^NOM : //g')
		nom_cl=$(dialog --ok-button "Ok" --inputbox "Nom :" 20 60 $old_nom_cl 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			clients_menu
		fi

		old_prenom_cl=$(cat $fichier_client | egrep '^PRENOM :' | sed -r 's/^PRENOM : //g')
		prenom_cl=$(dialog --ok-button "Ok" --inputbox "Prénom :" 20 60 $old_prenom_cl 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			clients_menu
		fi

		old_adresse_cl=$(cat $fichier_client | egrep '^ADRESSE :' | sed -r 's/^ADRESSE : //g')
		adresse_cl=$(dialog --ok-button "Ok" --inputbox "Adresse :" 20 60 $old_adresse_cl 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			clients_menu
		fi

		old_CP_cl=$(cat $fichier_client | egrep '^CP :' | sed -r 's/^CP : //g')
		CP_cl=$(dialog --ok-button "Ok" --inputbox "Code postal :" 20 60 $old_CP_cl 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			clients_menu
		fi

		old_ville_cl=$(cat $fichier_client | egrep '^VILLE :' | sed -r 's/^VILLE : //g')
		ville_cl=$(dialog --ok-button "Ok" --inputbox "Ville :" 20 60 $old_ville_cl 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			clients_menu
		fi

		old_tel_cl=$(cat $fichier_client | egrep '^TELEPHONE :' | sed -r 's/^TELEPHONE : //g')	
		tel_cl=$(dialog --ok-button "Ok" --inputbox "Téléphone :" 20 60 $old_tel_cl 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			clients_menu
		fi

		old_mail_cl=$(cat $fichier_client | egrep '^MAIL :' | sed -r 's/^MAIL : //g')
		mail_cl=$(dialog --ok-button "Ok" --inputbox "Mail :" 20 60 $old_mail_cl 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			clients_menu
		fi

		if (dialog --no-button "NON" --yes-button "Enregistrer" --yesno "Les informations ci-dessous sont extactes ?\n\n \
			ID : $num_client \n \
			NOM : $nom_cl \n \
			PRENOM : $prenom_cl \n \
			ADRESSE : $adresse_cl \n \
			CP : $CP_cl \n \
			VILLE : $ville_cl \n \
			TELEPHONE : $tel_cl \n \
			MAIL : $mail_cl" 30 60); then
			echo "ID : $num_client" > "$fichier_client"
			echo "NOM : $nom_cl" >> "$fichier_client"
			echo "PRENOM : $prenom_cl" >> "$fichier_client"
			echo "ADRESSE : $adresse_cl" >> "$fichier_client"
			echo "CP : $CP_cl" >> "$fichier_client"
			echo "VILLE : $ville_cl" >> "$fichier_client"
			echo "TELEPHONE : $tel_cl" >> "$fichier_client"
			echo "MAIL : $mail_cl" >> "$fichier_client"

			clients_menu
		else
			clients_menu
		fi
	fi
}

ajouter_client() {
	op_title=" -| ajouter client |- "

	nom_cl=$(dialog --ok-button "Ok" --inputbox "Nom :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		clients_menu
	fi
	prenom_cl=$(dialog --ok-button "Ok" --inputbox "Prénom :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		clients_menu
	fi
	adresse_cl=$(dialog --ok-button "Ok" --inputbox "Adresse :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		clients_menu
	fi
	CP_cl=$(dialog --ok-button "Ok" --inputbox "Code postal :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		clients_menu
	fi
	ville_cl=$(dialog --ok-button "Ok" --inputbox "Ville :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		clients_menu
	fi
	tel_cl=$(dialog --ok-button "Ok" --inputbox "Téléphone :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		clients_menu
	fi
	mail_cl=$(dialog --ok-button "Ok" --inputbox "Mail :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		clients_menu
	fi
	
	compt=$(ls ./clients/ | sed -nr 's/^.*cl([0-9]+)/\1/p' | awk 'max=="" || $1 > max {max=$1} END {print max}')
	if ($compt | sed -nr 's/(^0{2})/\1/p'); then
		if ($compt | egrep '9$'); then
			deux_zero=false
			un_zero=true
			zero_zero=false
		else
			deux_zero=true
			un_zero=false
			zero_zero=false
		fi
	elif ($compt | sed -nr '(^0{1})/\1/p'); then
		if ($compt | egrep '99$'); then
			un_zero=false
			deux_zero=false
			zero_zero=true
		else
			un_zero=true
			deux_zero=false
			zero_zero=false
		fi
	else
		zero_zero=true
		un_zero=false
		deux_zero=false
	fi
	
	let "compt1 = $compt + 1"
	
	if $deux_zero; then
		num_client="00$compt1"
	elif $un_zero; then
		num_client="0$compt1"
	elif $zero_zero; then
		num_client="$compt1"
	else
		echo "TROP DE CLIENTS"
	fi
	fichier_client="./clients/cl$num_client"
	dialog --nocancel --ok-button "Ok" --msgbox "Nom fichier client :\n$fichier_client" 20 60

	if (dialog --yes-button "Oui" --no-button "Non" --yesno "\nConfirmez-vous ces informations ?\n \
Nom : $nom_cl\n \
Prénom : $prenom_cl\n \
Adresse : $adresse_cl\n \
CP : $CP_cl Ville : $ville_cl \n \
Téléphone : $tel_cl\n \
Mail : $mail_cl" 20 60); then
		touch "'$fichier_client"
		echo "ID : $num_client" > "$fichier_client"
		echo "NOM : $nom_cl " >> "$fichier_client"
		echo "PRENOM : $prenom_cl" >> "$fichier_client"
		echo "ADRESSE : $adresse_cl" >> "$fichier_client"
		echo "CP : $CP_cl" >> "$fichier_client"
		echo "VILLE : $ville_cl" >> "$fichier_client"
		echo "TELEPHONE : $tel_cl" >> "$fichier_client"
		echo "MAIL : $mail_cl" >> "$fichier_client"
	else
		ajouter_client
	fi

	clients_menu
}

supprimer_client() {
	op_title=" -| SUPPRIMER CLIENT |-"

	dialog --no-button "ANNULER" --yes-button "Ok" --defaultno --yesno "ATTENTION !\nVous voulez-supprimer un client ?\n" 8 50
	if [ $? = 1 ]; then
		clients_menu
	fi

	rm_client=$(dialog --cancel-button "ANNULER" --ok-button "SUPPRIMER" --inputbox "Numéro ID du client :" 20 60 ANNULER 3>&1 1>&2 2>&3)
	if [ $? = 1 ] || [ "$rm_client" == "ANNULER" ] || [ "$rm_client" == "0" ]; then
		clients_menu
	fi

	print_client=$(cat ./clients/cl$rm_client | grep "NOM :")
	if (dialog --yes-button "SUPPRIMER" --no-button "ANNULER" --defaultno --yesno "Êtes-vous sûr de vouloir supprimer :\n$rm_client\n$print_client" 10 60); then
		fichier_client="./clients/cl$rm_client"
		rm $fichier_client
	else
		clients_menu
	fi
	
	clients_menu
}

# ###############################################################################################
# #												#
# #					MATERIELS						#
# #												#
# ###############################################################################################

materiels_menu() {
	op_title=" -| matériels |- "
	materiels_item=$(dialog --nocancel --ok-button "Ok" --menu "Action sur les matériels :" 20 60 9 \
		"Voir" "" \
		"Editer" "" \
		"Ajouter" "" \
		"Supprimer" "" \
		"Revenir" "" 3>&1 1>&2 2>&3)

	case "$materiels_item" in
		"Voir")		voir_materiel;;
		"Editer")	editer_materiel;;
		"Ajouter")	ajouter_materiel;;
		"Supprimer")	supprimer_materiel;;
		"Revenir")	main_menu;;
	esac
}

voir_materiel() {
	op_title=" -| liste materiels |- "

	liste_materiels=$(cat ./materiels/* | grep "MARQUE\|MODELE\|ID :" | tr '\n' '|' | sed -r 's/\|ID/\nID/g' | sed -r 's/\|MODELE ://g' | sed -r 's/\|$//g')

	dialog --ok-button "Ok" --clear \
		--msgbox "$liste_materiels" 30 90

	materiels_menu
}

editer_materiel() {
	op_title=" -| édition materiel |- "

	num_materiel=$(dialog --cancel-button "Annuler" --ok-button "Ok" --inputbox "Numéro ID du materiel :" 20 60 000 3>&1 1>&2 2>&3)
	fichier_materiel="./materiels/ma$num_materiel"
	if ! [ -f $fichier_materiel ]; then
		dialog --nocancel --ok-button "Ok" --msgbox "Le materiel numéro $num_materiel n'existe pas !" 20 60
		materiels_menu
	elif [ -f $fichier_materiel ]; then
		old_marque_ma=$(cat $fichier_materiel | egrep '^MARQUE :' | sed -r 's/^MARQUE : //g')
		marque_ma=$(dialog --ok-button "Ok" --inputbox "Marque :" 20 60 $old_marque_ma 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			materiels_menu
		fi

		old_modele_ma=$(cat $fichier_materiel | egrep '^MODELE :' | sed -r 's/^MODELE : //g')
		modele_ma=$(dialog --ok-button "Ok" --inputbox "Modèle :" 20 60 $old_modele_ma 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			materiels_menu
		fi

		old_serial_num_ma=$(cat $fichier_materiel | egrep '^SERIAL_NUM :' | sed -r 's/^SERIAL_NUM : //g')
		serial_num_ma=$(dialog --ok-button "Ok" --inputbox "Numéro de série :" 20 60 $old_serial_num_ma 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			materiels_menu
		fi

		old_OS_FAB_ma=$(cat $fichier_materiel | egrep '^OS_FAB :' | sed -r 's/^OS_FAB : //g')
		OS_FAB_ma=$(dialog --ok-button "Ok" --inputbox "Fabricant de l'OS :" 20 60 $old_OS_FAB_ma 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			materiels_menu
		fi

		old_OS_ver_ma=$(cat $fichier_materiel | egrep '^OS_VER :' | sed -r 's/^OS_VER : //g')
		OS_ver_ma=$(dialog --ok-button "Ok" --inputbox "Version de l'OS :" 20 60 $old_OS_ver_ma 3>&1 1>&2 2>&3)
		if [ $? = 1 ]; then
			materiels_menu
		fi

		if (dialog --no-button "NON" --yes-button "Enregistrer" --yesno "Les informations ci-dessous sont extactes ?\n\n \
			ID : $num_materiel \n \
			MARQUE : $marque_ma \n \
			MODELE : $modele_ma \n \
			SERIAL_NUM : $serial_num_ma \n \
			OS_FAB : $OS_FAB_ma \n \
			OS_VER : $OS_ver_ma" 30 60); then
			echo "ID : $num_materiel" > "$fichier_materiel"
			echo "MARQUE : $marque_ma" >> "$fichier_materiel"
			echo "MODELE : $modele_ma" >> "$fichier_materiel"
			echo "SERIAL_NUM : $serial_num_ma" >> "$fichier_materiel"
			echo "OS_FAB : $OS_FAB_ma" >> "$fichier_materiel"
			echo "OS_VER : $OS_ver_ma" >> "$fichier_materiel"
			
			materiels_menu
		else
			materiels_menu
		fi
	fi
}

ajouter_materiel() {
	op_title=" -| ajouter materiel |- "

	marque_ma=$(dialog --ok-button "Ok" --inputbox "Marque :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		materiels_menu
	fi
	modele_ma=$(dialog --ok-button "Ok" --inputbox "Modèle :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		materiels_menu
	fi
	serial_num_ma=$(dialog --ok-button "Ok" --inputbox "Numéro de série :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		materiels_menu
	fi
	OS_FAB_ma=$(dialog --ok-button "Ok" --inputbox "Frabricant de l'OS :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		materiels_menu
	fi
	OS_ver_ma=$(dialog --ok-button "Ok" --inputbox "Version de l'OS :" 20 60 3>&1 1>&2 2>&3)
	if [ $? = 1 ]; then
		materiels_menu
	fi
	
	compt=$(ls ./materiels/ | sed -nr 's/^.*ma([0-9]+)/\1/p' | awk 'max=="" || $1 > max {max=$1} END {print max}')
	if ($compt | sed -nr 's/(^0{2})/\1/p'); then
		if ($compt | egrep '9$'); then
			deux_zero=false
			un_zero=true
			zero_zero=false
		else
			deux_zero=true
			un_zero=false
			zero_zero=false
		fi
	elif ($compt | sed -nr '(^0{1})/\1/p'); then
		if ($compt | egrep '99$'); then
			un_zero=false
			deux_zero=false
			zero_zero=true
		else
			un_zero=true
			deux_zero=false
			zero_zero=false
		fi
	else
		zero_zero=true
		un_zero=false
		deux_zero=false
	fi
	
	let "compt1 = $compt + 1"
	
	if $deux_zero; then
		num_materiel="00$compt1"
	elif $un_zero; then
		num_materiel="0$compt1"
	elif $zero_zero; then
		num_materiel="$compt1"
	else
		echo "TROP DE CLIENTS"
	fi
	fichier_materiel="./materiels/ma$num_materiel"
	dialog --nocancel --ok-button "Ok" --msgbox "Nom fichier materiel :\n$fichier_materiel" 20 60

	if (dialog --yes-button "Oui" --no-button "Non" --yesno "\nConfirmez-vous ces informations ?\n \
Marque : $marque_ma\n \
Modèle : $modele_ma\n \
Numéro de série : $serial_num_ma\n \
OS_FAB : $OS_FAB_ma OS_VER : $OS_ver_ma" 20 60); then
		touch "'$fichier_materiel"
		echo "ID : $num_materiel" > "$fichier_materiel"
		echo "MARQUE : $marque_ma" >> "$fichier_materiel"
		echo "MODELE : $modele_ma" >> "$fichier_materiel"
		echo "SERIAL_NUM : $serial_num_ma" >> "$fichier_materiel"
		echo "OS_FAB : $OS_FAB_ma" >> "$fichier_materiel"
		echo "OS_VER : $OS_ver_ma" >> "$fichier_materiel"
	else
		ajouter_materiel
	fi

	materiels_menu
}

supprimer_materiel() {
	op_title=" -| SUPPRIMER MATERIEL |-"

	dialog --no-button "ANNULER" --yes-button "Ok" --defaultno --yesno "ATTENTION !\nVous voulez-supprimer un materiel ?\n" 8 50
	if [ $? = 1 ]; then
		materiels_menu
	fi

	rm_materiel=$(dialog --cancel-button "ANNULER" --ok-button "SUPPRIMER" --inputbox "Numéro ID du materiel :" 20 60 ANNULER 3>&1 1>&2 2>&3)
	if [ $? = 1 ] || [ "$rm_materiel" == "ANNULER" ] || [ "$rm_materiel" == "0" ]; then
		materiels_menu
	fi

	print_materiel=$(cat ./materiels/ma$rm_materiel | grep "MARQUE :")
	if (dialog --yes-button "SUPPRIMER" --no-button "ANNULER" --defaultno --yesno "Êtes-vous sûr de vouloir supprimer :\n$rm_materiel\n$print_materiel" 10 60); then
		fichier_materiel="./materiels/ma$rm_materiel"
		rm $fichier_materiel
	else
		materiels_menu
	fi
	
	materiels_menu
}

# ###############################################################################################
# #												#
# #					    OS							#
# #												#
# ###############################################################################################

OS_menu() {
	op_title=" -| OS |- "
	OS_item=$(dialog --nocancel --ok-button "Ok" --menu "Action sur les OS :" 20 60 9 \
		"Voir" "" \
		"Editer" "" \
		"Ajouter" "" \
		"Supprimer" "" \
		"Revenir" "" 3>&1 1>&2 2>&3)

	case "$OS_item" in
		"Voir")		voir_OS;;
		"Editer")	editer_OS;;
		"Ajouter")	ajouter_OS;;
		"Supprimer")	supprimer_OS;;
		"Revenir")	main_menu;;
	esac
}

# ###############################################################################################
# #												#
# #					LOGICIELS						#
# #												#
# ###############################################################################################

logiciels_menu() {
	op_title=" -| logiciels |- "
	logiciels_item=$(dialog --nocancel --ok-button "Ok" --menu "Action sur les logiciels :" 20 60 9 \
		"Voir" "" \
		"Editer" "" \
		"Ajouter" "" \
		"Supprimer" "" \
		"Revenir" "" 3>&1 1>&2 2>&3)

	case "$logiciels_item" in
		"Voir")		voir_logiciel;;
		"Editer")	editer_logiciel;;
		"Ajouter")	ajouter_logiciel;;
		"Supprimer")	supprimer_logiciel;;
		"Revenir")	main_menu;;
	esac
}

# ###############################################################################################
# #												#
# #					INTERVENTIONS						#
# #												#
# ###############################################################################################

interventions_menu() {
	op_title=" -| interventions |- "
	interventions_item=$(dialog --nocancel --ok-button "Ok" --menu "Action sur les interventions :" 20 60 9 \
		"Voir" "" \
		"Editer" "" \
		"Ajouter" "" \
		"Supprimer" "" \
		"Revenir" "" 3>&1 1>&2 2>&3)

	case "$interventions_item" in
		"Voir")		voir_intervention;;
		"Editer")	editer_intervention;;
		"Ajouter")	ajouter_intervention;;
		"Supprimer")	supprimer_intervention;;
		"Revenir")	main_menu;;
	esac
}

# ###############################################################################################
# #												#
# #					        FAQ						#
# #												#
# ###############################################################################################

FAQ_menu() {
	op_title=" -| FAQ |- "
	FAQ_item=$(dialog --nocancel --ok-button "Ok" --menu "Action sur les FAQ :" 20 60 9 \
		"Voir" "" \
		"Editer" "" \
		"Ajouter" "" \
		"Supprimer" "" \
		"Revenir" "" 3>&1 1>&2 2>&3)

	case "$FAQ_item" in
		"Voir")		voir_FAQ;;
		"Editer")	editer_FAQ;;
		"Ajouter")	ajouter_FAQ;;
		"Supprimer")	supprimer_FAQ;;
		"Revenir")	main_menu;;
	esac
}

# ###############################################################################################
# #												#
# #					        UTILS						#
# #												#
# ###############################################################################################

quitter() {
	if (dialog --yes-button "Oui" --no-button "Non" --yesno "Voulez-vous quitter ?" 10 50) then
		clear && exit
	else
		main_menu
	fi
}

dialog() {
	backtitle=" -| Assistance aux dépannages - Anthony |- "
	/usr/bin/dialog --colors --backtitle "$backtitle" --title "$op_title" "$@"
}

main_menu
