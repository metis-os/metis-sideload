#!/usr/bin/env bash

failed() {
  clear
  echo -e "Something went wrong.\nThe command could not be executed correctly!\nPlease try again.\nExitting...\nReport any problem, bug, and errors to https://github.com/metis-os/reports/issues"
  
  exit 1
}

installationError() {
  clear
  echo -e "Something went wrong.\nAll the packages couldn't be installed correctly!\nPlease try again.\nExitting...\nReport any problem, bug, and errors to https://github.com/metis-os/reports/issues"
  exit 1
}

ignoreableErrors() {
  clear
  echo -e "Something went wrong.\nOS is installing and could be useable but the error should be manually fixed later...\nReport any problem, bug, and errors to https://github.com/metis-os/reports/issues"
}

serviceError() {
    echo -e "Error unable to enable the service....\nInstallation will be continued but you need to enable the service manually after reboot.\nReport any problem, bug, and errors to https://github.com/metis-os/reports/issues"
}

displayArt(){
  clear
  echo -ne "
  Installing Metis Linux in a VM is not recommended as it may perform slow and buggy.
  __________________________________________________________________________________________________________
  |                                                                                                         |
  |                       +-+-+-+-+-+        +-+-+-+-+-+        +-+-+-+-+-+-+-+-+-+                         |
  |                       |M|a|g|i|c|        |M|e|t|i|s|        |I|n|s|t|a|l|l|e|r|                         |
  |                       +-+-+-+-+-+        +-+-+-+-+-+        +-+-+-+-+-+-+-+-+-+                         |
  |                                                                                                         |
  |---------------------------------------------------------------------------------------------------------|
  |                                                PHASE 2                                                  |
  |---------------------------------------------------------------------------------------------------------|
  |                                 Install Metis Linux in few clicks                                       |
  |               Check: https://github.com/metis-os for details or visit https://metislinux.org            |
  |---------------------------------------------------------------------------------------------------------|
  |_________________________________________________________________________________________________________|
  "
  read -r nothing
}

generatingLocale() {
    clear
    echo "Generating locale at /etc/locale.gen"
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen || ignoreableErrors
    locale-gen
}

timezone() {
    echo "Getting Timezone..."
    time_zone="$(curl --fail https://ipapi.co/timezone)"
    clear
    echo "System detected your timezone to be $time_zone."
    echo "Incase automatic detection fails, go with no. 2 and enter the timezone manually"
    echo "Is this correct?"

    PS3="Select one.[1/2]: "
    options=("Yes" "No")
    select one in "${options[@]}"; do
        case $one in
            Yes)
                echo "$time_zone set as timezone"
                ln -sf "/usr/share/zoneinfo/${time_zone}" /etc/localtime && break
                ;;
            No)
                echo -n "Please enter your desired timezone e.g. Asia/Kathmandu or Europe/London (Case Sensative): "
                read -r new_timezone
                echo "Checking timezone $new_timezone ..."
                if ! ls "/usr/share/zoneinfo/${new_timezone}"
                then
                  echo "Timezone ${new_timezone} doesnot exist."
                else  
                  echo "Timezone ${new_timezone} found. Setting it up..."
                  sleep 2s
                  ln -sf "/usr/share/zoneinfo/${new_timezone}" /etc/localtime && break
                fi
                ;;
            *)
            echo "Wrong option. Try again..."
            timezone
            ;;
        esac
    done
}

settingTimezone() {
    clear
    timezone
    hwclock --systohc
    echo "Checking system date and time..."
    date
}

settingLang() {
    clear
    echo "Setting LANG variable"
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf
    echo "LC_COLLATE=C" >> /etc/locale.conf
    echo "Checking system language..."
    cat /etc/locale.conf || ignoreableErrors
}

settingKeyboard() {
    clear
    echo "Setting console keyboard layout"
    echo "KEYMAP=us" > /etc/vconsole.conf
    echo "Checking system Keyboard Layout..."
    cat /etc/vconsole.conf || ignoreableErrors
}

settingHostname() {
    clear
    echo -n "Enter your computer name: "
    read -r hostname
    echo "$hostname" > /etc/hostname
    echo "Checking hostname (/etc/hostname)"
    cat /etc/hostname || ignoreableErrors
}

