"""
generate_site.py: Generates a plain HTML website for the explorations.

date: 26/2/2024
author: Abhishek Mishra
"""

import shutil
import os
import json

# Output folder
output_folder = "www"

# Project description file
project_description_file = "_prj.json"

# Clean the output folder if it exists
if os.path.exists(output_folder):
    shutil.rmtree(output_folder)

# Create the output folder
os.makedirs(output_folder)

# Get a list of all sub-folders, which don't start with . (hidden folders)
folders = [
    f for f in os.listdir(".") if os.path.isdir(f) and not f.startswith(".")
]

# Iterate over every project folder
for prj_folder in folders:
    # declare the project description
    prj_info = None

    # check if the folder contains the project description file
    if not os.path.exists(prj_folder + "/" + project_description_file):
        print(
            f"Project {prj_folder} does not contain {project_description_file}"
        )
        continue

    # Read the project description file as a JSON
    with open(prj_folder + "/" + project_description_file, "r") as f:
        prj_info = json.load(f)

    # If the project description file is empty, skip the project
    if prj_info is None:
        print(f"Project {prj_folder} description is empty")
        continue

    # Create a folder under output_folder fore each sub-folder
    os.makedirs(output_folder + "/" + prj_folder)

    # Write an index.html file in each folder
    with open(output_folder + "/" + prj_folder + "/index.html", "w") as f:
        f.write(
            f"""<!DOCTYPE html>
<html>
<head>
    <title>{prj_info["name"]}</title>
</head>
<body>
    <h1>{prj_info["name"]}</h1>
    <p>{prj_info["description"]}</p>
    <p>{prj_info["code"]}</p>
    <img src="{prj_info["screenshot"]}">
    <video controls>
        <source src="{prj_info["demo"]}" type="video/mp4">
        Your browser does not support the video tag.
    </video>
</body>
</html>
"""
        )

# Write the index.html file to the root of the output folder
with open(output_folder + "/index.html", "w") as f:
    f.write(
        """<!DOCTYPE html>
<html>
<head>
    <title>Explorations</title>
    </head>
    <body>
        <h1>Explorations is Under Construction</h1>
    </body>
</html>
"""
    )
