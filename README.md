#**KinAgeMan**
##A Kintsuge testnet Agent Manager

I wrote this small script trying to simplify even more the great work made by the guys at the ethereum foundation for deploying infrastructure for their testnet, kintsugi.
I could have done it using python or another language, but I've decided to use the least amount of requirements posible, and keeping as simple as i can. So, besides the original requirements
listed in https://hackmd.io/dFzKxB3ISWO8juUqPpJFfw, it only requires:

- Bash (duh)
- cURL / sed (used for public IP detection and writing into kintsugi.vars)
- sudo (for installing packages, starting daemons and deleting some files created by the genesis process)
- Dialog (for some fancy menus)

The first three are available by default on all major distros.

## **What's supposed to do almost automagically?**

Well, basically most of the processes involved in the original hackmd document. But i'll resume it:

- Detect your username, and check if it has permissions into the docker group for starting containers. If not, it will ask for sudo credentials, fix it and ask you to logout or reboot to apply and retry.
- Detect your operating system (barely, I just look for pacman, yum or apt to decide what package manager to use if I need to install something)
- Detect if all the required dependencies are installed. If not, will try to install them asking your sudo access.
- Start a dialog menu
- Detect if Docker daemon is running. If not, it will try to start it, and if it fails will inform you.
- Offer a main menu, where you have the options to check if there are any instances running, wipe all, deploy from scratch, and checking logs from both consensus and execution agents. Also, you can look up docker daemon logs.
- Finally, an option to open your browser right into the kintsugi land page, where you can link your metamask wallet to the testnet, and get some test ETH from the faucet. In that site, you'll also have broader documentation, links to support groups and all you may need.

It "should" work on mostly modern linux distros if you have all the requirements met, if not, the missing packages self-installation it's only meant to work on arch/debian/redhat based distros.

## **Okay, you convinced me, how should i run this?**

Pretty simple. 

- Open your terminal
- run the following commands.
  ```
  curl https://raw.githubusercontent.com/elpardua/kinageman/main/kinageman.sh --output kinageman.sh
  chmod +x kinageman.sh
  ./kinageman.sh
  ```
