#! /usr/bin/env bash
HOME_DIR=./docker_ros_ws
# # HOME_DIR=/home/alston/ros/sdc_docker_spring2026/docker_ros_ws
# docker build -t ncsu_sdc:s26 .
# docker run --rm -v /tmp/.X11-unix:/tmp/.X11-unix -v ${HOME_DIR}:/home/ubuntu/ros_ws -e DISPLAY -it ncsu_sdc:s26

docker run --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ${HOME_DIR}:/home/ubuntu/ros_ws \
    -e DISPLAY \
    -e XDG_RUNTIME_DIR=/tmp/runtime-ubuntu \
    -e LIBGL_ALWAYS_SOFTWARE=1 \
    -it ncsu_sdc:s26
