source ./api.sh
source ./packages.conf
if [ $1 = upgrade ]; then
	dnf upgrade
	flatpak update
fi

if [ $1 = switch ]; then
	add_copr_repo "${copr[@]}"
	install_packages "${utils[@]}"
	remove_packages "${system_removals[@]}"
	install_flatpak "${flatpaks[@]}"
	remove_flatpak "${flatpak_removals[@]}"
	enable_service "${enable_services[@]}"
	disable_service "${disable_services[@]}"
fi
