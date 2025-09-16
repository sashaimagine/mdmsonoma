#!/bin/bash
RED='\033[0;31m'
GRN='\033[0;32m'
BLU='\033[0;34m'
NC='\033[0m'
echo ""
echo -e "Auto Tools for MacOS"
echo ""
PS3='Please enter your choice: '
options=("Bypass on Recovery" "Disable Notification (SIP)" "Disable Notification (Recovery)" "Check MDM Enrollment" "Quit")
select opt in "${options[@]}"; do
	case $opt in
	"Bypass on Recovery")
		echo -e "${GRN}Bypass on Recovery"
		if [ -d "/Volumes/OSX - Data" ]; then
   			diskutil rename "OSX - Data" "Data"
		fi
		echo -e "${GRN}Create new user"
        echo -e "${BLU}Press Enter to proceed to next step, leaving blank will automatically use default value"
  		echo -e "Enter user name (Default: MAC)"
		read realName
  		realName="${realName:=MAC}"
    	echo -e "${BLUE}Enter username ${RED}WRITE WITHOUT SPACES OR ACCENTS ${GRN} (Default: MAC)"
      	read username
		username="${username:=MAC}"
  		echo -e "${BLUE}Enter password (default: 1234)"
    	read passw
      	passw="${passw:=1234}"
		dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default' 
        echo -e "${GREEN}Creating user"
  		# Create user
    	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
      	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	 	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
		mkdir "/Volumes/Data/Users/$username"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
	    dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
	    dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username
		echo "0.0.0.0 deviceenrollment.apple.com" >>/Volumes/OSX/etc/hosts
		echo "0.0.0.0 mdmenrollment.apple.com" >>/Volumes/OSX/etc/hosts
		echo "0.0.0.0 iprofiles.apple.com" >>/Volumes/OSX/etc/hosts
        echo -e "${GREEN}Host blocking successful${NC}"
		# echo "Remove config profile"
  	touch /Volumes/Data/private/var/db/.AppleSetupDone
        rm -rf /Volumes/OSX/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	rm -rf /Volumes/OSX/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	touch /Volumes/OSX/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	touch /Volumes/OSX/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
		echo "----------------------"
		break
		;;
    "Disable Notification (SIP)")
    	echo -e "${RED}Please Insert Your Password To Proceed${NC}"
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
        sudo rm /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
        sudo touch /var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound
        break
        ;;
    "Disable Notification (Recovery)")
        rm -rf /Volumes/OSX/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
	rm -rf /Volumes/OSX/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
	touch /Volumes/OSX/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
	touch /Volumes/OSX/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

        break
        ;;
	"Check MDM Enrollment")
		echo ""
		echo -e "${GRN}Check MDM Enrollment. Error is success${NC}"
		echo ""
		echo -e "${RED}Please Insert Your Password To Proceed${NC}"
		echo ""
		sudo profiles show -type enrollment
		break
		;;
	"Quit")
		break
		;;
	*) echo "Invalid option $REPLY" ;;
	esac
done