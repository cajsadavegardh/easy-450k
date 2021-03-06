#!/usr/bin/env python3.5
import argparse
import os
import subprocess as sp
import yaml
import shutil

template_extension = ".tmpl"
scripts_dir_name = "Scripts"
directory_template_line = '[directories]'

# define colors for fancy printing
blue_col = '\033[94m'
green_col = '\033[92m'
fail_col = '\033[91m'
endc_col = '\033[0m'
bold_col = '\033[1m'
underline_col = '\033[4m'


def creating_directory_message(directory_name):
    return green_col + "  [Creating project directory]: " + blue_col + directory_name + endc_col


def creating_file_message(file_name):
    return green_col + "  [Creating file]: " + blue_col + file_name + endc_col


def section_message(section_name):
    return fail_col + section_name + endc_col

# setup command line arguments
parser = argparse.ArgumentParser(description='Initiate a new analysis project')
parser.add_argument('project_name', type=str)
parser.add_argument('template_name', nargs='?', type=str, default='standard')
args = parser.parse_args()
project_name = args.project_name
template_name = args.template_name

# setup dirs where the files are saved to and loaded from
program_dir = os.path.dirname(os.path.abspath(__file__))
working_dir = os.getcwd()
project_dir = os.path.join(working_dir, args.project_name)
template_path = os.path.join(program_dir, "templates", template_name) + template_extension

# test if the path working_dir/project_name already exists (if it's a dir or a file - doesn't matter)
if os.path.isdir(project_dir):
    print("Cannot create a directory " + project_dir + "! Exiting...")
    exit(1)

# test if template file exists
if not os.path.exists(template_path) or os.path.isdir(template_path):
    print("Template file " + template_path + " does not exist or is a directory! Please specify correct template name.")
    exit(1)

# now create target dir
os.mkdir(project_dir)

print()
print(section_message("Creating project!"))
print()
print(section_message("Forming directories:"))


# go through all the files and create a subdir for each of them
yaml_template = yaml.load(open(template_path))
for directory in yaml_template['directories']:
    template_dir_path = os.path.join(project_dir, directory)
    print(creating_directory_message(os.path.join(project_name, directory)))
    os.mkdir(template_dir_path)

print()
print(section_message("Creating files:"))

for file_dict in yaml_template['files']:
    source = os.path.join(program_dir, file_dict['from'])
    destination = os.path.join(project_dir, file_dict['to'])
    print(creating_file_message(destination))
    shutil.copyfile(source, destination)

print()

# initialize git repo if scripts dir exists
scripts_dir_path = os.path.join(project_dir, scripts_dir_name)
if os.path.isdir(scripts_dir_path):
    os.chdir(scripts_dir_path)
    sp.call(["git", "init"])

print()



