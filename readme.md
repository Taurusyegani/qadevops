Read me – Puppycompanyblog

Puppycompanyblog is a social media app blog posting app that enables people to connect with one another on the side of the Atlantic… and even on the other side of the world! 

It enables the user to create an account and to be able create posts, with titles and content, and upload the posts on an open-source platform which enables other account holders to view those posts.

In the case of a spelling mistake, or of a mistaken post, the user can delete their posts, but only their posts and not the posts of any others.

Here is a flow chart that models the applications process logic. 

 

Contents:

1)	Github
2)	Azure Vm’s
3)	CI-CD - Jenkins
4)	Docker swarm
5)	Load balancing

Deliverables:
1)	Requirement gathering - readme - what I want to create
2)	Database schema - create a db (sqlite or mysql)
3)	Python app - CRUD functionality
4)	Unit test with pytest
5)	Jenkins installation and usage
6)	Deployment using docker swarm
7)	Integrating pipeline with docker
Github

The first step I embarked upon in the process is to create an account on github, and to publish the project as a public file on github.

I created a repository on github with the same name as my project and opened a terminal and typed in the following commands.
git init

git remote add origin https://github.com/Taurusyegani/qadevops.git (the https to the repo I created)

git branch -M main

git push -u origin main

I then decided to make a change within my IDE and save the change to github.

git init -b main

git add . && git commit -m "initial commit"


git branch -M main

git push -u origin main

in the event that you want to change the remote add destination from the CLI the command is 

git remote set-url origin 

**if a change was made remotely and an error message comes locally then git pull is needed.

 
Azure VM’s

To install and run the project we must first create three virtual machines to host the application and allow for CI CD workflow.

To do this we go to Microsoft azure and create a new resource group, I have entitled this resource group, qaproject.

 

We must then create 3 virtual machines with the following specifications:

1)	Must be within the resource group we have just created (in my case = qa project)
2)	Subscription must be set – (in my case, Azure Pass – Sponsorship)
3)	Ubuntu server 20.04 LTS – Gen2
4)	X64 VM architecture
5)	8Gib memory
6)	SSH public key authentication type – (Username and SSH public key noted down)
7)	HTTP(80),HTTPS(443),SSH(22) ports all enabled

 
 
 
 
 

We have created 
1)	qajenkins
2)	qaworker
3)	qamaster

After the machines have been created – I will then use them by the cloud shell interface offered by Azure.

We must then log into the machines:

To do this I first upload the ssh key pair we downloaded when creating the vm to the cloud shell interface, I then type ls to make sure the key is there.

I then type in chmod 400 and the name of the key, 
Followed by ssh -I the name of they key followed by username@public ip address.

 

We must repeat this for all of our vm’s.

Once we have achieved this we must then begin to install all of the necessary software on our vm’s.























Jenkins

Installing Jenkins on our qajenkins

On the Azure portal, navigate to networking and add port 8080.


#!/bin/bash
	if type apt > /dev/null; then
	    pkg_mgr=apt
	    if [ $(uname -v) == *Debian* ]; then
	      java="default-jre"
	    else
	      java="openjdk-11-jre"
	    fi
	elif type yum /dev/null; then
	    pkg_mgr=yum
	    java="java"
	fi
	echo "updating and installing dependencies"
	sudo ${pkg_mgr} update
	sudo ${pkg_mgr} install -y ${java} wget git > /dev/null
	echo "configuring jenkins user"
	sudo useradd -m -s /bin/bash jenkins
	echo "downloading latest jenkins WAR"
	sudo su - jenkins -c "curl -L https://updates.jenkins-ci.org/latest/jenkins.war --output jenkins.war"
	echo "setting up jenkins service"
	sudo tee /etc/systemd/system/jenkins.service << EOF > /dev/null
	[Unit]
	Description=Jenkins Server
	
	[Service]
	User=jenkins
	WorkingDirectory=/home/jenkins
	ExecStart=/usr/bin/java -jar /home/jenkins/jenkins.war
	
	[Install]
	WantedBy=multi-user.target
	EOF
	sudo systemctl daemon-reload
	sudo systemctl enable jenkins
	sudo systemctl restart jenkins
	sudo su - jenkins << EOF
	until [ -f .jenkins/secrets/initialAdminPassword ]; do
	    sleep 1
	    echo "waiting for initial admin password"
	done
	until [[ -n "\$(cat  .jenkins/secrets/initialAdminPassword)" ]]; do
	    sleep 1
	    echo "waiting for initial admin password"
	done
	echo "initial admin password: \$(cat .jenkins/secrets/initialAdminPassword)"
	EOF


 
