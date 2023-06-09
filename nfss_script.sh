mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
sudo apt update
sudo apt install nfs-kernel-server -y
sudo su


sudo ufw allow 2222
sudo ufw allow from 192.168.1.11 to any port nfs

sudo ufw enable -y
sudo ufw status

sudo mkdir /var/nfs/upload -p
ls -la /var/nfs/upload

sudo chown nobody:nogroup /var/nfs/upload
 ls -la /var/nfs/upload
 
 sudo su
echo "/var/nfs/upload    192.168.1.11(rw,sync,no_subtree_check)" >> /etc/exports
 sudo su
RPCMOUNTDOPTS="--manage-gids --no-nfs-version 4" >> /etc/default/nfs-kernel-server
sudo systemctl restart nfs-config

sudo systemctl restart nfs-kernel-server

      
 
 
  
