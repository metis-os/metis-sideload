#!/usr/bin/env bash

postRemoval() {
    clear
    echo "Removing unnecessary installation files..."
    rm -rf /mnt/post_install.sh
}

unmountingDrives() {
    clear
    echo "Unmounting all the drives" 
    umount -R /mnt
}

pointToRemember() {
    clear
    echo "After rebooting into the newly installed metis linux system, you must select xinitrc in login screen."
    echo "There are other options like Dwm, shell and xinitrc above the username field. Strictly select xinitrc, then enter your username and password and login."
    echo -n "Press enter to continue"
    read -r hello
}

installationComplete() {
    echo "Metis Linux Installation Finished!!!"
    echo " "
    echo "If you've installed metis-os in a VM, it may be buggy or could perform slow or abnormally, try disabling the picom compositor."
    echo "If you have any problems, bugs or errors, report them to https://github.com/metis-os/reports/issues or https://t.me/metislinux"
    echo "Default key-bindings for metis-linux are available at https://metislinux.org/key-bindings"
    echo "Rebooting in 1 minute!!!"
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
