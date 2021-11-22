FROM martincallesen/ssh-server:latest
USER test
ARG JAVA_VERSION="8.0.292.hs-adpt"
ARG GROOVY_VERSION="3.0.8"
ARG GRADLE_VERSION="3.5.1"

RUN apt update

RUN apt install zip unzip curl git sudo -y

RUN curl -s "https://get.sdkman.io" | bash

RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION && \
    yes | sdk install groovy $GROOVY_VERSION && \    
    yes | sdk install gradle $GRADLE_VERSION && \    
    rm -rf $HOME/.sdkman/archives/* && \
    rm -rf $HOME/.sdkman/tmp/*"