This gives us a password, which we enter into Jenkins when prompted.
 

Install all recommended plugins and then install
-Docker
-Purgebuildhistory
-Dockercompose
-Docker

 

Here are the credentials for our Jenkins being hosted on qajenkins.




Installing Docker on our qajenkins

sudo apt-get update
	

	echo "Update Done!"
	

	# sudo apt install apt-transport-https ca-certificates curl software-properties-common
	 
	sudo apt-get install ca-certificates curl gnupg lsb-release -y
		
	echo "Certificates Installed!"
	

	sudo mkdir -p /etc/apt/keyrings
	

	echo "keyrings dir made!"
	

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	

	echo "gpg Imported!"
	

	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	  
	echo "Docker-list Added to Update List!"
	

	sudo apt-get update
	

	echo "Update Done!"
	

	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
	

	echo "Docker Installation Done!"
	

	echo "Post-installation steps..."
	

	sudo groupadd docker
	

	echo "Group added!"
	

	sudo usermod -aG docker $USER
	

	echo "user added to docker group!"
	

	sudo docker run hello-world
	

	echo "Docker is working!"
	

	sudo systemctl enable docker.service
	

	echo "docker.service enabled!"
	

	sudo systemctl enable containerd.service
	

	echo "containerd.service enabled!"
	echo "Finished!"



We then create a folder called Dockerfile by cat > Dockerfile and then add within it the following text:

FROM python:3.8-slim-buster
	WORKDIR /app
	COPY requirements.txt .
	COPY . .
	RUN pip install Flask 
	RUN pip install -r requirements.txt
	EXPOSE 5000
	ENTRYPOINT ["python", "app.py"]


Please note, requirements have had to have been made in the ide by using the commands
Pip install pipreq
Pipreq /applications/Atlanticblog
 (project pathway)

Please note, pip list and pip freeze > requirements.txt also work



We then build a pipeline on Jenkins with the following script


pipeline {
    agent any
    environment {
        dockerImage = ''
        registry = 'taurus01/cicdjenkins'
        registryCredential = 'dockerhub/taurus01'
    }
    stages {
         stage('Git Clone') {
            steps {
                    checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'Github', url: 'https://github.com/Taurusyegani/qadevops.git']]])
        }
    }

        stage('Build Image') {
            steps {
             script {
                    dockerImage = docker.build registry
            }
        }
    }
        stage('Test') {
            steps {
                echo "Testing..."
            }
       
        }
        stage('DockerHub Upload') {
            steps {
             script {
                    docker.withRegistry( '', registryCredential ) {
                    dockerImage.push()
            }
        }
    }
}


     stage('Docker stop container') {
         steps {
            sh 'docker ps -f atlanticblogContainer -q | xargs --no-run-if-empty docker container stop'
            sh 'docker container ls -a -fatlanticblogContainer -q | xargs -r docker container rm'
         }
       }
    
    
    // Running Docker container
    stage('Docker Run') {
     steps{
         script {
            dockerImage.run("-p 5000:5000 --rm --name atlanticblogContainer")
         }
      }
    }
  }
}

In order to integrate docker and Jenkins correctly we had to do so by manage credentials.

 
    
 
Click on global
 
Enter the docker and github username and password

 

And remember the ID – will be added into the credentialsID parts of the pipeline script

 
Taurus01/cicdjenkins is the docker repository we created

