#!/usr/bin/env sh
BASEDIR=$(dirname "$0")
cd "$BASEDIR"
clear

showVersion() {
    echo "\033[0;32mYork Image Generator\033[0m"
    echo "version \033[0;33mv1.0.0\033[0m 2020-12-29 12:23:01"
    echo "Copyright (c) 2020-2021 York"
}

showFolder() {
    # 讀取所有 folder
    rawFolderList=($(ls | grep -v ".sh" | grep -v ".md"))
    echo "\033[0;32m編號\tDockerfile名稱\033[0m"
    # 依序顯示
    for i in ${!rawFolderList[@]}; do
        folderName=${rawFolderList[${i}]}
        echo "${i}\t${folderName}"
    done
}

while :
do
    showVersion
    echo "----------------------------------------"
    echo "選擇指令:"
    echo "----------------------------------------"
    echo "l.\t顯示所有 Image"
    echo "d.\t顯示所有 Dockerfile"
    echo "b.\t建立 Image"
    echo "r.\t刪除 Image"
    echo "p.\t推送 Image"
    echo "q.\t離開"
    read -p "指令:" input

    clear

    case $input in
        l) # 顯示所有 Image
            docker images
            echo "----------------------------------------"
            ;;
        d) # 顯示所有 Dockerfile
            showFolder
            ;;
        b) # build Dockerfile
            clear
            echo "----------------------------------------"
            showFolder
            echo "----------------------------------------"
            read -p "選擇要建立的 Image number:" number
            clear
            # 讀取所有 Folder
            rawFolderList=($(ls | grep -v ".sh" | grep -v ".md"))
            # tag name
            tagName=$( echo ${rawFolderList[${number}]} | sed 's/Dockerfile-//g' | sed 's/.dockerfile//g')
            # 建立 Image
            docker build . -f ./${rawFolderList[${number}]} -t tinayork/php:${tagName}
            echo "\033[0;32m已經建立 tinayork/${tagName} 的 Image 在本地端\033[0m"
            echo "----------------------------------------"
            ;;
        r) # remove Image
            clear
            echo "----------------------------------------"
            docker images
            echo "----------------------------------------"
            read -p "輸入要刪除的 IMAGE ID:" id
            clear
            # 刪除 Image
            echo ${id}
            docker rmi ${id}
            echo "----------------------------------------"
            ;;
        p) # push image
            clear
            echo "----------------------------------------"
            showFolder
            echo "----------------------------------------"
            read -p "選擇要推的 Image number:" number
            clear
            # 讀取所有 Folder
            rawFolderList=($(ls | grep -v ".sh" | grep -v ".md"))
            # tag name
            tagName=$( echo ${rawFolderList[${number}]} | sed 's/Dockerfile-//g' | sed 's/.dockerfile//g')
            # 推 Image 至 docker hub
            docker push tinayork/${tagName}
            echo "\033[0;32m已經推送 tinayork/${tagName} 的 Image 在 tinayork 的 dockerhub\033[0m"
            echo "----------------------------------------"
            ;;
        *) # 離開程序
            exit
            ;;
    esac
done
