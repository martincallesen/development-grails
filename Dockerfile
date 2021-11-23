FROM martincallesen/ssh-server:latest

ARG JAVA_VERSION="8.0.292.hs-adpt"
ARG GROOVY_VERSION="3.0.8"
ARG GRADLE_VERSION="3.5.1"
ARG GRAILS_VERSION="3.3.14"

RUN apt update

RUN apt install zip unzip curl git zsh wget sudo -y

USER test

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN curl -s "https://get.sdkman.io" | bash

RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION && \
    yes | sdk install groovy $GROOVY_VERSION && \    
    yes | sdk install gradle $GRADLE_VERSION && \    
    yes | sdk install grails $GRAILS_VERSION && \        
    rm -rf $HOME/.sdkman/archives/* && \
    rm -rf $HOME/.sdkman/tmp/*"

USER root
