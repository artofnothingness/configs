# # # ROS 2

if [[ "${ROS_DISTRO}" ]]; then
  source /opt/ros/${ROS_DISTRO}/setup.zsh
  export RCUTILS_COLORIZED_OUTPUT=1
fi

