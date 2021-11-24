FROM martincallesen/ssh-server:latest

ARG JAVA_VERSION="8.0.292.hs-adpt"
ARG GROOVY_VERSION="3.0.8"
ARG GRADLE_VERSION="3.5.1"
ARG GRAILS_VERSION="3.3.14"

RUN apt update

RUN apt install zip unzip curl git zsh wget locales sudo -y

USER test

#Install oh-my-zsh with plugins
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

RUN sed -i.bak 's/^plugins=(\(.*\)/plugins=(zsh-autosuggestions zsh-syntax-highlighting \1/' ~/.zshrc

#Create directories needed for development of a grails project
RUN mkdir ~/.gradle

RUN mkdir ~/.grails

RUN mkdir ~/projects

#Install grails tools
RUN curl -s "https://get.sdkman.io" | bash

RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION && \
    yes | sdk install groovy $GROOVY_VERSION && \    
    yes | sdk install gradle $GRADLE_VERSION && \    
    yes | sdk install grails $GRAILS_VERSION && \        
    rm -rf $HOME/.sdkman/archives/* && \
    rm -rf $HOME/.sdkman/tmp/*"

USER root
