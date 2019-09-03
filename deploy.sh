#! /bin/bash
app='wang_project'
echo "${app}"

branch='master'
echo ${branch}
git checkout ${branch}
git pull

web=$(docker-compose ps | grep wang_projiect_web_1)

if [ -z $web ];then
    echo "构建容器: ${web}"
    docker-compose up -d
else
    echo "重启容器: ${web}"
    docker-compose restart
fi


