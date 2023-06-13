# LEMP-stack-docker-compose
WordPress site using the latest WordPress Version. This will be a LEMP (Linux, Nginx, Mysql, PHP) stack running inside Docker containers.
Created a Bash shell script to run the LEMP stack with just one command, and your WordPress site will start running on a local machine or browser.
This bash script will contain the following features-
1. Check if docker and docker-compose is installed on the system. If not present, install the missing packages.
2. The script should be able to create a WordPress site using the latest WordPress Version. Provided a way for the user to provide the site name as a                command-line argument.
3. It must be a LEMP stack running inside containers (Docker) and a docker-compose file is a must.
4. Created a /etc/hosts entry for example.com pointing to localhost. Here we are assuming the user has provided example.com as the site name.
5. Prompt the user to open example.com in a browser if all goes well and the site is up and healthy.
6. Added another subcommand to enable/disable the site (stopping/starting the containers)
7. Added one more subcommand to delete the site (deleting containers and local files).

 <h1> Command for run bash script: </h1>
  
  `chmod +wx <file_name.sh>`
  
  `./<file_name.sh> <sitename.com>`
  
  

Here is some snapshots as a result:
<h1 align="center">
  <picture><img src = "https://github.com/Nidhi-Bharti2407/LEMP-stack-docker-compose/blob/main/Screenshot%20from%202023-06-13%2016-41-59.png" width = 2000px></picture> <br>
 
  <picture><img src = "https://github.com/Nidhi-Bharti2407/LEMP-stack-docker-compose/blob/main/Screenshot%20from%202023-06-13%2016-44-32.png" width = 2000px></picture> <br>
 
  <picture><img src = "https://github.com/Nidhi-Bharti2407/LEMP-stack-docker-compose/blob/main/Screenshot%20from%202023-06-13%2016-44-42.png" width = 2000px></picture> <br>
 
   <picture><img src = "https://github.com/Nidhi-Bharti2407/LEMP-stack-docker-compose/blob/main/Screenshot%20from%202023-06-13%2016-45-34.png" width = 2000px></picture> <br>
 
   <picture><img src = "https://github.com/Nidhi-Bharti2407/LEMP-stack-docker-compose/blob/main/Screenshot%20from%202023-06-13%2017-23-59.png" width = 2000px></picture>
  </h1>

  
