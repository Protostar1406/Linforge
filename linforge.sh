source ./api.sh
source ./packages.conf
if [ $1 = upgrade ]; then
	dnf upgrade
	flatpak update
fi

if [ $1 = switch ]; then
	add_copr_repo "${copr[@]}"
	remove_packages "${system_removals[@]}"
	install_packages "${utils[@]}"
	add_flathub_repo
	remove_fedora_native_flatpak_repo
	install_flatpak "${flatpaks[@]}"
	remove_flatpak "${flatpak_removals[@]}"
	enable_service "${enable_services[@]}"
	disable_service "${disable_services[@]}"
#	disable_gnome_software_autostart
	set_system_hostname "ProtostarWorkstation"
fi
