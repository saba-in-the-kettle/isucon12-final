set -x

sudo chmod 777 /var/log/nginx
sudo chmod 777 /var/log/nginx/*
sudo chmod 777 /var/log/mysql
sudo chmod 777 /var/log/mysql/*


truncate -s 0 /var/log/mysql/mysql-slow.log
truncate -s 0 /var/log/nginx/access.log

set -e
sudo systemctl restart nginx
sudo systemctl restart mysql

#QUERY="USE isucon;
#INSERT INTO user_presents_deleted (id, user_id, sent_at, item_type, item_id, amount, present_message, created_at, updated_at, deleted_at) SELECT * FROM user_presents WHERE deleted_at IS NOT NULL;
#DELETE FROM user_presents WHERE deleted_at IS NOT NULl;
#"
#
#echo "$QUERY" | sudo mysql -uroot

sudo ufw disable
sudo service apparmor stop
sudo systemctl disable apparmor 
