#!/usr/bin/env bash
#
# Use: install_ansible.sh [<playbook_path>]
# If not passed, the playbook path is assumed to be /root/playbook.run

main() {
	# Default path for the playbook
	PLAYBOOK_PATH=${1:-/root/playbook.run}

	log "Installing Python and Pip"
	yum install -y python3 python3-pip
	log "Python and Pip installed successfully!"

	for ((i=0; i < 50; i++)); do
		run_playbook_and_exit

		log "File $PLAYBOOK_PATH not found, retrying in 5 seconds..."
		sleep 5
	done

	log "Timeout while trying to install ansible playbook at $PLAYBOOK_PATH"
}

log() {
	msg=$1
	date=$(date -u +'%Y-%m-%dT%H:%M:%S.%3NZ')

	echo "[$date] $msg"
}

run_playbook_and_exit() {
	test -f "$PLAYBOOK_PATH" || return
	test -x "$PLAYBOOK_PATH" || chmod +x "$PLAYBOOK_PATH"

	log "Executing $PLAYBOOK_PATH..."
	"$PLAYBOOK_PATH"; status=$?
	log "Finished! (status code: $status)"
	exit
}

main "$@"
