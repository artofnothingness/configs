# # # ROS 2

# # # Aliases # # # 
alias cb='colcon_build_release'
alias ct='colcon_test'
alias rd='rosdep_install'

function rosdep_install {
  rosdep install --from-paths $1 --ignore-src -r -y
}

# # # Functions # # # 
function colcon_build_release {
  if [[ $# == 0 ]]; then
    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
  else
    colcon build --packages-select "$@" --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
  fi
}

function colcon_test {
  colcon test --packages-select "$@" --ctest-args -VV --event-handlers console_direct+
}

function ros_source {
  source /opt/ros/${ROS_DISTRO}/setup.zsh
  include ~/rep/ros2/install/setup.zsh
  include /opt/nav2_ws/install/setup.zsh
  include /opt/nav2_deps_ws/install/setup.zsh

  export TURTLEBOT3_MODEL=waffle
  export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11:/usr/share/gazebo-11/models:${GAZEBO_RESOURCE_PATH}
  export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/opt/ros/${ROS_DISTRO}/share/turtlebot3_gazebo/models
  export ROS_DOMAIN_ID=30 
}

if [[ "${ROS_DISTRO}" ]]; then
  ros_source
fi

