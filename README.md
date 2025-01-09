### **README: LXD Container Management Script**

---

# LXD Container Management Script

A **flexible and professional script** to manage LXD containers: list, create, update, and delete. This script is ideal for system administrators, DevOps engineers, and developers who use **LXD** for container management.

---

## **Features**
- List all containers in the LXD cluster.
- Create new containers with configurable resource limits (CPU, memory, disk).
- Update existing container configurations.
- Delete containers safely and cleanly.
- Compatible with any system running **LXD** and **Bash**.

---

## **Requirements**
- **LXD** must be installed and configured on the system.
- **Bash** (typically pre-installed on most Linux distributions).

---

## **Installation**
1. Clone or download this repository:
   ```bash
   git clone https://github.com/NaEspinoza/lxdadm.git
   cd lxd-container-manager
   ```

2. Make the script executable:
   ```bash
   chmod +x lxd_manager.sh
   ```

---

## **Usage**

### General Syntax
```bash
./lxd_manager.sh [command] [options]
```

### Commands
| Command         | Description                                       | Example                                                                                     |
|------------------|---------------------------------------------------|---------------------------------------------------------------------------------------------|
| `list`          | List all containers in the cluster                | `./lxd_manager.sh list`                                                                    |
| `create`        | Create a new container with resource limits       | `./lxd_manager.sh create my-container ubuntu:24.04 --cpu 2 --memory 2GB --disk 20GB`       |
| `update`        | Update the resources (CPU, memory, disk) of a container | `./lxd_manager.sh update my-container`                                                     |
| `delete`        | Delete a container safely                         | `./lxd_manager.sh delete my-container`                                                     |

---

### **Options for `create`**
| Option         | Description                                           | Example          |
|----------------|-------------------------------------------------------|------------------|
| `--cpu`        | Number of CPU cores to assign to the container         | `--cpu 2`       |
| `--memory`     | Amount of RAM to assign (e.g., `1GB`, `512MB`)         | `--memory 2GB`  |
| `--disk`       | Disk size to allocate (e.g., `10GB`, `50GB`)           | `--disk 20GB`   |

---

### **Examples**

#### List Containers
```bash
./lxd_manager.sh list
```

#### Create a Container
Create a container named `my-container` using the image `ubuntu:24.04` with:
- **2 CPU cores**
- **2GB of RAM**
- **20GB of disk space**

Command:
```bash
./lxd_manager.sh create my-container ubuntu:24.04 --cpu 2 --memory 2GB --disk 20GB
```

#### Update a Container
Update the resources of `my-container`:
1. Change the CPU limit to **1**.
2. Increase memory to **3GB**.
3. Set disk size to **25GB**.

Command:
```bash
./lxd_manager.sh update my-container
```
The script will prompt for new resource values. Leave blank to keep current settings.

#### Delete a Container
Delete a container named `my-container`:
```bash
./lxd_manager.sh delete my-container
```

---

## **Error Handling**
- The script checks for missing dependencies and informs the user if **LXD** or **Bash** is not installed.
- Detailed error messages are provided for invalid inputs or failed operations.

---

## **Contributing**
Feel free to fork this repository and submit pull requests with enhancements or bug fixes. Contributions are welcome!

---

## **License**
This script is licensed under the MIT License. See [LICENSE](https://github.com/NaEspinoza/lxdadm/blob/main/LICENSE) for details.

---

## **Notes**
- The script assumes a properly configured LXD environment.
- For guidance on setting up LXD, visit the [LXD documentation](https://linuxcontainers.org/lxd/docs/).
