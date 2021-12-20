docker run --name development-grails -p 22:22 -v /var/run/docker.sock:/var/run/docker.sock -d martincallesen/development-grails
docker exec development-grails chmod 777 /var/run/docker.sock
