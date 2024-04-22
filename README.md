# AltSchool Second Semester Examination

**Report on Automating the Provisioning of Ubuntu-Based Servers and Deploying a LAMP Stack Using Vagrant and Ansible**
**Objective:**
The primary goal of this project was to automate the provisioning of two Ubuntu-based virtual servers, named "Master" and "Slave," using Vagrant. The specific tasks involved setting up a LAMP (Linux, Apache, MySQL, PHP) stack on the Slave node via a bash script executed from the Master node. Additionally, the project required the PHP application from the Laravel GitHub repository to be cloned and configured to run on the Slave node. The automation extended to executing periodic server uptime checks via a cron job.
**Initial Setup and Configuration:**

1. **Understanding the Task Requirements:**
2. The project commenced with a thorough analysis of the requirements to ensure clarity on the end goals—automating server setup and application deployment.
3. **Provisioning the Virtual Servers:**
4. Using Vagrant, two Ubuntu-based virtual machines (VMs) were set up. The VMs were named "master" for the control node and "slave" for the remote server where the LAMP stack and PHP application would be deployed.
5. **SSH Configuration:**
6. To facilitate seamless communication between the Master and Slave nodes, SSH keys were generated on the Master node and copied to the Slave node. Modifications were made to the `**/etc/ssh/sshd_config**` file on the Slave node to ensure proper authentication and security settings.
![](https://paper-attachments.dropboxusercontent.com/s_ED4C6CD3DFADF7B5D66251579E1355320DB00116E3DA75B39226D8AC884F3CA1_1713816378937_Screenshot+2024-04-22+002343.png)


**Bash Script Development:**

1. **Script Creation (**`**deploy_lamp.sh**`**):**
2. A reusable and readable bash script was crafted on the Master node. This script was responsible for:
    - Updating system packages.
    - Installing necessary packages including Git, Apache, PHP, and MySQL.
    - Cloning the Laravel PHP application from its GitHub repository.
![](https://paper-attachments.dropboxusercontent.com/s_ED4C6CD3DFADF7B5D66251579E1355320DB00116E3DA75B39226D8AC884F3CA1_1713816531993_Screenshot+2024-04-22+002208.png)


**Ansible Automation:**

1. **Ansible Installation:**
2. Ansible was installed on the Master node to manage and automate tasks on the Slave node.
3. **Inventory Setup (**`**hosts**` **file):**
4. An inventory file was created in the Ansible directory to manage the IP addresses of the Master and Slave servers.
5. **Playbook Creation (**`**deploy_lamp.yaml**`**):**
6. An Ansible playbook was developed to:
    - Execute the `**deploy_lamp.sh**` bash script on the Slave node.
    - Configure Apache to serve the cloned Laravel application.
    - Establish a cron job to log server uptime every 12 am.
![](https://paper-attachments.dropboxusercontent.com/s_ED4C6CD3DFADF7B5D66251579E1355320DB00116E3DA75B39226D8AC884F3CA1_1713816564602_Screenshot+2024-04-22+010924.png)


**Deployment and Verification:**

1. **Execution of Playbook:**
2. The Ansible playbook was run, deploying the LAMP stack on the Slave node and ensuring the PHP application was accessible through the VM's IP address. A screenshot was taken as evidence of the application running successfully.
3. **Cron Job Configuration:**
4. A cron job was set up to record the Slave server’s uptime, executing at 12 am daily. This setup was verified through logs to ensure accuracy and functionality.
![](https://paper-attachments.dropboxusercontent.com/s_ED4C6CD3DFADF7B5D66251579E1355320DB00116E3DA75B39226D8AC884F3CA1_1713816655545_Screenshot+2024-04-22+001334.png)

![](https://paper-attachments.dropboxusercontent.com/s_ED4C6CD3DFADF7B5D66251579E1355320DB00116E3DA75B39226D8AC884F3CA1_1713816951211_slave.png)


**Conclusion and Evidence:**
The project successfully achieved its goals by automating the provisioning and setup processes using Vagrant and Ansible. The Slave node was effectively configured to host the Laravel application, accessible via the web browser. The cron job was also implemented correctly, adhering to the specified schedule.

