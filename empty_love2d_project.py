import os
import shutil

TEMPLATE_PROJECT_FOLDER = "empty-love2d-project"

# Get the name of the new project
import sys

if len(sys.argv) < 2:
    print("Please provide the name of the new project")
    sys.exit(1)

new_project_name = sys.argv[1]

# Check if the new project folder already exists
if os.path.exists(new_project_name):
    print(
        f"The folder {new_project_name} already exists. Deleting it to proceed."
    )
    try:
        shutil.rmtree(new_project_name)
    except Exception as e:
        print(f"Error deleting existing folder: {e}")
        sys.exit(1)


# Copy the contents of the empty-love2d-project folder to the new project folder
# Recursively copy all the files and folders
def copy_files(src, dest):
    try:
        shutil.copytree(src, dest)
    except Exception as e:
        print(f"Error copying files: {e}")
        sys.exit(1)


copy_files(TEMPLATE_PROJECT_FOLDER, new_project_name)

print(f"{new_project_name} folder created!")