settingHosts() {
    clear
    echo "setting up hosts file"
    {
        echo "127.0.0.1       localhost"
        echo "::1             localhost"
        echo "127.0.1.1       $hostname.localdomain     $hostname"
    } >> /etc/hosts

    echo "checking /etc/hosts file"
    cat /etc/hosts || ignoreableErrors
}

installingBootloader() {
    #if you are dualbooting, add os-prober with grub and efibootmgr
    pacman -Sy --needed --noconfirm grub networkmanager-runit zsh
}

bootloaderCompleted() {
  s=0
  for ((i=1;i<=5;i++)); do
    if ! installingBootloader; then
      ((s++))
      if ((s==5)); then
        echo "Bootloader installation failed..."
        installationError
      fi
        echo "Bootloader installation failed. Retrying..."
      else {
        echo "Bootloader installation successful..."
        break
      }
    fi
  done
}

enablingNetworkManager() {
    clear
    echo "Enabling NetworkManager service for runit..."
    ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default || serviceError
    clear
}

loginManager(){
    pacman -Sy --needed --noconfirm metis-ly metis-ly-runit
}

installingLoginManager() {
  s=0
  for ((i=1;i<=4;i++)); do
    if ! loginManager; then
      ((s++))
      if ((s==4)); then
        echo "Login manager installation failed..."
        ignoreableErrors
      fi
        echo "Ly login manager installation failed. Retrying..."
      else {
        echo "ly login manager installation successful..."
        clear
        echo "Enabling metis-ly service for runit"
        echo "This could sometimes popup a demo login screen"
        echo "If occured just press ctrl + alt + f1 keys together and continue the installation..."
        rm -rf /etc/runit/runsvdir/default/agetty-tty2 || ignoreableErrors
        ln -s /etc/runit/sv/ly /etc/runit/runsvdir/default || serviceError
        break
      }
    fi
  done
}

addingUser() {
    clear
    echo "Enter password for root user!"
    passwd
    clear
    echo "Adding regular user!"
    echo -n "Enter username to add a regular user: "
    read -r username
    useradd -m -g users -G wheel,audio,video,network,storage -s /bin/zsh "$username" || ignoreableErrors
    echo "To set password for $username, use different password than of root."
    echo "Enter password for $username! "
    passwd "$username"
    echo "NOTE: ALWAYS REMEMBER THIS USERNAME AND PASSWORD YOU PUT JUST NOW."
}

sudoAccess() {
    clear
    echo "Giving sudo access to $username!"
    echo "$username ALL=(ALL) ALL" >> /etc/sudoers.d/"$username"
}

copyingConfig() {
    clear
    echo "Copying config file to their absolute path..."
    mv /config/os-release /usr/lib/ || failed
    mv /config/grub /etc/default/grub || failed
    mv /config/issue /etc/issue || failed
    mv /etc/artix-release /etc/metis-release || failed

    mv /config/xinitrc /home/"$username"/.xinitrc || failed
    chown "$username":users /home/"$username"/.xinitrc || failed
    mv /config/zshrc /home/"$username"/.zshrc || failed
    chown "$username":users /home/"$username"/.zshrc || failed

    mv /config /home/"$username"/.config/ || ignoreableErrors
    chown -R "$username":users /home/"$username"/.config || ignoreableErrors
}

installingPackages() {
    pacman -Sy --needed --noconfirm metis-dwm metis-st metis-dmenu metis-wallpapers xorg-server xorg-xinit xorg-xsetroot nerd-fonts-jetbrains-mono ttf-font-awesome pavucontrol pulseaudio pulseaudio-alsa firefox brillo git neovim metis-slstatus picom-jonaburg-git acpi xwallpaper libxft-bgra polkit
}

packagesCompleted() {
  s=0
  for ((i=1;i<=5;i++)); do
    if ! installingPackages; then
      ((s++))
      if ((s==5)); then
        echo "Failed to install required package for metis-os..."
        installationError
      fi
        echo "Failed to install required package for metis-os. Retrying..."
      else {
        echo "Installation of required package for metis-os is successful..."
        break
      }
    fi
  done
}

