--- empty-love2d-project.lua - create an empty love2d project based on the folder at empty-love2d-project in a new folder given by the user
--
-- date: 23/03/2024
-- author: Abhishek Mishra

local lfs = require("lfs")

local TEMPLATE_PROJECT_FOLDER = "empty-love2d-project"

-- get the name of the new project
local new_project_name = arg[1]

-- check if the new project name is given
if new_project_name == nil then
    print("Please provide the name of the new project")
    return
end

-- check if the new project folder already exists
if lfs.attributes(new_project_name) ~= nil then
    print("The folder " .. new_project_name .. " already exists")
    return
end

-- create the new project folder
lfs.mkdir(new_project_name)

-- copy the contents of the empty-love2d-project folder to the new project folder
-- recursively copy all the files and folders
local function copy_files(src, dest)
    for file in lfs.dir(src) do
        if file ~= "." and file ~= ".." then
            local src_file = src .. "/" .. file
            local dest_file = dest .. "/" .. file
            local attr = lfs.attributes(src_file)
            if attr.mode == "directory" then
                lfs.mkdir(dest_file)
                copy_files(src_file, dest_file)
            else
                local src_file = io.open(src_file, "rb")
                if src_file == nil then
                    print("Error opening file " .. src_file)
                    return
                end
                local dest_file = io.open(dest_file, "wb")
                if dest_file == nil then
                    print("Error opening file " .. dest_file)
                    return
                end
                dest_file:write(src_file:read("*a"))
                src_file:close()
                dest_file:close()
            end
        end
    end
end

copy_files(TEMPLATE_PROJECT_FOLDER, new_project_name)