# The api.sh script contains useful APIs that linforge.sh uses to build the system.

# Check if a system Package is Installed
is_package_installed () {
	dnf list --installed "$1" &> /dev/null
}
# Check if a flatpak is installed.
is_flatpak_installed () {
	flatpak list | grep "$1" &> /dev/null
}
# Check if a fedora copr repo is installed.
is_copr_repo_installed () {
	dnf copr list | grep "$1" &> /dev/null
}

# Check if a service is enabled.
is_service_enabled () {
	systemctl status "$1" | grep "enabled;" &> /dev/null
}

is_flathub_enabled () {
	flatpak remote-list | grep flathub &> /dev/null
}


# Install system packages
install_packages () {
	for pkg in "$@"; do
		if ! is_package_installed "$pkg"; then
			echo "Installing $pkg"
			dnf install "$pkg" -y &> /dev/null
		fi
	done
}

# Remove System Packages
remove_packages () {
	for pkg in "$@"; do
		if is_package_installed "$pkg"; then
			echo "Removing $pkg"
			dnf remove "$pkg" -y &> /dev/null
		fi
	done
}

# Install flatpak applications.
install_flatpak () {
	for pkg in "$@"; do
		if ! is_flatpak_installed "$pkg"; then
			echo "Installing flatpak $pkg."
			flatpak install "$pkg" -y &> /dev/null
		fi
	done
}

# Remove flatpak applications
remove_flatpak () {
	for pkg in "$@"; do
		if is_flatpak_installed "$pkg"; then
			echo "Removing flatpak $pkg."
			flatpak remove "$pkg" -y &> /dev/null
		fi
	done
}

# Add a copr repo
add_copr_repo () {
	for copr in "$@"; do
		if ! is_copr_repo_installed "$copr"; then
			echo "Enabling copr repo $copr."
			dnf copr enable "$copr" -y &> /dev/null
		fi
	done
}

# Enable a set of services.
enable_service () {
	for service in "$@"; do
		if ! is_service_enabled "$service"; then
			echo "Enabling and starting service $service."
			systemctl enable --now "$service" &> /dev/null
		fi
	done
}

disable_service() {
	for service in "$@"; do
		if is_service_enabled "$service"; then
			echo "Disabling and stopping service $service."
			systemctl disable --now "$service" &> /dev/null
		fi
	done
}

disable_gnome_software_autostart () {
	if [ -f /etc/xdg/autostart/org.gnome.Software.desktop ]; then
		echo "Disabling Gnome Software by moving it's autostart file to ~/Documents."
		mv -v /etc/xdg/autostart/org.gnome.Software.desktop /etc/xdg/autostart/org.gnome.Software.desktopdisabled  
	fi
}

set_system_hostname () {
	echo "Setting hostname to $1, will require reboot to take effect."
	echo "$1" > /etc/hostname
}

add_flathub_repo () {
	if ! is_flathub_enabled; then
		echo "Since flathub is not enabled, we will enable it now."
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	fi
}
