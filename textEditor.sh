#!/bin/bash

TRASH_DIR="./trash"
TEMP_DIR="./temp_c_files"

# Create the trash and temp directory if they don't exist
mkdir -p "$TRASH_DIR" "$TEMP_DIR"

write_text_to_file() {
    echo "Enter the filename to save (e.g., file.txt): "
    read filename

    echo "Enter your text (end with a blank line):"
    text=""
    while IFS= read -r line; do
        if [ "$line" == "" ]; then
            break
        fi
        text+="$line\n"
    done

    echo -e "$text" > "$TEMP_DIR/$filename"

    if [ $? -eq 0 ]; then
        echo "Text successfully saved to $TEMP_DIR/$filename."
    else
        echo "Error: Could not write to file $filename."
    fi
}

compile_and_run_c_code() {
    echo "Enter the filename to save (with .c extension): "
    read filename

    # Ensure the file has a .c extension
    if [[ ! "$filename" =~ \.c$ ]]; then
        echo "Error: The file must have a .c extension."
        return
    fi

    echo "Enter your C code (end with a blank line):"
    text=""
    while IFS= read -r line; do
        if [ "$line" == "" ]; then
            break
        fi
        text+="$line\n"
    done

    echo -e "$text" > "$TEMP_DIR/$filename"

    if [ $? -eq 0 ]; then
        echo "C code successfully saved to $TEMP_DIR/$filename."
    else
        echo "Error: Could not write to file $filename."
        return
    fi

    echo "Compiling $filename..."
    gcc "$TEMP_DIR/$filename" -o "$TEMP_DIR/${filename%.c}"

    if [ $? -ne 0 ]; then
        echo "Compilation failed. Please check your C code for errors."
        return
    fi

    echo "Running the compiled program..."
    "$TEMP_DIR/${filename%.c}"

    if [ $? -ne 0 ]; then
        echo "Runtime error occurred during execution."
    fi
}

read_file() {
    echo "Available files in $TEMP_DIR:"
    ls "$TEMP_DIR"

    echo -n "Enter the filename to read (with extension): "
    read filename

    if [[ ! -f "$TEMP_DIR/$filename" ]]; then
        echo "Error: File $TEMP_DIR/$filename does not exist."
        return
    fi

    echo "Contents of $TEMP_DIR/$filename:"
    cat "$TEMP_DIR/$filename"
}


delete_file() {
    echo "Enter the filename to delete (with extension): "
    read filename

    if [ ! -f "$TEMP_DIR/$filename" ]; then
        echo "Error: File $TEMP_DIR/$filename does not exist."
        return
    fi

    mv "$TEMP_DIR/$filename" "$TRASH_DIR"
    echo "File $filename has been moved to trash."
}

undo_delete() {
    echo "Available files to restore:"
    ls "$TRASH_DIR"
    echo "Enter the filename to restore (with extension): "
    read filename

    if [ ! -f "$TRASH_DIR/$filename" ]; then
        echo "Error: File $filename does not exist in trash."
        return
    fi

    mv "$TRASH_DIR/$filename" "$TEMP_DIR"
    echo "File $filename has been restored."
}

permanently_delete_from_trash() {
    echo "Available files in trash:"
    ls "$TRASH_DIR"
    echo "Enter the filename to permanently delete (with extension): "
    read filename

    if [ ! -f "$TRASH_DIR/$filename" ]; then
        echo "Error: File $filename does not exist in trash."
        return
    fi

    rm "$TRASH_DIR/$filename"
    echo "File $filename has been permanently deleted."
}

view_trash_contents() {
    echo "Contents of trash:"
    ls "$TRASH_DIR"
}

while true; do
    echo -e "\nBasic Text Editor with C Code Execution"
    echo "1. Write Text to File"
    echo "2. Compile and Run C Code"
    echo "3. Read File"
    echo "4. Delete File (Move to Trash)"
    echo "5. Undo Delete (Restore from Trash)"
    echo "6. Permanently Delete from Trash"
    echo "7. View Trash Contents"
    echo "8. Exit"
    echo -n "Enter your choice: "
    read choice

    case $choice in
        1) write_text_to_file ;;
        2) compile_and_run_c_code ;;
        3) read_file ;;
        4) delete_file ;;
        5) undo_delete ;;
        6) permanently_delete_from_trash ;;
        7) view_trash_contents ;;
        8) echo "Exiting the editor."; exit 0 ;;
        *) echo "Invalid choice. Please try again." ;;
    esac
done
