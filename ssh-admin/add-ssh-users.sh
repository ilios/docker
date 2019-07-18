#!/bin/bash
set -euf -o pipefail

if [[ $GITHUB_ACCOUNT_SSH_USERS ]]; then
	# keep a copy of the default file seperator
	ORIGINAL_IFS=$IFS

	# Users are sperated with semi-colons
	IFS=';'
	for user in $GITHUB_ACCOUNT_SSH_USERS
	do
			SSH_DIR="/home/$user/.ssh"
			/usr/sbin/useradd -ms /bin/bash -G sudo $user
			/bin/mkdir $SSH_DIR
			/usr/bin/wget -O - "https://github.com/${user}.keys" >> "${SSH_DIR}/authorized_keys"
			/bin/chown -R "${user}:${user}" $SSH_DIR
			/bin/chmod 700 $SSH_DIR
			/bin/chmod 600 "${SSH_DIR}/authorized_keys"
	done

	IFS=$ORIGINAL_IFS
fi
