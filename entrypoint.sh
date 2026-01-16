#! /usr/bin/env bash
set -e

# source ros
if [ -f /opt/ros/jazzy/setup.bash ]; then
    source /opt/ros/jazzy/setup.bash
else
    echo "Warning: ROS Jazzy setup.bash not found" >&2
fi

# source turtlebot3
if [ -f /home/ubuntu/turtlebot3_ws/install/setup.bash ]; then
    source /home/ubuntu/turtlebot3_ws/install/setup.bash
else
    echo "Warning: TurtleBot3 workspace setup.bash not found" >&2
fi

exec "$@"
