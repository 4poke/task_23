#!/bin/bash
set -x
log_access="/var/log/nginx/access.log"
log_upstream="/var/log/nginx/upstream.log"
log_200="/home/ubuntu/nginx/logs/200error.log"
log_500="/home/ubuntu/nginx//logs/500error.log"
log_400="/home/ubuntu/nginx/logs/400error.log"
clean_log200="/home/ubuntu/nginx/logs/clean200error.log"
clean_log400="/home/ubuntu/nginx/logs/clean400error.log"
clean_log500="/home/ubuntu/nginx/logs/clean500error.log"
upstream_log200="/home/ubuntu/nginx/logs/upstream200.log"
upstream_log300="/home/ubuntu/nginx/logs/upstream300.log"
upstream_log400="/home/ubuntu/nginx/logs/upstream400.log"
upstream_log500="/home/ubuntu/nginx/logs/upstream500.log"
upstream_clean200="/home/ubuntu/nginx/logs/upstream_clean200.log"
upstream_clean300="/home/ubuntu/nginx/logs/upstream_clean300.log"
upstream_clean400="/home/ubuntu/nginx/logs/upstream_clean400.log"
upstream_clean500="/home/ubuntu/nginx/logs/upstream_clean500.log"
max_size=307200  

#проверка на существование папки logs
LOG_DIR="/home/ubuntu/nginx/logs"
if [ ! -d $LOG_DIR ]; then
echo "directory doesn't exist"
mkdir -p $LOG_DIR
fi

while true; do
    #Грепает ошибки по коду в access логе
    grep "200" $log_access >> $log_200
    grep "500" $log_access >> $log_500
    grep "400" $log_access >> $log_400
    echo "All access logs are greped"
    #грепает ошибки по коду в upstream логе
    if grep  "200" $log_upstream; then
        grep "200" $log_upstream >> $upstream_log200
    fi
    grep "500" $log_upstream >> $upstream_log500
    grep "400" $log_upstream >> $upstream_log400
    grep "300" $log_upstream >> $upstream_log300
    echo "All upstream logs are greped"

    # Проверяет 200error.log и удаляет содержимое, если файл превышает max_size
    if [ $(stat -c%s "$log_200") -gt $max_size ]; then
        echo "$(date): Cleaned $log_200" >> $clean_log200
        > $log_200
    fi
    # прверяет 400error.log И удаляет содержимое как и выше^
    if [ $(stat -c%s "$log_400") -gt $max_size ]; then
        echo "$(date): Cleaned $log_400" >> $clean_log400  
        > $log_400
    fi
    #проверяет 500error.log 
if [ $(stat -c%s "$log_500") -gt $max_size ]; then
        echo "$(date): Cleaned $log_500" >> $clean_log500  
        > $log_500
    fi
    #проверяет upstream200.log
    if [ $(stat -c%s "$upstream_log200") -gt $max_size ]; then
        echo "$(date): Cleaned $upstream_log200" >> $upstream_clean200 
        > $upstream_log200
    fi
    #проверяет upstream300.log
    if [ $(stat -c%s "$upstream_log300") -gt $max_size ]; then
        echo "$(date): Cleaned $upstream_log300" >> $upstream_clean300 
        > $upstream_log300
    fi
    #проверяет upstream400.log
    if [ $(stat -c%s "$upstream_log400") -gt $max_size ]; then
        echo "$(date): Cleaned $upstream_log400" >> $upstream_clean400 
        > $upstream_log400
    fi
    #проверяет upstream500.log
    if [ $(stat -c%s "$upstream_log500") -gt $max_size ]; then
        echo "$(date): Cleaned $upstream_log500" >> $upstream_clean500 
        > $upstream_log500
    fi
    echo "All  logs are wrote"
    sleep 5
    
done
