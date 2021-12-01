FROM martincallesen/ssh-server:latest

ARG JAVA_VERSION="8.0.292.hs-adpt"
ARG GROOVY_VERSION="3.0.8"
ARG GRADLE_VERSION="3.5.1"
ARG GRAILS_VERSION="3.3.14"
ARG LOCALE="da_DK.UTF-8"
ARG LANGUAGE="da_DK:da"
ARG TZ="CET"
ARG USER="test"

RUN apt update

RUN apt install zip unzip curl git zsh wget locales fontconfig libfreetype6 rsync sudo -y

#Install docker
RUN apt install docker docker-compose sudo -y

RUN usermod -aG docker $USER

#Setting local
RUN sed -i -e 's/# da_DK.UTF-8 UTF-8/da_DK.UTF-8 UTF-8/' /etc/locale.gen

RUN dpkg-reconfigure --frontend=noninteractive locales

RUN update-locale LANG=$LOCALE

ENV LANG $LOCALE
ENV LANGUAGE $LANGUAGE
ENV LC_CTYPE $LOCALE
ENV LC_ALL $LOCALE

#Setting timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER $USER
  
#Install oh-my-zsh with plugins
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

RUN sed -i.bak 's/^plugins=(\(.*\)/plugins=(zsh-autosuggestions zsh-syntax-highlighting \1/' ~/.zshrc

#Create directories needed for development of a grails project
RUN mkdir ~/.gradle

RUN mkdir ~/.grails

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
