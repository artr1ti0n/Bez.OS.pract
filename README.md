# Функция display_help
Эта функция выводит текст справки, который описывает, как пользоваться скриптом и какие аргументы можно передавать.

# Функция display_users
Эта функция выводит список пользователей и их домашних директорий, сортируя их по алфавиту.
Команда cut выбирает первое и шестое поля из файла /etc/passwd, разделяя поля по символу :. Первое поле - это имя пользователя, шестое - домашняя директория.

# Функция display_processes
Выводит список запущенных процессов, отсортированных по их идентификатору.
ps -e --sort=pid - команда ps показывает все запущенные процессы, сортируя их по идентификатору процесса (PID).

# Обработка аргументов командной строки с помощью getopts
Здесь мы обрабатываем переданные скрипту аргументы. getopts позволяет легко обрабатывать короткие опции (например, -u), а для обработки длинных опций (например, --users) используется case.

# Проверка и установка перенаправления вывода и ошибок
Если были указаны пути для логов или ошибок, проверяется возможность записи в эти файлы. Если проверка успешна, вывод и/или ошибки перенаправляются в соответствующие файлы.

# Выполнение действий на основе установленных флагов
Если установлены флаги USERS_FLAG или PROCESSES_FLAG, выполняются соответствующие функции для отображения пользователей или процессов. Если не было передано ни одного подходящего аргумента, выводится справка.
