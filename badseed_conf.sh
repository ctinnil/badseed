#!/bin/zsh

osascript <<"EOF"
    tell application "System Events"
        perform action "AXZoomWindow" of (first button whose subrole is "AXFullScreenButton") of (first window whose subrole is "AXStandardWindow") of (first process whose frontmost is true)
    end tell
EOF

cat << EOF
                                                                                ####################################################################
        ..'',,''..                                            ...',,''...       ##                                                                ##
  ;d0NMMMMMMMMMMMMMNKko;.                              .,cx0XMMMMMMMMMMMMMWKkc. ## * Script Name    : badseed_conf.sh                             ##
    .,l0MMMMMMMMMMMMMMMMMMNOxl;. '.           .. 'cokKWMMMMMMMMMMMMMMMMMXx:.    ## * Description    : An automation script that helps you deploy  ##
         cXMMMMMMMMMMMMMMMMMMMd   ;;..,..;. .:'  .MMMMMMMMMMMMMMMMMMMWx.        ##                    and  configure  your digital forensics and  ##
           cWMMMMMMMMMMMMMMMMMW,   ;KMMo,NMWd    0MMMMMMMMMMMMMMMMMMO.          ##                    penetration testing workstation.            ##
            .OXMMMMMMMMMMMMMMMMWl ;MMMMo,cc0MN..XMMMMMMMMMMMMMMMMN0c            ## * Args           : none                                        ##
                .cOMMMMMMMMMMMMM:.cMMMMocMWd:d, NMMMMMMMMMMMMXd,.               ## * Usage          : zsh badseed_conf.sh                         ##
                   .lNMMMMMMMMMX.x.okNMo:MMMMO ,lMMMMMMMMMMx'                   ## * Notes          : Install Homebrew to use this script.        ##
                      dMMMMMMMMx:W.N0ol':MMMM0.0.MMMMMMMMK.                     ## * Version        : 2.1                                         ##
                       :OOKNMMMllM;xMMMd:MMMM;dN.MMMWK0Ox                       ## * Author         : @ctinnil                                    ##
                             'c;cMO'MMMd'KMMX.WK.o,.                            ## * Email          : ctinnil@protonmail.com                      ##
                                .MO 0MMd,dcl,dMx                                ##                                                                ##
                                 ,kd,MMd;MM0.WM'                                ####################################################################
                                 'MM.0W';MM,kMk                                 ##                                                                ##
                                  dMk',.;Mk,MN.                                 ##  !!!                        WARNING                       !!!  ##
                                   xM':x;W.;K.                                  ##                                                                ##
                                    ,x.d;cc'                                    ##  DO  NOT  RUN THIS  SCRIPT  BLINDLY !!! This script uses quite ##
                                       ..                                       ##  many   features  and  installs   numerous  applications   and ##
                                                                                ##  libraries that may or may not be compatible with your current ##
                                                                                ##  install.  Review  it thoroughly, and edit to best  suit  your ##
                                                                                ##  needs.                                                        ##
         ******                  **    ********                      **         ##                                                                ##
        /*////**                /**   **//////                      /**         ####################################################################
        /*   /**   ******       /**  /**         *****   *****      /**         ##                                                                ##
        /******   //////**   ******  /********* **///** **///**  ******         ##  ***                      Requirements                    ***  ##
        /*//// **  *******  **///**  ////////**/*******/******* **///**         ##  + macOS Catalina 10.15 or higher                              ##
        /*    /** **////** /**  /**         /**/**//// /**//// /**  /**         ##  + Support for hypervisor applications (like Docker)           ##
        /******* //********//******   ******** //******//******//******         ##  + Recommended hardware: 4GB+ RAM, 150GB+ HDD and 2+ CPUs      ##
        ///////   ////////  //////   ////////   //////  //////  //////          ##  + Some installs require that you are signed in with your  ID ##
                                                                                ##                                                                ##
                                                                                ####################################################################
EOF

# Set continue to false by default
CONTINUE=false

echo ""
echo "###############################################"
echo "#        DO NOT RUN THIS SCRIPT BLINDLY       #"
echo "#         YOU'LL PROBABLY REGRET IT...        #"
echo "#                                             #"
echo "#              READ IT THOROUGHLY             #"
echo "#         AND EDIT TO SUIT YOUR NEEDS         #"
echo "###############################################"
echo ""


echo ""
echo "Have you read through the script you're about to run and "
echo "understood that it will make changes to your computer? (y/n)"
read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
  CONTINUE=true
fi

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  echo "Please go read the script, it only takes a few minutes"
  exit
fi

# Ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# get macOS version
echo "Your macOS version is ..."
sw_vers -productVersion

# turn firewall on
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
echo "Your Firewall is on ..."

# install xcode command line tool
xcode-select --install
xcode-select -p
echo "Xcode command line tools installed ... "

sleep 60

echo "Homebrew checkup ... "

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
  
# update all
echo "Let's update your software and Homebrew recipes ..."
sudo softwareupdate -ia --verbose
brew update
brew install gcc #necessary before ack and others
brew install --cask oracle-jdk #Oracle Java Standard Edition Development Kit
echo "Homebrew is up to date ... "

echo ""
echo "Activate Screensaver aftre 1 minute idle "
defaults -currentHost write com.apple.screensaver idleTime 60

echo ""
echo "Setting the Pro theme by default in Terminal.app"
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"

echo ""
echo "Enable tap-to-click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo ""
echo "Change path to home directory ... "
cd 

PACKAGES=(
    ack
    aircrack-ng 
    archey 
    aria2
    bettercap
    binwalk 
    bulk_extractor
    cmake
    cobalt 
    cointop
    coreutils
    crunch
    curl
    ettercap 
    exploitdb 
    ffmpeg
    findomain 
    fzf
    gettext
    gifsicle
    go
    gobuster
    graphviz
    hashcat 
    htop 
    hub
    hydra 
    icdiff
    imagemagick
    john 
    jq
    kafka
    libjpeg
    llvm
    lynx
    macvim
    markdown
    mas
    masscan
    midnight-commander
    mitmproxy
    mosh
    netcat
    netcat6
    nikto 
    nmap 
    openssh
    p7zip
    php
    pipenv
    proxychains-ng
    pypy 
    python3
    recon-ng 
    rustscan
    selenium-server-standalone
    speedtest-cli 
    sqlite
    sqlmap 
    tcpdump 
    termius
    the_silver_searcher
    theharvester 
    tmux
    trash-cli
    tree 
    upx 
    volatility 
    wget 
    wiki
    yara
    yarn 
)

CASKS=(
    balenaetcher
    binary-ninja
    burp-suite
    ccleaner
    db-browser-for-sqlite
    deluge
    dotnet-sdk
    drawio
    enpass
    firefox
    ghidra
    github
    google-chrome
    gpg-suite-pinentry
    hex-fiend
    keka
    knockknock
    maltego
    malwarebytes
    merlin-project
    metasploit
    microsoft-remote-desktop
    miniconda
    netiquette
    oracle-jdk-javadoc
    owasp-zap
    plistedit-pro
    postman
    pycharm-ce
    reikey
    spectacle
    sublime-text
    taskexplorer
    termius
    virtualbox
    visual-studio-code
    vlc
    vnc-viewer
    wireshark
    xmind
    zenmap
)

echo ""
echo "Installing packages ... "
brew install ${PACKAGES[@]}

echo ""
echo "Installing cask apps ... "
brew install --cask ${CASKS[@]}

echo ""
echo "Installing beEF framework ... "
git clone https://github.com/beefproject/beef.git
cd beef 
wget https://raw.githubusercontent.com/beefproject/beef/master/Gemfile
bundle install
./install 
cd

echo ""
echo "npm package manager installing and configuring ... "
mkdir ~/.nvm
export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
source ~/.bash_profile
nvm_ver=$(nvm ls-remote | grep "Latest LTS" | tail -1 |  awk '{print $1}')
nvm install $nvm_ver

npm install -g npm
npm i -g dependency-cruiser

echo ""
echo "Installing Python packages ... "
python3 -m pip install --upgrade setuptools
python3 -m pip install --upgrade pip

PYTHON_PACKAGES=(
    beautifulsoup4
    impacket
    ipython
    joblib
    jupyter
    jupyterlab
    numpy 
    pandas
    python3-nmap
    raccoon-scanner
    requests
    quark-engine
    scapy
    times
    urllib3
    virtualenv
    virtualenvwrapper
)

sudo python3 -m pip install -U ${PYTHON_PACKAGES[@]}

echo ""
echo "Installing basecrack ... "
git clone https://github.com/mufeedvh/basecrack.git
cd basecrack
sudo python3 -m pip install -r requirements.txt
echo "Run 'python3 basecrack.py -h' to use "
cd 

echo ""
echo "Installing CALDERA ... "
git clone https://github.com/mitre/caldera.git --recursive --branch 3.0.0
cd caldera
sudo python3 -m pip install -r requirements.txt
echo "Run 'python3 server.py --insecure' and go to http://localhost:8888 after starting the server "
cd

echo ""
echo "Installing PaGoDo - Passive Google Dork ... "
git clone https://github.com/opsdisk/pagodo.git
cd pagodo
sudo python3 -m pip install -r requirements.txt
echo "Run 'proxychains4 python3 pagodo.py -g ALL_dorks.txt -s -e 17.0 -l 700 -j 1.1' to use "
cd

echo ""
echo "Installing Ruby gems ... "
RUBY_GEMS=(
    bundler
    filewatcher
    cocoapods
)
sudo gem install ${RUBY_GEMS[@]}

echo ""
echo "Installing Amass ... "
brew tap caffix/amass
brew install amass

echo ""
echo "Installing Recox v2.0 ... "
git clone https://github.com/samhaxr/recox.git
cd recox
chmod +x recox.sh
echo "Run './recox.sh' to use the module"
cd

echo ""
echo "Installing Wappalyzer ... "
git clone https://github.com/aliasio/wappalyzer
cd wappalyzer
yarn install
yarn run link
echo "Run 'node src/drivers/npm/cli.js https://example.com' to use the module"
cd

echo ""
echo "Installing DIE -- Detect It Easy ... "
#DIE -- Detect It Easy -- may need yo check https://github.com/horsicq/Detect-It-Easy for the latest version
wget https://github.com/horsicq/DIE-engine/releases/download/3.01/die_mac_portable_3.01.dmg
sudo hdiutil attach die_mac_portable_3.01.dmg
sudo cp -R /Volumes/die_mac_portable/die.app /Applications
sudo hdiutil unmount /Volumes/die_mac_portable

echo ""
echo "Installing Modlishka ... Check out more here: https://github.com/drk1wi/Modlishka"
go get -u github.com/drk1wi/Modlishka
GOPATH=$(go env GOPATH)
$GOPATH/bin/Modlishka
echo "Run '$GOPATH/bin/Modlishka' to use the module"

echo "Installing ZGrab 2.0 ... Check out more here: https://github.com/zmap/zgrab2"
go get -u github.com/zmap/zgrab2
GOPATH=$(go env GOPATH)
cd $GOPATH/src/github.com/zmap/zgrab2
make
echo "Example usage './zgrab2 ssh'"

echo ""
echo "Installing zphisher ... "
git clone git://github.com/htr-tech/zphisher.git
echo "Run 'zsh zphisher/zphisher.sh ' to use the module"

echo ""
echo "Installing l9explore ... Check out more here: https://github.com/LeakIX/l9explore"
wget -O l9explore https://github.com/LeakIX/l9explore/releases/download/v1.2.2/l9explore-osx
mv l9explore /usr/local/bin/l9explore
echo "Checkout source here: https://github.com/LeakIX/l9explore"
echo "Run 'l9explore service -h'"

echo ""
echo "Installing l9tcpid ... Check out more here: https://github.com/LeakIX/l9tcpid"
wget -O l9tcpid https://github.com/LeakIX/l9tcpid/releases/download/v1.1.0/l9tcpid-osx
mv l9tcpid /usr/local/bin/l9tcpid
echo "Checkout source here: https://github.com/LeakIX/l9explore"
echo "Run 'l9tcpid service -h'"

echo ""
echo "Set BaD SeeD workstation wallpaper"
git clone https://github.com/ctinnil/badseed.git
cp badseed/lockscreen.jpg ~/Pictures/lockscreen.jpg
path_of_logo=$(echo ~/Pictures/lockscreen.jpg)
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "'"$path_of_logo"'"'

#check installs
brew doctor 

echo ""
echo "Cleaning up..."
brew cleanup

# enable terminal autocomplet 
set show-all-if-ambiguous on

echo ""
echo "Setup complete !!! Please restart your system."
echo ""
