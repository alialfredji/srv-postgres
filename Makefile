
info:
	[ -d /docker-data ] || sudo mkdir /docker-data
	humble utils fs-info

status:
	humble utils fs-status

mount-disk:
	humble stop postgres
	humble rm -f postgres
	humble utils fs-mount

unmount-disk:
	humble stop postgres
	humble rm -f postgres
	humble utils fs-unmount

resize-disk:
	sudo xfs_growfs -d /docker-data

stop-pg:
	humble stop postgres
	humble rm -f postgres

run-pg:
	humble stop postgres
	humble rm -f postgres
	humble up -d postgres
	humble logs -f
