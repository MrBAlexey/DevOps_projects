# Basic CI/CD

Разработка простого **CI/CD** для проекта *SimpleBashUtils*. Сборка, тестирование, развертывание.


## Contents

1. [Chapter III](#chapter-iii) 
   1. [Настройка gitlab-runner](#part-1-настройка-gitlab-runner)  
   2. [Сборка](#part-2-сборка)  
   3. [Тест кодстайла](#part-3-тест-кодстайла)   
   4. [Интеграционные тесты](#part-4-интеграционные-тесты)  
   5. [Этап деплоя](#part-5-этап-деплоя)  
   6. [Дополнительно. Уведомления](#part-6-дополнительно-уведомления)


## Chapter III

В качестве результата работы ты должен сохранить два дампа образов виртуальных машин, описанных далее. \
**P.S. Ни в коем случае не сохраняй дампы в гит!**

### Part 1. Настройка **gitlab-runner**

##### Подними виртуальную машину *Ubuntu Server 22.04 LTS*.
*Будь готов, что в конце проекта нужно будет сохранить дамп образа виртуальной машины.*
1. Поднял Ubuntu Server 22.04 LTS

   ![](screenshots/1.1.1(CI_CD_server_install).png)

##### Скачай и установи на виртуальную машину **gitlab-runner**.

2. Скачал и установил gitlab-runner командами:
> `curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash` 
> `sudo apt-get install gitlab-runner`

   ![](screenshots/1.2.2(CI_CD_gitlab_runner_download).png)

   ![](screenshots/1.2.3(CI_CD_gitlab_runner_install).png)

##### Запусти **gitlab-runner** и зарегистрируй его для использования в текущем проекте (*DO6_CICD*).
- Для регистрации понадобятся URL и токен, которые можно получить на страничке задания на платформе.

3. Запустил и зарегестрировал командами 
> `sudo gitlab-runner start`  
> `sudo gitlab-runner register`

   ![](screenshots/1.3.4(CI_CD_gitlab_runner_start).png)

   ![](screenshots/1.3.5(CI_CD_gitlab_runner_register).png)


### Part 2. Сборка

#### Напиши этап для **CI** по сборке приложений из проекта *C2_SimpleBashUtils*.
##### В файле _gitlab-ci.yml_ добавь этап запуска сборки через мейк файл из проекта _C2_.
##### Файлы, полученные после сборки (артефакты), сохрани в произвольную директорию со сроком хранения 30 дней.


   ![настроенный gitlab-ci.yml](screenshots/2.1_2_3.6(CI_CD_gitlab_ci_yml).png)


### Part 3. Тест кодстайла
#### Напиши этап для **CI**, который запускает скрипт кодстайла (*clang-format*).

  ![](screenshots/3.1.7(CI_CD_gitlab_ci_yml_style).png)
1. успешная загрузка и прохождение тестов

  ![](screenshots/3.1.8(CI_CD_gitlab_passed_style).png)

  ![](screenshots/3.1.9(CI_CD_gitlab_passed_style).png) 


##### Если кодстайл не прошел, то «зафейли» пайплайн.
2. изменим содержимое в коде s21_cat.c так чтобы он не проходил по кодстайлу и запушим в гитлаб

  ![](screenshots/3.2.10(CI_CD_gitlab_fail_style).png)

  ##### В пайплайне отобрази вывод утилиты *clang-format*.

  3. посмотрим содержимое пайплайна:

  ![](screenshots/3.3.11(CI_CD_gitlab_fail_style).png)

### Part 4. Интеграционные тесты

создадим файл в src fall_tests.sh

#### Напиши этап для **CI**, который запускает твои интеграционные тесты из того же проекта.

  ![](screenshots/4.1.12(CI_CD_gitlab_ci_yml_add_test_job).png)

##### Запусти этот этап автоматически только при условии, если сборка и тест кодстайла прошли успешно.


   ![](screenshots/4.2.13(CI_CD_gitlab_tests_passed).png)

##### Если тесты не прошли, то «зафейли» пайплайн.

   ![](screenshots/4.3.14(CI_CD_gitlab_tests_fail).png)

##### В пайплайне отобрази вывод, что интеграционные тесты успешно прошли / провалились.

   ![](screenshots/4.4.15(CI_CD_gitlab_tests_fail).png)

### Part 5. Этап деплоя
##### Подними вторую виртуальную машину *Ubuntu Server 22.04 LTS*.
1. Поднял и настроил вторую виртуальную машину *Ubuntu Server 22.04 LTS*

   ![](screenshots/5.1.16(CI_CD_2_statrt_second_vm).png)
   
   ![](screenshots/5.1.17(CI_CD_2_netplan).png)

   ![](screenshots/5.1.18(CI_CD_1_netplan).png)

2. Далее создал на пользователя gitlab-runner на виртуальной машине 1. Создал ключ доступа, скопировал его и настроил доступ по ssh.

Для этого использовал команды:
sudo su gitlab-runner - переключился на пользователя
- ssh-keygen -t rsa -b 2048 - сгенерировал ключ
- ssh-copy-id cd@192.168.100.15 - скопировал на вторую виртуальную машину
- ssh cd@192.168.100.15 - подключился удаленно ко второй машине

Далее на виртуальной машине cd@192.168.100.15 так же сгенерировал ключ и настроил доступ.
- ssh-keygen -t rsa -b 2048
- ssh-copy-id имя_второй_@192.168.100.14
- sudo chown -R $(whoami) /usr/local/bin

> sudo chown -R $(whoami) /usr/local/bin изменяет владельца и группу для всех файлов и каталогов в директории /usr/local/bin на текущего пользователя, который исполняет эту команду. (chown - change owner)

#### Напиши этап для **CD**, который «разворачивает» проект на другой виртуальной машине.
##### Запусти этот этап вручную при условии, что все предыдущие этапы прошли успешно.

3. Написал этап деплоя. Добавил условие запуска вручную `when: manual`

   ![](screenshots/5.2_3.19(CI_CD_gitlab_yml).png)

   ![](screenshots/5.2_3.20(CI_CD_gitlab).png)

   ![](screenshots/5.2_3.21(CI_CD_gitlab).png)

##### Напиши bash-скрипт, который при помощи **ssh** и **scp** копирует файлы, полученные после сборки (артефакты), в директорию */usr/local/bin* второй виртуальной машины.
*Тут тебе могут помочь знания, полученные в проекте DO2_LinuxNetwork.*

4. Написал скрипт:

   ![](screenshots/5.4.22(CI_CD_script_deploy).png)

##### В файле _gitlab-ci.yml_ добавь этап запуска написанного скрипта.

   ![](screenshots/5.2_3.19(CI_CD_gitlab_yml).png)

##### В случае ошибки «зафейли» пайплайн.


   ![](screenshots/5.4.22(CI_CD_script_deploy).png)

В результате ты должен получить готовые к работе приложения из проекта *C2_SimpleBashUtils* (s21_cat и s21_grep) на второй виртуальной машине.

   ![](screenshots/5.4.23(CI_CD_vm2_cat_grep).png)

##### Сохрани дампы образов виртуальных машин.
**P.S. Ни в коем случае не сохраняй дампы в гит!**

   ![](screenshots/5.4.24(CI_CD_dump).png)

- Не забудь запустить пайплайн с последним коммитом в репозитории.

   ![](screenshots/5.6.25(CI_CD_pipellines).png)

### Part 6. Дополнительно. Уведомления

##### Настрой уведомления о успешном/неуспешном выполнении пайплайна через бота с именем «[твой nickname] DO6 CI/CD» в *Telegram*.
1. cоздал бота через BotFather в ТГ и использовал предоставленный токен.

   ![](screenshots/6.2.28(CI_CD_bot_my_id).png)

2. узнал свой ID через getmyid_bot в ТГ. 

   ![](screenshots/6.2.29(CI_CD_my_bot_create).png)

3. написал скрипт и настроил уведомления.

   ![](screenshots/6.1.26(CI_CD_bot).png)

   ![](screenshots/6.1.27(CI_CD_bot).png)

- Текст уведомления должен содержать информацию об успешности прохождения как этапа **CI**, так и этапа **CD**.
- В остальном текст уведомления может быть произвольным.
4. Бот работает

   ![](screenshots/6.2.30(CI_CD_my_bot_notification).png)