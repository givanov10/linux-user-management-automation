# linux-user-management-automation

# Linux Automated User Management & Security Script

An automated, idempotent Bash script designed to configure enterprise-level user accounts, department directories, and precise access permissions based on a corporate restructuring scenario.

## 📋 Scenario Overview
As a Linux Systems Administrator, I was tasked with onboarding 9 new employees across 3 newly designed departments: **Engineering**, **Sales**, and **IS**. The server required immediate and secure setup of appropriate directories, primary groups, strict user permissions, and confidential document isolation.

## 🚀 Key Features & Automation Logic
* **Idempotency Built-in:** The script is engineered with `set -e` (Exit on Error) and uses advanced flags like `mkdir -p` and `userdel -f -r || true` so it can be safely rerun multiple times without breaking the system configuration.
* **Role-Based Access Control (RBAC):** Configured distinct primary groups (`-g`) and assigned explicit directory ownership (`chown`) separating Department Administrators from standard users.
* **Hardened Security Layout:** Implemented `chmod 770` permissions to completely isolate department folders from outside eyes, paired with the **Sticky Bit (+t)** to prevent employees within the same group from accidentally deleting each other's files.
* **Confidential Data Deployment:** Automatically generates restricted department documents with a secure `640` file permission matrix (Admin: Read/Write, Group: Read-Only, Others: No Access).

## 🛠️ The Script (`setup.sh`)
```bash
#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# 1. Clean up old environments to ensure a fresh, consistent deploy
rm -rf /Engineering /Sales /IS

# 2. Force-remove existing users to handle seamless overwrites
userdel -f -r adminengineering || true
userdel -f -r userengineering1 || true
userdel -f -r userengineering2 || true
userdel -f -r adminsales || true
userdel -f -r usersales1 || true
userdel -f -r usersales2 || true
userdel -f -r adminis || true
userdel -f -r useris1 || true
userdel -f -r useris2 || true

# 3. Recreate clean department directories and system groups
mkdir -p /Engineering /Sales /IS
groupadd -f engineering
groupadd -f sales
groupadd -f is

# 4. Provision users with custom home directories and explicit Bash shells
useradd -m -g engineering -s /bin/bash adminengineering
useradd -m -g engineering -s /bin/bash userengineering1
useradd -m -g engineering -s /bin/bash userengineering2

useradd -m -g sales -s /bin/bash adminsales
useradd -m -g sales -s /bin/bash usersales1
useradd -m -g sales -s /bin/bash usersales2

useradd -m -g is -s /bin/bash adminis
useradd -m -g is -s /bin/bash useris1
useradd -m -g is -s /bin/bash useris2

# 5. Enforce directory ownership and isolation (Strict 770 Permissions + Sticky Bit)
chown adminengineering:engineering /Engineering && chmod 770 /Engineering && chmod +t /Engineering
chown adminsales:sales /Sales && chmod 770 /Sales && chmod +t /Sales
chown adminis:is /IS && chmod 770 /IS && chmod +t /IS

# 6. Generate and secure confidential files (640 Permissions Matrix)
echo "This file contains confidential information for the department." > /Engineering/confidential.txt
echo "This file contains confidential information for the department." > /Sales/confidential.txt
echo "This file contains confidential information for the department." > /IS/confidential.txt

chown adminengineering:engineering /Engineering/confidential.txt && chmod 640 /Engineering/confidential.txt
chown adminsales:sales /Sales/confidential.txt && chmod 640 /Sales/confidential.txt
chown adminis:is /IS/confidential.txt && chmod 640 /IS/confidential.txt

echo "Setup completed successfully with 100% security alignment!"
```

## 🔍 Validation Commands Used
To verify security hardening on production, the following checks pass perfectly:
```bash
ls -ld /Engineering /Sales /IS
# Outputs: drwxrwx--T (Ensuring the Sticky Bit is active)

sudo cat /Engineering/confidential.txt
# Outputs: This file contains confidential information for the department.
```
