docker run --name development-grails -v /var/run/docker.sock:/var/run/docker.sock -d martincallesen/development-grails
docker exec development-grails chmod 777 /var/run/docker.sock
