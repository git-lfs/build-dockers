# Git-LFS Dockers #

These dockers are designed specifically for use on github/git-lfs repo. See
the docker directory for more information on using these dockers.

## TL;DR version ##

1. Create the different "docker tags" as git tags

    ./commit_tags.bsh

2. Push the new tags to repo

    git push origin --tags -f

3. Since the current github triggers/docker integration will not catch updated tags

    git config dockerhub.webhook https://registry.hub.docker.com/u/username/repo/triger/trigger-token
    ./trigger.bsh

### Committing tags ###

To make docker tags in the automated build, you have to create a git branch/tag
and map that to a docker tag. While master is the main development branch for this
repo, it did not make sence to branch and update a Dockerfile in different branches.
Instead, the `commit_tags.bsh` script will execute `docker+` and generate the Dockerfiles
for each tag and then commit them. This way you develop on master, and when you are ready
to releast, run `commit_tags.bsh` and then push the tags. Note, you will have to do a 
force push to update the tags.

### Triggering ###

The `trigger.bsh` script supports both quay.io webhooks and dockerhub webhooks
They look something like

    https://registry.hub.docker.com/u/username/repo/triger/trigger-token
    https://token_used:robot_password@quay.io/webhooks/push/trigger/trigger-token

Where trigger tokens look like uuids. For quay, you have to set up an custom git
repository build trigger and set it up with a robot that you manually added the ssh
key to your repo's deploy keys. ONLY then will the "simply" webhook work. Using
github webhook was a far more complicated endeavour.

No arguments will build all triggers by default. On dockerhub this means all 
dockerhub tags that were manually defined will be build. On quay, all git tag 
names locally in the repo will be triggered manually.

Specifying arguments will trigger just those tag names. Note, on dockerhub, you 
can only do this once, and you have to wait until it finished building to trigger
the next. This is why triggering all is preferred.

### Build Docker Environment Variables ###

`export` before calling `commit_tags.bsh`/`build_docker.bsh`. 

`DOCKER_LFS_BUILD_VERSION` - The version of LFS used to bootstrap the (CentOS)
environment. This does not need to be bumped every version. This can be a tag 
or a sha.

## Old way ## 

1. Build the dockers

    ./build_dockers.bsh
        
2. Push the docker to docker hub

    ./push_dockers.bsh

### Building Dockers ###

In order to use the docker **images**, they have to be built so that they are
ready to be used. For OSes like Debian, this is a fairly quick process. 
However CentOS takes considerably longer time, since it has to build/install go, ruby,
or git from source, depending on the version. Fortunately, you can build the 
docker images JUST once, and you won't have to build it again (until the 
`DOCKER_LFS_BUILD_VERSION` changes.) The build script uses a downloaded release
from github of git-lfs to bootstrap the CentOS image and build/install all the 
necessary software.

This means all the compiling, yum/apt-get/custom dependency compiling is done 
once and saved. (This is done in CentOS by using the already existing 
`./rpm/rpm_build.bsh` script to bootstrap the image and saving the image.)

The script that takes care of ALL of these details for you is

    ./build_dockers.bsh

Building the dockers locally can be used to develop the images without haveing
to have them build remotely and pulled down

## Adding additional OSes ##

To add another operating system, simply follow the already existing pattern, 
and all the scripts will pick them up. A new dockerfile should be named to

    ./git-lfs_{OS NAME}_{OS VERSION #}.dockerfile
    
where **{OS NAME}** and **{OS VERSION #}** should not contain underscores (\_).
Any files that needs to be added to the docker image must be in the current 
directory. This is the docker context root that all of the dockers are built in.

The docker image should run a script that builds using the files in /src (but
don't modify them...) and write its repo files to the /repo directory inside 
the docker container. Writing to /repo in the docker will cause the files to 
end up in

    ./repos/{OS NAME}/{OS VERSION #}/
    
Unlike standard Dockerfiles, these support two extra features. The first one is
the command `SOURCE`. Similar to `FROM`, only instead of inheriting the image,
it just includes all the commands from another Dockerfile (Minus `FROM` and 
`MAINTAINER` commands). This is useful to make multiple images that work
off of each other without having to know the container image names, and without 
manually making multiple Dockerfiles have the exact same commands.

The second feature is a variable substitution in the form of `[{ENV_VAR_NAME}]`
These will be replaced with values from calling environment or blanked out if
the environment variable is not defined.
