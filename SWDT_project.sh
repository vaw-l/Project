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
   # Prompt the user to enter the path of the CV file
    read -p "Enter CV file path (.txt): " file
    echo "You entered: $file"  # Display the entered file path for confirmation

    # Check if the specified file exists
    if [ -f "$file" ]; then
        # Copy the CV file to the cv_storage directory
        cp "$file" cv_storage/
        echo "CV uploaded successfully."  # Confirm successful upload
    else
        # Inform the user if the file was not found
        echo "File not found. Please check the path and try again."
    fi
}

# Analyzes and categorizes CVs based on keywords
analyze_and_sort() {
# Read each line from keywords.txt
    while IFS=: read -r category words; do
        for word in $words; do
            # Check if the word is in the content (ignore case)
            if echo "$content" | grep -iqw "$word"; then
                cp "$cv" "categorized/$category/"  # Copy file to category folder
                echo "$(basename "$cv") -> $category"  # Show file and category
                matched=1
                break
            fi
        done
        [ $matched -eq 1 ] && break  # Stop if matched
    done < keywords.txt  # Read keywords file

    [ $matched -eq 0 ] && echo "$(basename "$cv") not categorized."  # No category found
}

# Display the number of CVs in each category, Jenan Bajawi ID: 445000496
show_cv_counts() {

    # Loop through each subfolder inside the 'categorized' directory
    for folder in categorized/*; do
        # Count how many files (CVs) are inside the current folder
        count=$(ls "$folder" 2>/dev/null | wc -l)

   # Print the folder name (category) and the number of CVs it contains
        echo "$(basename "$folder"): $count"
    done
}


# Searches all CVs for a specific word
search_keyword() {
# Prompt the user to enter a word to search for
    read -p "Enter word to search: " word

# Use grep to search for the word in all files inside 'categorized/' folders
    # -r: recursive search
    # -i: ignore case
    # -l: only show filenames
    grep -ril "$word" categorized/ || echo "No matches found."

}


# View the content of a specific CV file
view_cv_content() {
# Ask the user to enter the CV file name
    read -p "Enter CV file name (e.g. cv_fileName.txt): " name

    # Search for the file inside categorized folders
    file=$(find categorized/ -type f -name "$name" 2>/dev/null)

    # If the file is found
    if [ -n "$file" ]; then
        echo "=== Content of $name ==="
        cat "$file"  # Display the content of the file
    else
        echo "CV not found."  # Show a message if the file doesn't exist
    fi
} 
# Shows available options, Salam Alghamdi ID: 445003110
show_menu() {
  echo "========== CV Management System =========="
    echo "1. Upload CV"
    echo "2. Analyze and Sort CVs"
    echo "3. Show CV Counts per Category"
    echo "4. Search for a Keyword in CVs"
    echo "5. View Specific CV Content"
    echo "6. Exit"
    echo "=========================================="

}

# Controls the overall flow
main() {
    setup_environment          # Ensure necessary folders and files exist
    login_or_signup            # Handle user login or signup

    while true; do             # Infinite loop until user chooses to exit
        show_menu              # Display the menu options
        read -p "Choose an option [1-6]: " choice

        case $choice in
            1)
                upload_cv      # Call function to upload a CV
                ;;
            2)
                analyze_and_sort  # Analyze CVs and move them to category folders
                ;;
            3)
                show_cv_counts    # Display how many CVs are in each category
                ;;
            4)
                search_keyword    # Search for a keyword across all categorized CVs
                ;;
            5)
                view_cv_content   # Show the contents of a specific CV
                ;;
            6)
                echo "Goodbye!"   # Exit the script
                exit 0
                ;;
            *)
                echo "Invalid option. Please choose between 1 and 6."
                ;;
        esac
        echo                    # Print an empty line for spacing
    done
}

# Run the main function to start the program
main
