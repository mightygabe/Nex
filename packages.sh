#!/bin/bash

printf "\e[1;32mInstalling Essential Packages...\e[0m\n"
sudo apt install -y build-essential cmake cmake-extras meson ninja-build curl wget gettext libnotify-bin libnotify-dev libxkbcommon-dev

# Define the packages for the first question
terminals=("alacritty" "kitty" "konsole" "terminator" "gnome-terminal" "xfce4-terminal")

# Define the packages for the second question
file_managers=("thunar" "nautilus" "dolphin" "ranger" "lf")

# Function to display and select packages from a given array
select_packages() {
    local packages=("$@")
    local selected_packages=()
    local user_input

    echo "Please select the packages to install:"
    for i in "${!packages[@]}"; do
        echo "$((i+1)). ${packages[i]}"
    done
    echo "A. All of the above"

    while true; do
        read -p "Enter your choice (e.g., 1 3 5 or A): " user_input
        if [[ "$user_input" == "A" || "$user_input" == "a" ]]; then
            selected_packages=("${packages[@]}")
            break
        elif [[ "$user_input" =~ ^[0-9\ ]+$ ]]; then
            # Convert user input into an array of indices
            for index in $user_input; do
                if ((index > 0 && index <= ${#packages[@]})); then
                    selected_packages+=("${packages[index-1]}")
                else
                    echo "Invalid input. Please enter valid numbers or 'A' to select all."
                    selected_packages=()
                    break
                fi
            done
            [[ ${#selected_packages[@]} -gt 0 ]] && break
        else
            echo "Invalid input. Please enter valid numbers or 'A' to select all."
        fi
    done

    echo "${selected_packages[@]}"
}

# Question 1: Select packages to install
echo "Question 1:"
selected_terminals=($(select_packages "${terminals[@]}"))

# Question 2: Select packages to install
echo "Question 2:"
selected_file_managers=($(select_packages "${file_managers[@]}"))

# Combine selected packages from both questions
all_selected_packages=("${selected_terminals[@]}" "${selected_file_managers[@]}")

# Install the selected packages
if [ ${#all_selected_packages[@]} -gt 0 ]; then
    echo "Installing selected packages..."
    sudo apt-get update
    sudo apt-get install -y "${all_selected_packages[@]}"
else
    echo "No packages selected for installation."
fi
