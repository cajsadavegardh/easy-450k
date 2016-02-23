#!/usr/bin/env python3.5
import argparse

parser = argparse.ArgumentParser(description='Initiate a new analysis project')
parser.add_argument('project_name', type=str)
parser.add_argument('template_name', nargs='?', type=str, default='standard')
args = parser.parse_args()

