#!/bin/bash
# Спираме скрипта веднага, ако някоя команда даде грешка (Exit on Error)
set -e

# 1. Изчистване на стари среди за чиста инсталация
rm -rf /Engineering /Sales /IS

# 2. Принудително премахване на съществуващи потребители
userdel -f -r adminengineering || true
userdel -f -r userengineering1 || true
userdel -f -r userengineering2 || true
userdel -f -r adminsales || true
userdel -f -r usersales1 || true
userdel -f -r usersales2 || true
userdel -f -r adminis || true
userdel -f -r useris1 || true
userdel -f -r useris2 || true

# 3. Създаване на папките и системните групи
mkdir -p /Engineering /Sales /IS
groupadd -f engineering
groupadd -f sales
groupadd -f is

# 4. Създаване на потребителите за отдел Engineering
useradd -m -g engineering -s /bin/bash adminengineering
useradd -m -g engineering -s /bin/bash userengineering1
useradd -m -g engineering -s /bin/bash userengineering2

# 5. Създаване на потребителите за отдел Sales
useradd -m -g sales -s /bin/bash adminsales
useradd -m -g sales -s /bin/bash usersales1
useradd -m -g sales -s /bin/bash usersales2

# 6. Създаване на потребителите за отдел IS
useradd -m -g is -s /bin/bash adminis
useradd -m -g is -s /bin/bash useris1
useradd -m -g is -s /bin/bash useris2

# 7. Настройка на права и собственост за директориите (770 + Sticky Bit)
chown adminengineering:engineering /Engineering && chmod 770 /Engineering && chmod +t /Engineering
chown adminsales:sales /Sales && chmod 770 /Sales && chmod +t /Sales
chown adminis:is /IS && chmod 770 /IS && chmod +t /IS

# 8. Създаване и заключване на секретните файлове (640 Permissions Matrix)
echo "This file contains confidential information for the department." > /Engineering/confidential.txt
echo "This file contains confidential information for the department." > /Sales/confidential.txt
echo "This file contains confidential information for the department." > /IS/confidential.txt

chown adminengineering:engineering /Engineering/confidential.txt && chmod 640 /Engineering/confidential.txt
chown adminsales:sales /Sales/confidential.txt && chmod 640 /Sales/confidential.txt
chown adminis:is /IS/confidential.txt && chmod 640 /IS/confidential.txt

echo "Setup completed successfully with 100% security alignment!"
Use code with caution.

2. За втория проект (linux-dynamic-user-provisioning)

Създай нов файл с име user_manager.sh и копирай вътре точно този умен код с циклите [NDG Linux Essentials Challenge Lab A]:
bash
#!/bin/bash

# 1. ЗАПИТВАНЕ И ПРОВЕРКА ЗА ГРУПА
echo "Please enter the group name:"
read GROUP_NAME

while grep -wq "$GROUP_NAME" /etc/group; do
    echo "Error: Group already exists!"
    echo "Please try another group name:"
    read GROUP_NAME
done

groupadd "$GROUP_NAME"

# 2. ЗАПИТВАНЕ И ПРОВЕРКА ЗА ПОТРЕБИТЕЛ
echo "Please enter your username:"
read USER_NAME

while grep -q "^$USER_NAME:" /etc/passwd; do
     echo "Error: User already exists!"
     echo "Please try another user name:"
     read USER_NAME
done 

# 3. СЪЗДАВАНЕ, ПАРОЛА И ПРАВА
useradd -g "$GROUP_NAME" -s /bin/bash "$USER_NAME"
echo "$USER_NAME:password123" | chpasswd

mkdir -p /$USER_NAME
chown $USER_NAME:$GROUP_NAME /$USER_NAME
chmod 770 /$USER_NAME
chmod +t /$USER_NAME

echo "Setup completed successfully for $USER_NAME!"



