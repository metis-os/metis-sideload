#!/usr/bin/env bash

postRemoval() {
    clear
    echo "Removing unnecessary installation files..."
    rm -rf /mnt/post_install.sh
    sleep 2s
}

unmountingDrives() {
    clear
    echo "Umounting all the drives" 
    umount -R /mnt
    sleep 2s
}

pointToRemember() {
    sleep 2s
    clear
    echo "After Reboting into newly installed metis linux system, you must select xinitrc in login screen."
    echo "There's are options like Dwm, shell and xinitrc above the username field. Strictly select xinitrc, then enter your username and password and login."
    echo " "
    echo "Password fields are shown as 0 characters in place of astrik(*) without showing the actual password."
    echo "This a one time process rather call first time process. Then it will remember xinitrc and your username. You just need to enter your password from second logins."
    echo " "
    sleep 15s
}

installationComplete() {
    echo "Metis Linux Installation Finished!!!"
    echo " "
    echo "If you've installed metis-os in a VM, it may be buggy or could perform slow or abnormal, try disabling picom compositor."
    echo "If you get any problem, bug, or error, report it to https://github.com/metis-os/reports/issues or https://t.me/metislinux"
    echo "Default key-bindings for metis-linux is available at https://metislinux.org/key-bindings"
    echo "Rebooting in 1 minute!!!"
    sleep 60s
    loginctl reboot
}

displayArt() {
    clear
    echo -ne "
    __________________________________________________________________________________________________________
    |                                   Thanks For Choosing Metis Linux!                                      |
    |                                                                                                         |
    |                       +-+-+-+-+-+        +-+-+-+-+-+        +-+-+-+-+-+-+-+-+-+                         |
    |                       |M|a|g|i|c|        |M|e|t|i|s|        |I|n|s|t|a|l|l|e|r|                         |
    |                       +-+-+-+-+-+        +-+-+-+-+-+        +-+-+-+-+-+-+-+-+-+                         |
    |                                                                                                         |
    |---------------------------------------------------------------------------------------------------------|
    |                                           INSTALLATION SUCCESSFUL!                                      |
    |---------------------------------------------------------------------------------------------------------|
    |                                 Metis Linux Installation Completed.                                     |
    |               Check: https://github.com/metis-os for details or visit https://metislinux.org            |
    |---------------------------------------------------------------------------------------------------------|
    |_________________________________________________________________________________________________________|
    "
}

postRemoval
unmountingDrives
displayArt
pointToRemember
installationComplete
