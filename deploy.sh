#! /bin/bash
app=$1
if [ ! -d "${app}" ];then
    echo "克隆项目${app}"
    git clone -b $app git@github.com:HuLuWang/wang_projiect.git $app
    cd ${app}
else
    cd ${app}
    echo "拉取项目${app}"
    git pull origin $app
fi
branch='master'
echo ${branch}
web=$(docker-compose ps | grep $branch | awk '{print $1}')
if [ -z $web ];then
    echo "构建容器: ${web}"
    docker-compose up -d
else
    echo "重启容器: ${web}"
    docker-compose restart
fi