Under git clone and checkout, we specified the url to our repository

 

Please note, there was an error with docker.socket that was resolved by entering:

sudo chmod 666 /var/run/docker.sock

and when cleaning failed container builds from inside docker

docker rmi $(docker images -a -q)
and 
docker rmi image name –-force

docker ps -a showed the list of all failed container deployments

and docker logs container id shows the failure within the initialisation of that container

when clearing the port - sudo ufw allow 5000

and the host and port had to be specificed on the app 0.0.0.0 and port = 5000

 

Docker Swarm

Downloading docker on the master and slave machine

	Sudo apt-get update
	
echo "Update Done!"
	

	# sudo apt install apt-transport-https ca-certificates curl software-properties-common
	 
	sudo apt-get install ca-certificates curl gnupg lsb-release -y
		
	echo "Certificates Installed!"
	

	sudo mkdir -p /etc/apt/keyrings
	

	echo "keyrings dir made!"
	

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	

	echo "gpg Imported!"
	

	echo \
	  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	  
	echo "Docker-list Added to Update List!"
	

	sudo apt-get update
	

	echo "Update Done!"
	

	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
	

	echo "Docker Installation Done!"
	

	echo "Post-installation steps..."
	

	sudo groupadd docker
	

	echo "Group added!"
	

	sudo usermod -aG docker $USER
	

	echo "user added to docker group!"
	

	sudo docker run hello-world
	

	echo "Docker is working!"
	

	sudo systemctl enable docker.service
	

	echo "docker.service enabled!"
	

	sudo systemctl enable containerd.service
	

	echo "containerd.service enabled!"
	echo "Finished!"

Docker info 

Then install docker compose 

# make sure jq & curl is installed
	sudo apt update
	sudo apt install -y curl jq
	# set which version to download (latest)
	version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
	# download to /usr/local/bin/docker-compose
	sudo curl -L "https://github.com/docker/compose/releases/download/${version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	# make the file executable
	sudo chmod +x /usr/local/bin/docker-compose
	echo
	echo "Done!"
	echo
	docker-compose --version
	echo

On the manager 

Docker swarm init

It then generates a code

docker swarm join --token SWMTKN-1-3ctdgem9xaac636sj7ji1e64lh14lx9bdxu6wouvk1dbmobl7l-eu568pcvmnal6gmsar6d4khyc 10.3.0.5:2377

which we enter in the worker

creating a service 

docker service create --name python-http-server taurus01/cicdjenkins

docker service update --replicas 10 --publish-add 80:5000  python-http-server

 


 

When we curl the private ip address (with port 80 open), it returns the contents of our base.html file

Docker service ls shows that there are ten replicas published to port 80 outside the container – the service should now be running inside the swarm

 
When I type in the public ip address of the manager node with the port 80 open a second instance of the web app opens 
Here is the application working on the qamaster ip address port 80
 
And here is the application working on qaworker on port 80
 







Now we need to balance the traffic through an ingress mesh

I decided to make a fourth vm called qaload



I installed docker and docker compose using the above script(s)

I then had a problem with permissions 

Server:
ERROR: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/info": dial unix /var/run/docker.sock: connect: permission denied

and so had to run 

sudo chmod 666 /var/run/docker.sock


we then created a file on the load balancing node called qaload.conf

touch qaload.conf and nano qaload.conf

we specified the server that we created as the service earlier (name python-http-server)

and the master and worker nodes which were hosting instances of the container

events{}
http {
    upstream python-http-server {
        server 10.3.0.5:80;
        server 10.3.0.6:80;
    }
    server {
        location / {
            proxy_pass http://python-http-server;
        }
    }
}

Now when we run the following command, we are able to use the qaload as a proxy to host our application


docker run -d -p 80:80 --name python-http-server --mount type=bind,source=$(pwd)/python-http-server.conf,target=/home/azureuser/python-http-server.conf taurus01/cicdjenkins:latest


 

After doing a docker ps we can see that qaload is running an instance of the image being hosted on the swarm container.

