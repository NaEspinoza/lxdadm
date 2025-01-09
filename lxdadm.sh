#!/bin/bash

# General LXD Container Management Script
# Author: Nazareno A. Espinoza
# Version: 1.0
# Description: A script to manage LXD containers: list, create, update, and delete.

# Colors for output
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

# Help message
show_help() {
  echo -e "${GREEN}LXD Container Management Script${RESET}"
  echo "Usage: $0 [command] [options]"
  echo ""
  echo "Commands:"
  echo "  list                     List all containers"
  echo "  create <name> <image>    Create a new container with the specified name and image"
  echo "  update <name>            Update container resources (CPU, RAM, disk size)"
  echo "  delete <name>            Delete a container"
  echo ""
  echo "Options for 'create' command:"
  echo "  --cpu <count>            Set CPU limit (e.g., 1, 2)"
  echo "  --memory <size>          Set memory limit (e.g., 1GB, 512MB)"
  echo "  --disk <size>            Set disk size (e.g., 10GB, 50GB)"
  echo ""
  echo "Examples:"
  echo "  $0 list"
  echo "  $0 create my-container ubuntu:24.04 --cpu 2 --memory 2GB --disk 20GB"
  echo "  $0 update my-container"
  echo "  $0 delete my-container"
  echo ""
}

# Function to list containers
list_containers() {
  echo -e "${YELLOW}Listing all containers...${RESET}"
  lxc list || echo -e "${RED}Failed to list containers. Is LXD installed and configured?${RESET}"
}

# Function to create a container
create_container() {
  local name=$1
  local image=$2
  shift 2
  local cpu=""
  local memory=""
  local disk=""
  
  while [[ $# -gt 0 ]]; do
    case $1 in
      --cpu)
        cpu=$2
        shift 2
        ;;
      --memory)
        memory=$2
        shift 2
        ;;
      --disk)
        disk=$2
        shift 2
        ;;
      *)
        echo -e "${RED}Unknown option: $1${RESET}"
        exit 1
        ;;
    esac
  done

  echo -e "${YELLOW}Creating container '${name}' with image '${image}'...${RESET}"
  lxc launch "$image" "$name" --profile default || { echo -e "${RED}Failed to create container.${RESET}"; exit 1; }

  if [[ -n $cpu ]]; then
    echo -e "${YELLOW}Setting CPU limit to ${cpu}...${RESET}"
    lxc config set "$name" limits.cpu "$cpu"
  fi

  if [[ -n $memory ]]; then
    echo -e "${YELLOW}Setting memory limit to ${memory}...${RESET}"
    lxc config set "$name" limits.memory "$memory"
  fi

  if [[ -n $disk ]]; then
    echo -e "${YELLOW}Setting disk size to ${disk}...${RESET}"
    lxc config device override "$name" root size="$disk"
  fi

  echo -e "${GREEN}Container '${name}' created successfully.${RESET}"
}

# Function to update a container
update_container() {
  local name=$1
  echo -e "${YELLOW}Updating container '${name}'...${RESET}"
  
  read -p "Enter new CPU limit (leave blank to keep current): " cpu
  [[ -n $cpu ]] && lxc config set "$name" limits.cpu "$cpu"

  read -p "Enter new memory limit (e.g., 1GB, leave blank to keep current): " memory
  [[ -n $memory ]] && lxc config set "$name" limits.memory "$memory"

  read -p "Enter new disk size (e.g., 10GB, leave blank to keep current): " disk
  [[ -n $disk ]] && lxc config device override "$name" root size="$disk"

  echo -e "${GREEN}Container '${name}' updated successfully.${RESET}"
}

# Function to delete a container
delete_container() {
  local name=$1
  echo -e "${YELLOW}Deleting container '${name}'...${RESET}"
  lxc stop "$name" --force || echo -e "${RED}Failed to stop container '${name}'. It might not be running.${RESET}"
  lxc delete "$name" || { echo -e "${RED}Failed to delete container '${name}'.${RESET}"; exit 1; }
  echo -e "${GREEN}Container '${name}' deleted successfully.${RESET}"
}

# Main logic
if [[ $# -lt 1 ]]; then
  show_help
  exit 1
fi

command=$1
shift

case $command in
  list)
    list_containers
    ;;
  create)
    if [[ $# -lt 2 ]]; then
      echo -e "${RED}Error: Missing required arguments for 'create'.${RESET}"
      show_help
      exit 1
    fi
    create_container "$@"
    ;;
  update)
    if [[ $# -lt 1 ]]; then
      echo -e "${RED}Error: Missing required arguments for 'update'.${RESET}"
      show_help
      exit 1
    fi
    update_container "$1"
    ;;
  delete)
    if [[ $# -lt 1 ]]; then
      echo -e "${RED}Error: Missing required arguments for 'delete'.${RESET}"
      show_help
      exit 1
    fi
    delete_container "$1"
    ;;
  *)
    echo -e "${RED}Unknown command: $command${RESET}"
    show_help
    exit 1
    ;;
esac
