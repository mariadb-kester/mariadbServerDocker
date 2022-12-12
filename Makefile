#------------------------------------------------------------------
# Project build information
#------------------------------------------------------------------

VERSION=${CIRCLE_SHA1}
IMAGE=mariadb-es:latest
BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
# Load Secrets from CircleCI and pass in to build script as a variable to be set within the container

#------------------------------------------------------------------
# CI targets
#------------------------------------------------------------------

build:
	docker build --build-arg BUILD_DATE="${BUILD_DATE}" \
							 --build-arg VCS_REF="1" \
							 --build-arg VERSION="${VERSION}" \
                             --build-arg MARIADB_SERVER_VERSION="${MARIADB_SERVER_VERSION}" \
                             --build-arg MARIADB_TOKEN="${MARIADB_TOKEN}" \
							 -t ${IMAGE} .

push-to-digitalocean:
	doctl registry login
	docker tag ${IMAGE} ${DO_REPO}/${IMAGE}
	docker push ${DO_REPO}/${IMAGE}

install-doctl-linux:
	wget https://github.com/digitalocean/doctl/releases/download/v1.54.0/doctl-1.54.0-linux-amd64.tar.gz
	tar xf doctl-1.54.0-linux-amd64.tar.gz
	mv doctl /usr/local/bin
	doctl auth init -t ${DO_ACCESS_TOKEN}

install-docker:
	apk add docker

local-build:
	docker build --build-arg BUILD_DATE="${BUILD_DATE}" \
							 --build-arg VCS_REF=`git rev-parse --short HEAD` \
							 --build-arg VERSION=${VERSION} \
							 -t server:latest .

#scan: build
scan:
	export TRIVY_TIMEOUT_SEC=360s
	trivy image ${IMAGE}
