#!/bin/bash


USERNAME=$(whoami)
CONSENSUS=""
EXECUTION=""

#########  FUNCTIONS  #########

destroy_test(){
if [ -d ~/testnet ]
then
    cd ~/testnet/consensus-deployment-ansible/scripts/quick-run/merge-devnets
    docker-compose -f docker-compose.geth.yml down --remove-orphans 2>/dev/null
    docker-compose -f docker-compose.besu.yml down --remove-orphans 2>/dev/null
    docker-compose -f docker-compose.lighthouse.yml down --remove-orphans 2>/dev/null
    docker-compose -f docker-compose.lodestar.yml down --remove-orphans 2>/dev/null
    docker-compose -f docker-compose.nimbus.yml down --remove-orphans 2>/dev/null
    docker-compose -f docker-compose.nethermind.yml down --remove-orphans 2>/dev/null
    docker-compose -f docker-compose.teku.yml down --remove-orphans 2>/dev/null
    clear
    echo "Please provide sudo access to fully wipe the previous tests." 
    sudo rm -rf /home/$USERNAME/testnet
fi
}

repo_clone(){
mkdir -p ~/testnet && cd ~/testnet
#echo -e "Cloning the github repo locally...\n"
dialog --stdout --no-collapse --backtitle "$BACKTITLE" --title "$TITLE" --ok-label "Ok" --title "Cloning repo Locally. Please Wait " --prgbox "git clone --progress https://github.com/parithosh/consensus-deployment-ansible.git" 20 80

#Create persistent directories.
#echo -e "Creating some required directories...\r\n"
cd ~/testnet/consensus-deployment-ansible/scripts/quick-run/merge-devnets && mkdir -p execution_data beacon_data

#Setting up the public IP Address in the vars file.
ipaddr=$(curl ifconfig.me)
dialog --msgbox "You are connected to the internet using the address $ipaddr, let me put it on the vars file for You." 5 120
sed -i "s/<ENTER-IP-ADDRESS-HERE>/$ipaddr/g" ~/testnet/consensus-deployment-ansible/scripts/quick-run/merge-devnets/kintsugi.vars
}

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

test_deploy(){
cd ~/testnet/consensus-deployment-ansible/scripts/quick-run/merge-devnets

HEIGHT=20
WIDTH=80
CHOICE_HEIGHT=12
MENU="Pick your Consensus/Execution layer combo:"

OPTIONS=(1 "Lighthouse-Geth"
         2 "Lighthouse-Nethermind"
         3 "Lighthouse-Besu"
         4 "Lodestar-Geth"
         5 "Lodestar-Nethermind"
         6 "Lodestar-Besu"
         7 "Nimbus-Geth"
         8 "Nimbus-Nethermind"
         9 "Nimbus-Besu"
         10 "Teku-Geth"
         11 "Teku-Nethermind"
         12 "Teku-Besu")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            dialog --backtitle "$BACKTITLE" --title "Deploying Lighthouse-Geth, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.geth.yml up -d && docker-compose --env-file kintsugi.vars -f docker-compose.lighthouse.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="lighthouse_beacon"
            EXECUTION="geth"
            ;;
        2)
            dialog --backtitle "$BACKTITLE" --title "Deploying Lighthouse-Nethermind, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.nethermind.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.lighthouse.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="lighthouse_beacon"
            EXECUTION="nethermind"
            ;;
        3)
            dialog --backtitle "$BACKTITLE" --title "Deploying Lighthouse-Besu, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.besu.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.lighthouse.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="lighhouse_beacon"
            EXECUTION="besu"
            ;;
        4)
            dialog --backtitle "$BACKTITLE" --title "Deploying Lodestar-Geth, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.geth.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.lodestar.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="lodestar_beacon"
            EXECUTION="geth"
            ;;
        5)
            dialog --backtitle "$BACKTITLE" --title "Deploying Lodestar-Nethermind, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.nethermind.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.lodestar.yml up -d | grep -v 'orphan'" 20 89
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="lodestar_beacon"
            EXECUTION="nethermind"
            ;;
        6)
            dialog --backtitle "$BACKTITLE" --title "Deploying Lodestar-Besu, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.besu.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.lodestar.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="lodestar_beacon"
            EXECUTION="besu"
            ;;
        7)
            dialog --backtitle "$BACKTITLE" --title "Deploying Nimbus-Geth, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.geth.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.nimbus.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="nimbus_beacon"
            EXECUTION="geth"
            ;;
        8)
            dialog --backtitle "$BACKTITLE" --title "Deploying Nimbus-Nethermind, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.nethermind.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.nimbus.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="nimbus_beacon"
            EXECUTION="nethermind"
            ;;
        9)
            dialog --backtitle "$BACKTITLE" --title "Deploying Nimbus-Besu, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.besu.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.nimbus.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="nimbus_beacon"
            EXECUTION="besu"
            ;;
        10)
            dialog --backtitle "$BACKTITLE" --title "Deploying Teku-Geth, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.geth.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.teku.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="teku_beacon"
            EXECUTION="geth"
            ;;
        11)
            dialog --backtitle "$BACKTITLE" --title "Deploying Teku-Nethermind, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.nethermind.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.teku.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="teku_beacon"
            EXECUTION="nethermind"
            ;;
        12)
            dialog --backtitle "$BACKTITLE" --title "Deploying Teku-Besu, please wait." --prgbox "docker-compose --env-file kintsugi.vars -f docker-compose.besu.yml up -d | grep -v 'orphan' && docker-compose --env-file kintsugi.vars -f docker-compose.teku.yml up -d | grep -v 'orphan'" 20 80
            dialog --backtitle "$BACKTITLE" --ok-label "Go back"--title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
            CONSENSUS="teku_beacon"
            EXECUTION="besu"
            ;;
