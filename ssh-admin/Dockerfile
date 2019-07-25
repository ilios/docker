FROM ilios/php-apache:v3.67.0

MAINTAINER Ilios Project Team <support@iliosproject.org>

RUN apt-get update && \
    apt-get install -y wget openssh-server sudo && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y

# This doesn't get created automatically, don't know why
RUN mkdir /run/sshd

# Remove password based authentication for SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# allow users in the sudo group to do wo without a password
RUN /bin/echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/no-password-group

# Copy and run our user creation script
ARG GITHUB_ACCOUNT_SSH_USERS=''
COPY add-ssh-users.sh /tmp/add-ssh-users.sh
RUN /bin/bash /tmp/add-ssh-users.sh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
