# use existing jazzy image as base
FROM osrf/ros:jazzy-desktop-full

# if key are expired, do the command below and retry
#docker pull osrf/ros:jazzy-desktop-full





ENV DEBIAN_FRONTEND=noninteractive

# apt-get calls
RUN apt-get update && apt-get install -y \
    curl \
    lsb-release \
    gnupg \
    unzip \
    dos2unix \
    vim \
    python3-pip \
    ros-jazzy-joint-state-publisher \
    ros-jazzy-joint-state-publisher-gui \
    ros-jazzy-cartographer \
    ros-jazzy-cartographer-ros \
    ros-jazzy-navigation2 \
    ros-jazzy-nav2-bringup \
    && rm -rf /var/lib/apt/lists/*

# install Gazebo gz-harmonic
RUN curl https://packages.osrfoundation.org/gazebo.gpg \
    --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] \
    http://packages.osrfoundation.org/gazebo/ubuntu-stable \
    $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/gazebo-stable.list && \
    apt-get update && apt-get install -y \
    gz-harmonic \
    && rm -rf /var/list/apt/lists/*

# python packages
RUN pip3 install python-fcl --break-system-packages





# create user
RUN echo 'ubuntu:robotics' | chpasswd

# this version failed due to ubuntu user already existing
# RUN useradd -ms /bin/bash ubuntu && \
#     echo 'ubuntu:robotics' | chpasswd





# some stuff from robot motion planning class
# # custom ros packages
# RUN mkdir -p /home/ubuntu/ros_packages/src
# WORKDIR /home/ubuntu/ros_packages/src
#
# COPY spatial3r_description-main.zip .
# COPY rmp_util.zip .
#
# # spatial3r_description TODO: Remove -main.
# RUN unzip spatial3r_description-main.zip && \
#     mv spatial3r_description-main spatial3r_description && \
#     unzip rmp_util.zip && \
#     rm *.zip
#
# WORKDIR /home/ubuntu/ros_packages
# RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && colcon build --symlink-install"





# turtlebot3 workspace
RUN mkdir -p /home/ubuntu/turtlebot3_ws/src
WORKDIR /home/ubuntu/turtlebot3_ws/src

RUN git clone -b jazzy https://github.com/ROBOTIS-GIT/DynamixelSDK.git && \
    git clone -b jazzy https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git && \
    git clone -b jazzy https://github.com/ROBOTIS-GIT/turtlebot3.git && \
    git clone -b jazzy https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git

WORKDIR /home/ubuntu/turtlebot3_ws
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && colcon build --symlink-install"





# entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh && chmod +x /entrypoint.sh





# environment setup
RUN echo "source /opt/ros/jazzy/setup.bash" >> /etc/bash.bashrc && \
    echo "source /home/ubuntu/turtlebot3_ws/install/setup.bash" >> /etc/bash.bashrc && \
    echo "export ROS_DOMAIN_ID=30" >> /etc/bash.bashrc

    # echo "source /home/ubuntu/ros_packages/install/setup.bash" >> /etc/bash.bashrc && \





# perms
RUN chown -R ubuntu:ubuntu /home/ubuntu





# switch user
USER ubuntu
WORKDIR /home/ubuntu

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]
