import os
import shutil

TEMPLATE_PROJECT_FOLDER = "lit-empty-love2d-project"


def copy_files(src, dest):
    for item in os.listdir(src):
        if item not in [".", ".."]:
            src_path = os.path.join(src, item)
            dest_path = os.path.join(dest, item)
            if os.path.isdir(src_path):
                os.mkdir(dest_path)
                copy_files(src_path, dest_path)
            else:
                with open(src_path, "rb") as src_file:
                    with open(dest_path, "wb") as dest_file:
                        dest_file.write(src_file.read())


def main():
    # Get the name of the new project
    if len(os.sys.argv) < 2:
        print("Please provide the name of the new project")
        return

    new_project_name = os.sys.argv[1]

    # Check if the new project folder already exists
    if os.path.exists(new_project_name):
        print(f"The folder {new_project_name} already exists")
        return

    # Create the new project folder
    os.mkdir(new_project_name)

    # Copy the contents of the template project folder to the new project folder
    copy_files(TEMPLATE_PROJECT_FOLDER, new_project_name)

    print(f"{new_project_name} folder created!")


if __name__ == "__main__":
    main()
