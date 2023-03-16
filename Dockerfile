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

# Set up SSH X11 forwarding for GUI applications
RUN mkdir -p /home/user/.ssh
RUN chmod 700 /home/user/.ssh

ADD id_rsa.pub /tmp/id_rsa.pub

RUN cat /tmp/id_rsa.pub >> /home/user/.ssh/authorized_keys
RUN rm /tmp/id_rsa.pub

RUN chown -R user:user /home/user
#RUN chmod -R a+rx /home/user

USER user

RUN touch ~/.Xauthority
RUN touch ~/.hushlogin
#CMD ["/usr/sbin/sshd", "-D"]
ENTRYPOINT ["sh", "-c", "/usr/sbin/sshd", "-D", "&&", "tail", "-f", "/dev/null"]