esac
}

detect_instances(){
    if [[ $(docker ps | grep "geth" | wc -l) = 1 ]]
    then
        EXECUTION="geth"
    elif [[ $(docker ps | grep "nethermind" | wc -l) = 1 ]]
    then
        EXECUTION="nethermind"
    elif [[ $(docker ps | grep "besu" | wc -l) = 1 ]]
    then
        EXECUTION="besu"
    else
        EXECUTION=""
    fi

    #Detect Beacon if any.
    if [[ $(docker ps | grep "lighthouse_beacon" | wc -l) = 1 ]]
    then
        CONSENSUS="lighthouse_beacon"
    elif [[ $(docker ps | grep "lodestar_beacon" | wc -l) = 1 ]]
    then
        CONSENSUS="lodestar-beacon"
    elif [[ $(docker ps | grep "teku_beacon" | wc -l) = 1 ]]
    then
        CONSENSUS="teku_beacon"
    elif [[ $(docker ps | grep "nimbus_beacon" | wc -l) = 1 ]]
    then
        CONSENSUS="nimbus_beacon"
    else
        CONSENSUS=""
    fi
}

##########  MAIN  ############ 

echo -e "Welcome to The Merge Kintsugi auto-deploy script. Please wait while We make some checks..."
echo -e "------------------------------------------------------------------------------------------\n"
sleep 1

HEIGHT=20
WIDTH=80
CHOICE_HEIGHT=12
BACKTITLE="Ethereum Foundation - The Merge"
TITLE="KinAgeMan - Kintsuge Agent Manager"

#Let's try to detect the OS.
if command -v yum &> /dev/null
then
    echo -e "Yum found, this must be some RedHat-Based host, get corporate-serious!\n"
    installscript="sudo yum install -y" 
elif command -v apt &> /dev/null
then 
    echo -e "APT found, have you mooed today??!?!?\n"
    installscript="sudo apt install -y"
elif command -v pacman &> /dev/null
then
    echo -e "Pacman found, have you told everyone you're an Arch user yet!?!?!?\n"
    installscript="sudo pacman -Sy --noconfirm"
fi

#Check if user is in the docker group. If not, i'll add it.

if [[ $(id $USERNAME | grep docker | wc -l) -eq 1 ]]
then
    echo -e "Current user, $USERNAME, is already on the docker group.\n"
else
    clear
    echo "Please provide sudo access to add your user to the docker group. You may need to re-login or reboot to apply changes and retry this script."
    sudo usermod -a -G docker $USERNAME
    exit
fi

#Now seek and/or install all the required binaries
packages=""

if ! command -v docker &> /dev/null
then
    echo -e "Command docker could not be found, we'll try to install it now."
    packages="$packages docker"
else
    echo -e "Command docker successfully found!."
fi

if ! command -v docker-compose &> /dev/null
then
    echo -e "Command docker-compose could not be found, we'll try to install it now."
    packages="$packages docker-compose"
