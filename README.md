# project-templates

This project is a core of the code that will be use to automate pipeline creation.
Each pipeline creation project will be a fork of this code. 


### Design idea ###

Each automated pipeline creation project is going to share the same core base.
However, it makes no sense to keep all this projects as a branch 

Create new project pt-${your-project-name} as a fork of a current one.
Set this repo as an upstream repo of a new one and sync:

    # in the fork dir
    git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
    
And next, sync:
    
    # for every branch
    git fetch upstream 
    git checkout master
    git merge upstream/master
