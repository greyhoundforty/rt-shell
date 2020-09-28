FROM us.icr.io/rtiffany/rt-shell-base:1

ENV USER root

COPY install.sh install.sh

ARG GITHUB_TOKEN
RUN GITHUB_TOKEN=$GITHUB_TOKEN ./install.sh && rm install.sh

# Environment configuration
VOLUME /home/ryan/mnt/config

# User files
VOLUME /home/ryan/mnt/home

COPY .oh-my-zsh/ /home/ryan
COPY .zprofile /home/ryan
COPY .zshrc /home/ryan 
# COPY .motd.txt /root
ENV TERM xterm-256color

WORKDIR "/home/ryan"
ENTRYPOINT [ "zsh", "-l" ]
