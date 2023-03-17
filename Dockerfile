FROM kalilinux/kali-rolling

#ARG username # TODO: Add username as argument
#ARG password # TODO: Add password as argument

# Fix Kali package fetching
RUN sed -i "s/http.kali.org/kali.download/g" /etc/apt/sources.list

# Install packages
RUN dpkg --add-architecture i386
RUN apt update
RUN apt-mark hold console-setup # Broken package
RUN apt install -y kali-linux-headless
RUN apt install -y libgdk-pixbuf2.0-bin libgtk-3-dev sudo net-tools htop ncdu tree mtr bloodhound

# Add new user
RUN useradd -d /home/user/ -m -p user -s /bin/bash user
RUN echo "user:user" | chpasswd
RUN usermod -aG sudo user
WORKDIR /home/user
USER user

# Silence Kali notifications
RUN touch ~/.Xauthority
RUN touch ~/.hushlogin
