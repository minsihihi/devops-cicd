#!/bin/bash
# 만든 dir에 Random으로 명언 출력
# index.html에 계속 명언 새로고침됨
trap "exit" SIGINT
mkdir /var/htdocs
while :
do
    echo $(date) Writing fortune to /var/htdocs/index.html
    /usr/games/fortune  > /var/htdocs/index.html
    sleep 10
done