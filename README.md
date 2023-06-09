# homework005

Стенд Vagrant c NFS Ubuntu

# Сервер >>

mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Обновляем базу пакетов и устанавливаем программное обеспечение
sudo apt update
sudo apt install nfs-kernel-server -y

sudo su
# Настраиваем фаервол, разрешаем SSH и любые соединения от клиента по NFS с адресом -192.168.1.11
sudo ufw allow 2222
sudo ufw allow from 192.168.1.11 to any port nfs

# включаем фаервол и проверяем статус
sudo ufw enable -y
sudo ufw status

# Создаем директорию для экспорта и смотрим права доступа
sudo mkdir /var/nfs/upload -p
ls -la /var/nfs/upload

# Для безопасности NFS преобразует любые операции root на клиенте в операции с учетными данными nobody:nogroup. 
# Изменяем владельца каталога и смотрим результат
sudo chown nobody:nogroup /var/nfs/upload
 ls -la /var/nfs/upload

# Записываем строку конфигурации в файл  /etc/exports
 sudo su
echo "/var/nfs/upload    192.168.1.11(rw,sync,no_subtree_check)" >> /etc/exports

# Для работы по NFSv3 дописываем строку в файл конфигурации /etc/default/nfs-kernel-server
 sudo su
RPCMOUNTDOPTS="--manage-gids --no-nfs-version 4" >> /etc/default/nfs-kernel-server

# Перезагружаем службы
sudo systemctl restart nfs-config
sudo systemctl restart nfs-kernel-server

# Смотрим результат, что используется NFSv3
nfsstat

#-----------------------------------------

# Клиент >>

mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

# Обновляем базу пакетов и устанавливаем программное обеспечение

sudo apt update
sudo apt install nfs-common -y

# Настраиваем фаервол, разрешаем SSH и любые соединения от сервера по NFS с адресом -192.168.1.10

sudo ufw allow 2222
sudo ufw allow from 192.168.1.10 to any port nfs

# включаем фаервол и проверяем статус

sudo ufw enable -y
sudo ufw status

# Создаем точки монтирования на клиенте

sudo mkdir -p /nfs/upload
 sudo mount -t nfs -o vers=3 192.168.1.10:/var/nfs/upload /nfs/upload
   df -h
   
# Прописываем монтирование в fstab, добавляем строку  
  
 sudo su
echo "192.168.1.10:/var/nfs/upload    /nfs/upload   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
" >> /etc/fstab

# Создаем файл в примонтированной директории

sudo touch /nfs/upload/777.test

# Смотрим результат

ls -l /nfs/upload

# Если все правильно сделали, должны увидеть файл 777.test
# проверяем версию NFS, вывод должен показать верию 3
nfsstat

