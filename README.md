﻿mml
===
managment linux
---



Набор скриптов для упращения стандартных и рутинных задач в администрировании. Набор скриптов не способен заменить администратора, и требует минимальных знаний консоли. 
Задачи которые можно переложить на mml скрипты:
- инсталляция веб окружения php-fpm
- обязательная установка nginx фронтэнда. 
- создание-удаление веб доменов.
- создание-удаление пользователей, раздача прав
- инсталляция серверов баз данных, mysql.


===

План работ до сентября:
- Написание скрипта позволяющего создавать структуру каталогов веб сервера nginx + php-fpm
- Написание скрипта позволяющего создавать структуру каталогов сервера nginx + apache 2.2
- Написание документации к работе скрипта и структуре которая создается.
- Разработка скрипта для установки mysql или mysql percona на выбор.
- Разработка скрипта для установки posgreesql.
- Создание интерфейса для управления mysql и postgreaql серверами.
- Установка pgadmin и myadmin.
- создание ftp и sftp учеток, в chroot окружении домена.



Планы на будущее:
- первоначальная настройка репликации mysql 
- Полуавтоматическое (по команде админа) восстановление репликации после сбоя
 



Cтурктура каталогов nginx+php-fpm:
Схема с php-fpm является наиболее безопасной, каждый домен запускается от отдельного пользователя, и изолирован на уровне acl файловой системы от других доменов. При необходимости ftp и sftp пользователей можно запереть в chroot окружение, не давая шелла. Права всегда на все домены на даются минимальные.


- /storage/
- ├── socket 				- здесь располагаются сокеты php-fpm
- └── www	
-	└── domain.ru		- корневая папка конкретного домена domain.ru
-		├── log			- логи домена domain.ru
-       ├── tmp			- временные файлы domain.ru
-        └── www			- корневая директория domain.ru

Права на каталоги:
- /storage/						= root:root 2750, u:nginx:x, u:fpmdomainru:x
- /storage/socket/				= root:root 2750 u:nginx:rwx, u:fpmdomainru:rwx
- /storage/www/					= root:root 2750, u:nginx:x, u:fpmdomainru:x
- /storage/www/domain.ru/			= root:root 2750, u:nginx:x, u:fpmdomainru:x, u:user:rx
- /storage/www/domain.ru/www/		= root:root 2750, u:nginx:rx, u:fpmdomainru:rwx, u:user:rwx
- /storage/www/domain.ru/log/		= root:root 2750, u:nginx:rwx, u:fpmdomainru:rwx, u:user:rx
- /storage/www/domain.ru/tmp/		= root:root 2750, u:nginx:rwx, u:fpmdomainru:rwx, u:user:rwx



Скрипты:
./initservice.sh {initweb}
- Эта команда производит инициализацию структуты катлогов, и также устанавливает обязательный фронтэнд nginx.
Кроме того заменяется стандартный конфиг, создается домен по умолчанию.
Чтобы попроавить и привести права структуры каталогов в безопасное состояние необходимо заново выполнить эту команду. Puppet все сделает сам.

./initservice.sh {initmysql}
- Данная команда позволяет установить сервер баз данных mysql. Устанавливается последняя версия.
Также генерируется случайный пароль и записывается в файл /root/.my.cnf, после чего для вход в mysql пользователю root достаточно просто набрать команду mysql.

./managedomain.sh {adddom|deldom|showdom} "httpdomain"
- Этой командой производится добавление или удаление домена.
Создание домена происходит вместе с созданием всей структуры папок, и раздачей необходимых прав nginx и fpm серверу.
Удаление ведет к удалению структуры каталогов, конфигов.

./managedomain.sh {useradd|userdel}   "user"
- Добавление и удаление пользователя в системе.
При добавлении пользователя система генерирует 3 случайных пароля и предлагается выбрать один из них.
При удалении не удаляется домашний каталог пользователя!

./managedomain.sh {userdelperm|useraddperm}   "httpdomain" "user"
- Данная команда раздает и убирает добавленному предыдущей командой пользователю необходимые права для доступа к соостветствующему домену, посредством системы файловой acl.


!!!Внимание!!!
--------------
Ни одна из этих команд самостоятельно не рестартует сервисы. Чтобы перезапустить nginx и php-fpm необходимо использовать команду:
service nginx reload && service php-fpm reload
