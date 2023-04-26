
#!/bin/bash
#
# Automate ECommerce Application Deployment
# Author: Mumshad Mannambeth

#######################################
# Print a message in a given color.
# Arguments:
#   Color. eg: green, red
#######################################
function print_color(){
  NC='\033[0m' # No Color

  case $1 in
    "green") COLOR='\033[0;32m' ;;
    "red") COLOR='\033[0;31m' ;;
    "*") COLOR='\033[0m' ;;
  esac

  echo -e "${COLOR} $2 ${NC}"
}




##############################
#function to check is the firewall d is active

function is_services_active (){


service_is_active=$(sudo systemctl is-active $1)

if [ $service_is_active = "active" ]
then 
        echo "$1 is active and running"
else 
        echo "$1 is not active/running"
        exit 1
fi 


}

function is_firewalld_rule_configured(){

  firewalld_ports=$(sudo firewall-cmd --list-all --zone=public | grep ports)

  if [[ $firewalld_ports == *$1* ]]
  then
    echo "FirewallD has port $1 configured"
  else
    echo "FirewallD port $1 is not configured"
    exit 1
  fi
}


### install firewalld
print_color "green" "Installing Firewalld"

sudo yum install -y firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld


is_services_active firewalld

# INstall mariadb 
print_color green "Installing Maria DB"

sudo yum install -y mariadb-server
#sudo vi /etc/my.cnf
sudo systemctl start mariadb 
sudo systemctl enable mariadb

is_services_active mariadb