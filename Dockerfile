FROM kalilinux/kali-rolling

#ARG user # TODO: Add user as argument

# Fix Kali fuckup
RUN sed -i "s/http.kali.org/kali.download/g" /etc/apt/sources.list

# Install packages
RUN dpkg --add-architecture i386
RUN apt update
#RUN apt install -y kali-linux-headless # kali-linux-large
RUN apt install -y openssh-server xauth x11-apps libgdk-pixbuf2.0-bin libgtk-3-dev sudo net-tools htop ncdu tree mtr

# Configure sshd (server)
RUN mkdir /var/run/sshd
RUN sed -i "s/^.*PasswordAuthentication.*$/PasswordAuthentication no/" /etc/ssh/sshd_config
RUN sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config
RUN sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config
RUN grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# Add new user
RUN useradd -d /home/user/ -m -p user -s /bin/bash user
RUN echo "user:user" | chpasswd
RUN usermod -aG sudo user

WORKDIR /home/user
USER user

# Set up SSH X11 forwarding for GUI applications
RUN mkdir -p /home/user/.ssh
ADD id_rsa.pub id_rsa.pub
RUN cat id_rsa.pub >> /home/user/.ssh/authorized_keys # Perms: 644
RUN rm id_rsa.pub

# Silence Kali notifications
RUN touch ~/.Xauthority
RUN touch ~/.hushlogin

# Try to avoid this dirty hack. Find a way to start sshd
#CMD ["/usr/sbin/sshd", "-D"]
#ENTRYPOINT ["sh", "-c", "/usr/sbin/sshd", "-D", "&&", "tail", "-f", "/dev/null"]
