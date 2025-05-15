#!/bin/bash

# Creates necessary folders and files when the script starts,   Linda Alzahrani ID: 445004868
setup_environment() {
 # Create main storage folder and subfolders for each category
    mkdir -p cv_storage categorized/{programming,design,management,data,marketing}
    
    # Create essential text files for storing data
    touch logins.txt keywords.txt 
}

# Handles both new users and returning users
login_or_signup() {
# Ask for username
    read -p "Enter your username: " username

    # Check if user exists
    if grep -q "^$username:" logins.txt; then
        # Existing user - verify password
        read -sp "Enter your password: " password
        echo
        saved_pass=$(grep "^$username:" logins.txt | cut -d':' -f2)
        if [ "$password" == "$saved_pass" ]; then
            echo "Login successful."
        else
            echo "Wrong password."
            exit 1
        fi
    else
        # New user - create account
        read -sp "New user. Create a password: " password
        echo
        echo "$username:$password" >> logins.txt
        echo "Account created!"
    fi
}

# Manages CV file uploads,  Raghad Alzahrani ID: 445000460
upload_cv() {

}

# Analyzes and categorizes CVs based on keywords
analyze_and_sort() {

}

# Shows how many CVs are in each category, Jenan Bajawi ID: 445000496
show_cv_counts() {

}

# Searches all CVs for a specific word
search_keyword() {

}

# Displays the contents of stored CV files for review
view_cv_content() {

} 

# Shows available options, Salam Alghamdi ID: 445003110
show_menu() {

}

# Controls the overall flow
main() {

}
