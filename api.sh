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
	systemctl status "$1" | grep "enabled;"
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
			flatpak install "$pkg" &> /dev/null
		fi
	done
}

# Remove flatpak applications
remove_flatpak () {
	for pkg in "$@"; do
		if is_flatpak_installed "$pkg"; then
			echo "Removing flatpak $pkg."
			flatpak remove "$pkg" &> /dev/null
		fi
	done
}

# Add a copr repo
add_copr_repo () {
	for copr in "$@"; do
		if ! is_copr_repo_installed "$copr"; then
			echo "Enabling copr repo $copr."
			dnf copr enable "$copr" &> /dev/null
		fi
	done
}

# Enable a set of services.
enable_service () {
	for service in "$@"; do
		if ! is_service_enabled "$service"; then
			echo "Enabling and starting service $service."
			systemctl enable --now "$service"
		fi
	done
}
