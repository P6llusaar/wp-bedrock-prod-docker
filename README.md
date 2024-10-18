This readme isn't gonna be very detailed for now. Just writing everything down as quickly as I can.

Based on official wordpress docker image. Modified to add support to bedrock.
Configured to get your bedrock build directly from git.
Includes wp-cli.
Has 2 parallel installations to enable you to enable blue-green deployment (and therefore you get zero downtime updates).
There's a script for taking backups.

## Instructions
1. Copy the .env.template into .env and define the following values
    * GIT_URL - url you can use to pull the latest build of your bedrock project using ssh
    * DB_PASSWORD - generate a strong password here and add it in quotes. NB! I've had trouble with special characters here, so it might be a good idea to avoid them and just make the password somewhat long.
    * GREEN_PORT & BLUE_PORT - separate ports for both environments so you can switch between them in your load balancer (if you only need one comment out that and the matching part in docker-compose.yml)
    * WP_HOME - URL you want to be able to access your site from
1. Run gen_key.sh in the .ssh folder, it'll generate the ssh key pair you need to use to pull your bedrock project from git. 
1. Copy everything from ssh_key.pub and add it as deploy key to your git host.
1. (optional) if you use anything other than github or gitlab, you need to add them to the known_hosts file as well.
1. cd to the root folder of the project again and run `docker-compose up -d --build`

That's it your environment should be up and running now.

## How to use blue green deployment
1. Map your load balancer to either one of the environments
1. Make sure load balancer isn't sending any traffic towards one of the container (we'll call it the inactive container)
1. Stop the inactive container `docker-compose stop bedrock-[green/blue]`
1. Rebuild the inactive container and put it up `docker-compose up --build -d bedrock-[green/blue]` or if you want to build a different commit from git `docker-compose up --build -d --build-arg git_url="your_git_url" bedrock-[green/blue]`
1. Switch the load balancer to the updated container

I'm planning to create a script to automate the whole process.

## Taking backups
Just run backup.sh in "tools" folder. Copy the generated zip file somewhere safe. It contains the db dump and uploads folder.
