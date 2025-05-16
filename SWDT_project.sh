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
 for cv in cv_storage/*; do
        content=$(cat "$cv")  # Read the content of the CV
        matched=0  # Initialize a flag to track if a match is found

        # Loop over each line in keywords.txt, where each line is in the format "category:keyword1 keyword2"
        while IFS=: read -r category words; do
            # Split the keywords into individual words
            for word in $words; do
                # Check if the content of the CV contains the keyword (case-insensitive)
                if echo "$content" | grep -iq "$word"; then
                    # Move the CV to the corresponding category folder
                    cp "$cv" "categorized/$category/"
                    echo "$(basename "$cv") -> $category"  # Print the categorization result
                    matched=1  # Set the flag indicating a match was found
                    break  # Exit the keyword loop since a match was found
                fi
            done
            [ $matched -eq 1 ] && break  # Exit the category loop if a match was found
        done
        
        # If no match was found, print a message indicating the CV was not categorized
        [ $matched -eq 0 ] && echo "$(basename "$cv") not categorized."
    done
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

}

# Controls the overall flow
main() {

}
