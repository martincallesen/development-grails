FROM martincallesen/ssh-server

ARG JAVA_VERSION="8.0.292.hs-adpt"
ARG GROOVY_VERSION="2.4.5"
ARG GRADLE_VERSION="3.5.1"
ARG GRAILS_VERSION="3.3.14"
ARG LOCALE="da_DK.UTF-8"
ARG LANGUAGE="da_DK:da"
ARG TZ="CET"

USER root
#Setting timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install apt packages
RUN apt update

RUN apt install zip unzip curl git zsh wget locales fontconfig libfreetype6 rsync sudo -y

#Install docker
RUN apt install docker docker-compose sudo -y

#Setting local
RUN sed -i -e 's/# da_DK.UTF-8 UTF-8/da_DK.UTF-8 UTF-8/' /etc/locale.gen

RUN dpkg-reconfigure --frontend=noninteractive locales

RUN update-locale LANG=$LOCALE

ENV LANG $LOCALE
ENV LANGUAGE $LANGUAGE
ENV LC_CTYPE $LOCALE
ENV LC_ALL $LOCALE

#Install oh-my-zsh with plugins
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

RUN sed -i.bak 's/^plugins=(\(.*\)/plugins=(zsh-autosuggestions zsh-syntax-highlighting \1/' ~/.zshrc

#Create directories needed for development of a grails project
RUN mkdir ~/.gradle

RUN mkdir ~/.grails

#Install grails tools
RUN bash -c "export SDKMAN_DIR="/usr/share/sdkman" && \
    curl -s https://get.sdkman.io | bash && \
    source /usr/share/sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION && \
    yes | sdk install groovy $GROOVY_VERSION && \    
    yes | sdk install gradle $GRADLE_VERSION && \    
    yes | sdk install grails $GRAILS_VERSION && \        
    rm -rf /usr/share/sdkman/archives/* && \
    rm -rf /usr/share/sdkman/tmp/*"

# Add oh-my-zsh to /usr/share so all additional users can use it
RUN mv /root/.oh-my-zsh /usr/share && \
mv /usr/share/.oh-my-zsh /usr/share/oh-my-zsh && \
mv /root/.zshrc /usr/share/oh-my-zsh && \
mv /usr/share/oh-my-zsh/.zshrc /usr/share/oh-my-zsh/zshrc && \
sed -i 's|export ZSH="'"$HOME"'/.oh-my-zsh"|export ZSH="\/usr\/share\/oh-my-zsh"|g' /usr/share/oh-my-zsh/zshrc

# Add oh-my-zsh for user
RUN ln /usr/share/oh-my-zsh/zshrc /etc/skel/.zshrc && \
cp /usr/share/oh-my-zsh/zshrc /root/.zshrc

# Add sdkman and oh-my-zsh for user test
RUN cp /usr/share/oh-my-zsh/zshrc /home/ubuntu/.zshrc