installingMicrocode() {
    clear
    if lscpu | grep  "GenuineIntel"; then
        echo "Installing Intel microcode"
        pacman -S --noconfirm --needed intel-ucode || ignoreableErrors
    elif lscpu | grep "AuthenticAMD"; then
        echo "Installing AMD microcode"
        pacman -S --noconfirm --needed amd-ucode || ignoreableErrors
    fi
}

selectDrive() {
  lsblk
  echo "Enter the drive name to install bootloader in it. (eg: sda or nvme01 or vda or something similar)! "
  echo "NOTE: JUST GIVE DRIVE NAME (sda, nvme0n1, vda or something similar); NOT THE PARTITION NAME (sda1)"
  echo -n "Enter the drive name: "
  read -r grubdrive
}

checkDrive() {
  while ! lsblk | grep "$grubdrive"  &> /dev/null
  do
    clear
    echo -e "$grubdrive drive is not found. Check your available disks in which you are installing metis os and try again..."
    selectDrive
  done
}

selectGrub() {
  lsblk
  echo -n "Enter the boot/grub installation partition (eg: sda1 or nvme0n1p2 or vda4): "
  read -r grubpartition
}

checkGrub() {
  while ! lsblk | grep "$grubpartition"  &> /dev/null
  do
    clear
    echo -e "$grubpartition partition is not found. Check your available partitions and try again..."
    selectGrub
  done
}

uefiPackages() {
  pacman -Sy --needed --noconfirm efibootmgr dosfstools
}

uefiCompleted() {
  echo "UEFI system detected!"
  echo "Installing efibootmgr and dosfstools..."
  s=0
  for ((i=1;i<=5;i++)); do
    if ! uefiPackages; then
      ((s++))
      if ((s==5)); then
        echo "Failed to install efibootmgr abd dosfstools..."
        installationError
      fi
        clear
        echo "Failed to install efibootmgr and dosfstools. Retrying..."
      else {
        echo "Installation of efibootmgr and dosfstools successful..."
        break
      }
    fi
  done
}

configuringBootloader() {
    clear
    if [[ ! -d "/sys/firmware/efi" ]]; then
      echo "Legacy system detected..."
      selectDrive
      checkDrive
      grub-install --target=i386-pc /dev/"$grubdrive"
      grub-mkconfig -o /boot/grub/grub.cfg
    else
      uefiCompleted
      clear
      selectGrub
      checkGrub
      mkfs.fat -F 32 /dev/"$grubpartition" || failed
      mkdir -p /boot/efi
      mount /dev/"$grubpartition" /boot/efi
      lsblk
      if mountpoint /boot/efi = "/boot/efi is not a mountpoint"; then
        clear
        echo -e "$grubpartition is not mounted successfully. Aborting installation!\nInstallation failed..."
        exit 1
      else
        echo "Cool $grubpartition mounted at /boot/efi! Installing grub..."
      fi
      grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=metis --removable || failed
      grub-mkconfig -o /boot/grub/grub.cfg || failed
    fi
}
 
graphicsDriver() {
    clear
    echo "Searching and Installing graphics driver if available"
    if lspci | grep "NVIDIA|GeForce"; then
        pacman -S --noconfirm --needed nvidia nvidia-utils || ignoreableErrors
    elif lspci | grep 'VGA' | grep -E "Radeon|AMD"; then
        pacman -S --noconfirm --needed xf86-video-amdgpu || ignoreableErrors
    elif lspci | grep "Integrated Graphics Controller"; then
        pacman -S --noconfirm --needed libva-intel-driver libvdpau-va-gl vulkan-intel libva-utils || ignoreableErrors
    elif lspci | grep -E "Intel Corporation UHD|Intel Corporation HD"; then
        pacman -S --needed --noconfirm libva-intel-driver libvdpau-va-gl vulkan-intel libva-intel-driver libva-utils || ignoreableErrors
    fi
}

secondphaseCompleted(){
    clear
    echo "Second Phase Completed!"
    echo "Entering into Final Phase of Installation..."
    echo "Run the following commands to start final phase..."
    echo "1. exit"
    echo "2. final.sh"
}

displayArt
generatingLocale
settingTimezone
settingLang
settingKeyboard
settingHostname
settingHosts
bootloaderCompleted
enablingNetworkManager
addingUser
sudoAccess
copyingConfig
packagesCompleted
installingMicrocode
configuringBootloader
graphicsDriver
installingLoginManager
secondphaseCompleted
