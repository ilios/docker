FROM ilios/php-apache:v3

MAINTAINER Ilios Project Team <support@iliosproject.org>

# semi-colon seperates list of github users that can SSH in
ENV GITHUB_ACCOUNT_SSH_USERS=''

RUN apt-get update && \
    apt-get install -y wget openssh-server sudo netcat mysql-client && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y

# This doesn't get created automatically, don't know why
RUN mkdir /run/sshd

# Remove password based authentication for SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Pass environmental variables to SSH sessions
RUN sed -i 's/#PermitUserEnvironment no/PermitUserEnvironment yes/' /etc/ssh/sshd_config

# allow users in the sudo group to do wo without a password
RUN /bin/echo "%sudo ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/no-password-group

COPY entrypoint.sh /entrypoint.sh

EXPOSE 22
ENTRYPOINT /entrypoint.sh

HEALTHCHECK CMD nc -vz 127.0.0.1 22 || exit 1
