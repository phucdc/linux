#!/usr/bin/env python3
import os

'''
Tested on Sublime Text build 4152
'''

def replace_hex_string_in_file(file_path, old_hex_string, new_hex_string):
    try:
        with open(file_path, 'rb') as file:
            file_content = file.read()

        old_bytes = bytes.fromhex(old_hex_string)
        new_bytes = bytes.fromhex(new_hex_string)

        modified_content = file_content.replace(old_bytes, new_bytes)

        with open(file_path, 'wb') as file:
            file.write(modified_content)

        print(f"Hex string '{old_hex_string}' replaced with '{new_hex_string}' in {file_path}")
    except FileNotFoundError:
        print(f"File '{file_path}' not found.")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

# must run as root
if os.geteuid() != 0:
    print('Must run as root!')
    exit(1)

file_path = '/opt/sublime_text/sublime_text' # replace this to /path/of/sublime_text binary: `find / -type f -name sublime_text 2>/dev/null`
old_hex_string = '807805000f94c1'  
new_hex_string = 'c64005014885c9' 

replace_hex_string_in_file(file_path, old_hex_string, new_hex_string)

print('Successfully cracked! Open Sublime Text and enjoy!')
