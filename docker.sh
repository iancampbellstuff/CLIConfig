#!/bin/bash

IMAGE_NAME=dockerpoc
MACHINE_PORT=9000
APP_PORT=8080

function IMAGE_EXISTS {
	if [[ "$(docker inspect --type=image $1)" != [] ]]; then
		return 1
	else
		return 0
	fi
}
function CONTAINER_EXISTS {
	if [[ "$(docker inspect --type=container $1)" != [] ]]; then
		return 1
	else
		return 0
	fi
}
function NETWORK_EXISTS {
	if [[ "$(docker inspect --type=network $1)" != [] ]]; then
		return 1
	else
		return 0
	fi
}

###################################################################################################

function HELP {
	echo -e "
Simplify Docker commands for this application. Usage:

./docker.sh init
			Create the image.
	-t TAG
			Set the image tag.

./docker.sh start
			Create and start a container.
	-p PORT
			Set the container access port (default port is $MACHINE_PORT).
	-t TAG
			Set the image tag.
	-k CONTAINER
			Set the container link.
	-n NETWORK
			Set the container network.
	-l
			Restrict container access to localhost only.

./docker.sh stop
			Stop the running container.
	-n NAME
			Stop the container by name (required).

./docker.sh restart
			Restart the stopped container.
	-n NAME
			Restart the container by name (required).

./docker.sh logs
			Print startup log output.
	-n NAME
			Reference the container by name (required).
	-f
			Continuously print log output.
	-t
			Show timestamps on log output.

./docker.sh rm
			Remove the image and container.
	-n NAME
			Remove the container by name (required).
	-t
			Remove the image by tag.
	-f
			Force remove the running container.
./docker.sh info
			Print Docker information relevant to this application.
	-t TAG
			Filter by tag.
	-n NETWORK
			Filter by network.
./docker.sh help
			Print this help information.
"
}
function INIT {
	TAG=""

	while getopts "t:" flag; do
		case "${flag}" in
			t) TAG=":${OPTARG}" ;;
			*) HELP && exit 1 ;;
		esac
	done

	if IMAGE_EXISTS $IMAGE_NAME$TAG == 0; then
		# Build image from Dockerfile, if it does not exist
		docker build \
			-t $IMAGE_NAME$TAG \
			--build-arg port=$APP_PORT \
			.
	fi
}
function START {
	TAG=""
	LOCALHOST=""
	LINK_ARGS=""
	NETWORK_ARGS=""

	while getopts "p:t:k:n:l" flag; do
		case "${flag}" in
			p) MACHINE_PORT="${OPTARG}" ;;
			t) TAG=":${OPTARG}" ;;
			k) LINK_ARGS="--link ${OPTARG}" && if CONTAINER_EXISTS ${OPTARG} == 0; then exit 1; fi ;;
			n) NETWORK_ARGS="--net=${OPTARG}" && if NETWORK_EXISTS ${OPTARG} == 0; then exit 1; fi ;;
			l) LOCALHOST="127.0.0.1:" ;;
			*) HELP && exit 1 ;;
		esac
	done

	# Start container from image
	docker run $LINK_ARGS $NETWORK_ARGS \
		-p $LOCALHOST$MACHINE_PORT:$APP_PORT \
		--label $IMAGE_NAME$TAG \
		-d $IMAGE_NAME$TAG
}
function STOP {
	NAME=""

	while getopts "n:" flag; do
		case "${flag}" in
			n) NAME="${OPTARG}" ;;
			*) HELP && exit 1 ;;
		esac
	done

	# Stop the running container
	docker stop $NAME
}
function RESTART {
	NAME=""

	while getopts "n:" flag; do
		case "${flag}" in
			n) NAME="${OPTARG}" ;;
			*) HELP && exit 1 ;;
		esac
	done

	# Restart the container
	docker restart $NAME
}
function LOGS {
	NAME=""
	FOLLOW_ARGS=""
	TIMESTAMP_ARGS=""

	while getopts "n:ft" flag; do
		case "${flag}" in
			n) NAME="${OPTARG}" ;;
			f) FOLLOW_ARGS="--follow" ;;
			t) TIMESTAMP_ARGS="--timestamps" ;;
			*) HELP && exit 1 ;;
		esac
	done

	echo ""
	docker logs $NAME $FOLLOW_ARGS $TIMESTAMP_ARGS \
		--details
}
function RM {
	NAME=""
	TAG=""
	FORCE_ARGS=""

	while getopts "n:t:f" flag; do
		case "${flag}" in
			n) NAME="${OPTARG}" ;;
			t) TAG=":${OPTARG}" ;;
			f) FORCE_ARGS="-f" ;;
			*) HELP && exit 1 ;;
		esac
	done

	# Remove container
	docker container rm $NAME $FORCE_ARGS
	# Remove image
	docker rmi $IMAGE_NAME$TAG
}
function INFO {
	TAG_ARGS=""
	NETWORK_ARGS=""

	while getopts "t:n:" flag; do
		case "${flag}" in
			t) TAG_ARGS="ancestor=$IMAGE_NAME:${OPTARG}" && if IMAGE_EXISTS $IMAGE_NAME:${OPTARG} == 0; then exit 1; fi ;;
			n) NETWORK_ARGS="network=${OPTARG}" && if NETWORK_EXISTS ${OPTARG} == 0; then exit 1; fi ;;
			*) HELP && exit 1 ;;
		esac
	done

	echo -e "
$(docker images -f reference=$IMAGE_NAME)
"
	if [[ $TAG_ARGS == "" && $NETWORK_ARGS == "" ]]; then
		echo -e "
$(docker ps -a | grep $IMAGE_NAME)
"
	else
		echo -e "
$(docker ps -a -f $TAG_ARGS $NETWORK_ARGS)
"
	fi
}

###################################################################################################

ARGS=$*
FLAGS=${ARGS:${#1}}

if [[ $1 == "init" ]]; then
	INIT $FLAGS
elif [[ $1 == "start" ]]; then
	START $FLAGS
elif [[ $1 == "stop" ]]; then
	STOP $FLAGS
elif [[ $1 == "restart" ]]; then
	RESTART $FLAGS
elif [[ $1 == "logs" ]]; then
	LOGS $FLAGS
elif [[ $1 == "rm" ]]; then
	RM $FLAGS
elif [[ $1 == "info" ]]; then
	INFO $FLAGS
elif [[ $1 == "help" ]] || [[ $# -eq 0 ]]; then
	HELP
else
	echo -e "Unknown option $1!"
fi
