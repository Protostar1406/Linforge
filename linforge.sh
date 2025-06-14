source ./api.sh
source ./packages.conf
echo "Linforge will first request to run a system update, this is not mandatory, but highly recommended to reduce the chances of system breakage, and for your security."
dnf upgrade

add_copr_repo "${copr[@]}"
install_packages "${utils[@]}"
remove_packages "${system_removals[@]}"
install_flatpak "${flatpaks[@]}"
remove_flatpak "${flatpak_removals[@]}"
enable_service "${enable_services[@]}"
