#!/bin/sh

# This script get latest source files from official github nginx repository
# After that using "git resret --hard" command we can go to at commit 285a495d

#### Define Variables

official_nginx_git_repo=https://github.com/nginx/nginx.git

official_nginx_repo=http://nginx.org/download

commit_id=285a495d

docker_image_tag=nginx_custom_vay

PROJECT_PATH=$PWD

#### Build script

# Remove nginx source directories
rm -rf $PROJECT_PATH/nginx && rm -rf $PROJECT_PATH/nginx-source-file

git clone $official_nginx_git_repo

cd $PROJECT_PATH/nginx

git reset --hard $commit_id > head.txt 

# Get nginx tag for commit_id
nginx_tag=$(cat head.txt | tr '-' ' ' | awk '{print $7}')

echo "NGINX TAG for commit $commit_id is $nginx_tag"
rm -f head.txt && cd $PROJECT_PATH

# Create temporary directory
mkdir $PROJECT_PATH/nginx-source-file

# Get ngnix source files
wget $official_nginx_repo/nginx-$nginx_tag.tar.gz -O nginx-source-file/nginx.tar.gz

# Export NGINX_TAG value for using in the docker-compose file
#export NGINX_TAG=$nginx_tag
#export DOCKER_IMAGE_TAG=$docker_image_tag
echo "NGINX_TAG=$nginx_tag" > $PROJECT_PATH/.env
echo "DOCKER_IMAGE_TAG=$docker_image_tag" >> $PROJECT_PATH/.env