else
    echo -e "Command docker-compose successfully found!."
fi

if ! command -v git &> /dev/null
then
    echo -e "Command git could not be found, we'll try to install it now."
    packages="$packages git"
else
    echo -e "Command git successfully found!."
fi

if ! command -v curl &> /dev/null
then
    echo -e "Command curl could not be found. we'll try to install it now."
    packages="$packages curl"
else
    echo -e "Command curl successfully found!."
fi

if ! command -v dialog &> /dev/null
then
    echo -e "Command dialog could not be found. we'll try to install it now.\n"
    packages="$packages dialog"
else
    echo -e "Command dialog successfully found!.\n"
fi

if [[ $packages != "" ]]
then 
    echo "Please provide sudo access to install missing dependencies."
    runcmd=$($installscript $packages)
fi

echo "Please press any key to continue..."
read

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=15
WIDTH=80

#Now let's check for docker daemon status
if [[ $(systemctl status docker | grep "Active: active (running)" | wc -l 2>/dev/null) != 1 ]]
then
    sudo systemctl start docker
    sleep 2
    if [[ $(systemctl status docker | grep "Active: active (running)" | wc -l 2>/dev/null) != 1 ]]
    then
        dialog --msgbox "Something went wrong starting the Docker Daemon. Please fix it and retry." 5 80
        exit 0
    else
        dialog --msgbox "Ok, now Docker daemon is up and running." 5 70
    fi
else 
    dialog --msgbox "Great, Docker daemon is already up and running!" 5 70
    #Detect running execution agents if any.
    detect_instances
fi

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Ethereum Foundation - The Merge" \
    --title "KinAgeMan Main Menu" \
    --cancel-label "Exit" \
    --clear \
    --menu "Please select an option:" $HEIGHT $WIDTH 4 \
    "1" "Check Running Containers." \
    "2" "Clean up any previous test and exit." \
    "3" "Clean up any previous test if any, resync repo and deploy a new stack." \
    "4" "Check Consensus agent logs." \
    "5" "Check Execution agent logs." \
    "6" "Check Docker engine logs." \
    "7" "How does this works? - About" \
    "8" "Ok, everything's running, what should I do next?." \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    1 )
      dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Running Containers" --prgbox "docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'" 8 60
      ;;
    2 )
      destroy_test
      exit
      ;;
    3 )
      destroy_test
      repo_clone
      test_deploy
      ;;
    4)
      detect_instances
      if [[ $CONSENSUS = "" ]]
      then
          dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Consensus Agent Logs" --msgbox "Oops, no active consensus agent found." 5 80
      else 
          dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Consensus / Beacon ($CONSENSUS) Logs" --prgbox "docker logs $CONSENSUS --tail=20" 25 120
      fi
      ;;
    5)
      detect_instances
      if [[ $EXECUTION = "" ]]
      then
          dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Execution Agent Logs" --msgbox "Oops, no active execution agent found." 5 80
      else
          dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Execution engine ($EXECUTION) Logs" --prgbox "docker logs $EXECUTION --tail=20" 25 120
      fi
      ;;
    6)
      dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "Docker Engine Logs" --prgbox "journalctl -xe -u docker" 25 120
      ;;
    7)
      dialog --backtitle "$BACKTITLE" --ok-label "Go back" --title "About" --msgbox "Hi, I'm Pablo from Argentina. This small script tries to simplify even more the great job made by the ethereum foundation guys. It should work with debian-based, arch-based and redhat-based distros (This last one is a bit tricky, might need epel installed and some wrappers for podman). First, it tries to detect the running OS, then searches for some simple dependencies, and tries to install them if they're not present. Second, looks up if the current user has the permissions to use docker containers and if not, adds it to the group. After that, creates a testnet directory inside user's home directory, and clones the Parithosh's repo in it. Detects your public IP and writes it into the kintsugi.vars file for the containers to read it. And last but not least, allows you to select what consensus and execution engines to run, and lets you see both logs in a reduced format. As extra functionalities, you can destroy previous tests, check docker daemon logs, and open your browser into the kintsugi landing page, where you have indications on how to link your metamask wallet, and get some ETH from the faucet to do all the required testing you might need. Happy Merging!!! - Please Feel free to fork and modify to your convenience." 20 90
      ;;
    8)
      xdg-open https://kintsugi.themerge.dev/
      ;;
  esac
done
