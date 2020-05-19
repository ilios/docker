#!/bin/bash
set -m -euf -o pipefail

# Export out ENV out so symfony can read them
/bin/echo 'Dumping ILIOS environmental variables for symfony'
/usr/bin/env | /bin/grep APP_ENV >> /var/www/ilios/.env.local
/usr/bin/env | /bin/grep ILIOS_ >> /var/www/ilios/.env.local
/usr/bin/composer --working-dir=/var/www/ilios dump-env prod

/bin/echo "Entrypoint ssh-admin container"

if [[ $GITHUB_ACCOUNT_SSH_USERS ]]; then
	# keep a copy of the default file seperator
	ORIGINAL_IFS=$IFS

	# Users are sperated with semi-colons
	IFS=';'
	for user in $GITHUB_ACCOUNT_SSH_USERS
	do
			/bin/echo "Creating account for user ${user}"
			SSH_DIR="/home/$user/.ssh"
			/usr/sbin/useradd -ms /bin/bash -G sudo $user
			/bin/mkdir $SSH_DIR
			/usr/bin/wget --quiet -O - "https://github.com/${user}.keys" >> "${SSH_DIR}/authorized_keys"
			/bin/chown -R "${user}:${user}" $SSH_DIR
			/bin/chmod 700 $SSH_DIR
			/bin/chmod 600 "${SSH_DIR}/authorized_keys"
	done

	IFS=$ORIGINAL_IFS
fi

/bin/echo "Starting ssh server"
/usr/sbin/sshd -D &
/bin/echo "Starting frontend-update service..."
/update_ilios_frontend_loop.sh &
/bin/echo "Starting search-index services..."
/update_ilios_search_index_loop.sh &

/bin/echo "Moving sshd process back to foreground to accept SSH connections..."
fg %1
