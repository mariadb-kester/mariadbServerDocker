# MariaDB Enterprise Server Docker Container

[![License](https://img.shields.io/badge/mit-blue.svg)](https://opensource.org/licenses/mit)
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/mariadb-kester/mariadbServerDocker/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/mariadb-kester/mariadbServerDocker/tree/main)
![GitHub stars](https://img.shields.io/github/stars/mariadb-kester/mariadbServerDocker?style=social)
![GitHub forks](https://img.shields.io/github/forks/mariadb-kester/mariadbServerDocker?style=social)


This container is designed to install MariaDB Enterprise Server.

**MariaDB Server is an Enterprise product and must have a license**

The problem with a lot of Docker Database containers is that they just deliver the bare minimum , they do not 
provide management, health monitoring, failover, replication or Galera. Hopefully all these problems are solved 
within this image.

----

## To Use

### Terms of use

**Nothing in this demonstration is designed to be used in production and this is not supplied, supported or endorsed by
MariaDB.**

### CircleCI

This repository is designed to use [CircleCI](https://circleci.com) to build the application.
You are required to have some Environment Variables set in order for this to work. You set these within the project
settings in CircleCI.

    MARIADB_SERVER_VERSION
    MARIADB_TOKEN

These variables are used to set the version of MariaDB Enterprise Server you would like to use, and to set your 
[Enterprise 
Customer 
Download Token](https://customers.mariadb.com/downloads/token/?_ga=2.26935487.388521418.1665738866-1398472177.1665738866).

### DigitalOcean Private Repo

As this contains your Enterprise License Key, you must push to a Private Repo. I have chosen to use [DigitalOcean](https://m.do.co/c/902b9dbb0402) for this.

If you wish to use your own repository you will need to amend the MakeFile script, otherwise please set the
Environment Variables in CircleCI for your project.

    DO_REPO
    DO_ACCESS_TOKEN

Setting your DigitalOcean Access Token and Repository Name will allow the built Dodcker Image to be pushed.

### Security

When building the docker container a Trivy Scan is completed on the image. Overtime this might start to fail and the
base image might require updating.

The completion of this tool does not guarantee the security of this container.

### Contributing to *mariadbServerDocker*
<!--- If your README is long or you have some specific process or steps you want contributors to follow, consider creating a separate CONTRIBUTING.md file--->
To contribute to the *mariadbServerDocker* repository, follow these steps:

1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin my-helm-repo/<location>`
5. Create the pull request.

Alternatively see the GitHub documentation on [creating a pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).

### Contact

If you want to contact me you can reach me at kesterriley@hotmail.com.

### License
<!--- If you're not sure which open license to use see https://choosealicense.com/--->

This project uses the following license: [MIT](https://github.com/mariadb-kester/mariadbServerDocker/blob/master/LICENSE).

### Credit 

The project has some similarities that were based on and inspired by:
https://github.com/colinmollenhour/mariadb-galera-swarm

Who in turn had forked it from other sources.

### Disclaimer

Whilst, I might currently work for MariaDB, this work was originally created before my employment by MariaDB and any 
development to these scripts is done strictly in my own time. It is therefore not endorsed, supported by or 
recommend by MariaDB. 