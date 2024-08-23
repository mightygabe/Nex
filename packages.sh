#!/bin/bash

# Function to display and handle package selection
select_packages() {
    local category="$1"
    shift
    local packages=("$@")
    local selected=()
    local selection

    echo "Choose $category to install (space-separated list, e.g., 1 3 5):"
    for i in "${!packages[@]}"; do
        echo "$((i+1)). ${packages[i]}"
    done
    read -rp "Selection: " selection

    for index in $selection; do
        selected+=("${packages[index-1]}")
    done

    echo "${selected[@]}"
}

# Function to install selected packages
install_selected_packages() {
    local packages=("$@")
    if [ ${#packages[@]} -gt 0 ]; then
        echo "Installing selected packages: ${packages[*]}"
        sudo apt-get install -y "${packages[@]}"
    else
        echo "No packages selected for installation."
    fi
}

# Define the package groups
declare -A package_groups=(
    ["File Managers"]="thunar pcmanfm krusader nautilus nemo dolphin ranger nnn lf"
    ["Graphics"]="gimp flameshot eog sxiv qimgv inkscape scrot"
    ["Terminals"]="alacritty gnome-terminal kitty konsole terminator xfce4-terminal"
    ["Text Editors"]="geany kate gedit l3afpad mousepad pluma"
    ["Multimedia"]="mpv vlc audacity kdenlive obs-studio rhythmbox ncmpcpp mkvtoolnix-gui"
    ["Utilities"]="gparted gnome-disk-utility neofetch nitrogen numlockx galculator cpu-x dnsutils whois curl tree btop htop bat brightnessctl redshift"
)

# Array to collect all selected packages
all_selected_packages=()

# Main loop to handle each category
for category in "${!package_groups[@]}"; do
    # Convert the space-separated list to an array
    IFS=' ' read -r -a packages <<< "${package_groups[$category]}"
    # Call the select_packages function and collect the result
    selected=$(select_packages "$category" "${packages[@]}")
    all_selected_packages+=($selected)
done

# Install all selected packages
install_selected_packages "${all_selected_packages[@]}"
