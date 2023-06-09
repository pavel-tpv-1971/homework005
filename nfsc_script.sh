mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
sudo apt update
sudo apt install nfs-common -y

sudo ufw allow 2222
sudo ufw allow from 192.168.1.10 to any port nfs
sudo ufw enable -y
sudo ufw status


sudo mkdir -p /nfs/upload
 sudo mount -t nfs -o vers=3 192.168.1.10:/var/nfs/upload /nfs/upload
   df -h
  
 sudo su
echo "192.168.1.10:/var/nfs/upload    /nfs/upload   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
" >> /etc/fstab
sudo touch /nfs/upload/777.test
