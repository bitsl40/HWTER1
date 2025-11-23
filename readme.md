# Домашнее задание к занятию «Введение в Terraform»


### Задание 1

> 1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте. 
> 2. Изучите файл **.gitignore**. В каком terraform-файле, согласно этому .gitignore, допустимо сохранить личную, секретную информацию?(логины,пароли,ключи,токены итд)
> 3. Выполните код проекта. Найдите  в state-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.  

### ОТВЕТ:  "result": "OzGM0fzLNZumCWxM"

 > 4. Раскомментируйте блок кода, примерно расположенный на строчках 29–42 файла **main.tf**.
 > Выполните команду ```terraform validate```. Объясните, в чём заключаются намеренно допущенные ошибки. Исправьте их.

### ОТВЕТ:
  
```
 resource "docker_image" {     # есть тип ресурса, но не указано имя ресурса
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "1nginx" {  # имя ресурса не может начинаться с цифры
  image = docker_image.nginx.image_id
  name  = "example_${random_password.random_string_FAKE.resulT}" # ссылка на не существующий ресурс, выше в коде он назван random_string и синтаксис в  resursT не может оканчиваться на заглавную букву

```  
> 5. Выполните код. В качестве ответа приложите: исправленный фрагмент кода и вывод команды ```docker ps```.

### ОТВЕТ:

### Листинг исправленного кода:
```
resource "docker_image" "im_nginx"{
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.im_nginx.image_id
  name  = "im_nginx_${random_password.random_string.result}"

  ports {
    internal = 80
    external = 9090
  }
```
### Вывод команды docker ps:

```
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
2ff75a14488d   60adc2e137e7   "/docker-entrypoint.…"   2 minutes ago   Up 2 minutes   0.0.0.0:9090->80/tcp   im_nginx_OzGM0fzLNZumCWxM
```

> 6. Замените имя docker-контейнера в блоке кода на ```hello_world```. Не перепутайте имя контейнера и имя образа. Мы всё ещё продолжаем использовать name = "nginx:latest". Выполните команду ```terraform apply -auto-approve```. Объясните > своими словами, в чём может быть опасность применения ключа  ```-auto-approve```. Догадайтесь или нагуглите зачем может пригодиться данный ключ? В качестве ответа дополнительно приложите вывод команды ```docker ps```.

### ОТВЕТ:

Ключ -auto-approve в команде terraform apply автоматически подтверждает выполнение плана изменений без запроса подтверждения у пользователя. Опасность примениния данного ключа, заключается без контрольном изменении ресурсов, без потверждения пользователя.
Данный ключ может быть полезен при втоматизации, используя в скриптах и в Ci/CD piplinах

###  вывод команды docker ps:

```
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
eacec7ee9c2c   60adc2e137e7   "/docker-entrypoint.…"   5 seconds ago   Up 5 seconds   0.0.0.0:9090->80/tcp   hello_world
```



> 8. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**. 

### ОТВЕТ:

### Cодержимое файла **terraform.tfstate**:
```
{
  "version": 4,
  "terraform_version": "1.12.0",
  "serial": 18,
  "lineage": "e545cd1b-22ce-fc40-9367-500671076e8f",
  "outputs": {},
  "resources": [],
  "check_results": null
}
``` 


 > 9. Объясните, почему при этом не был удалён docker-образ **nginx:latest**. Ответ **ОБЯЗАТЕЛЬНО НАЙДИТЕ В ПРЕДОСТАВЛЕННОМ КОДЕ**, а затем **ОБЯЗАТЕЛЬНО ПОДКРЕПИТЕ** строчкой из документации [**terraform провайдера docker**](https://docs.comcloud.xyz/providers/kreuzwerker/docker/latest/docs).  (ищите в классификаторе resource docker_image )

### OТВЕТ:

образ не был удален потому что используется параметр keep_locally = true.    Если значение true, при выполнении terraform destroy Terraform пропускает удаление  образа docker.  

Строчка  из документации:

keep_locally (Boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.



------




## Дополнительное задание (со звёздочкой*)


### Задание 2*

> 1. Создайте в облаке ВМ. Сделайте это через web-консоль, чтобы не слить по незнанию токен от облака в github(это тема следующей лекции). Если хотите - попробуйте сделать это через terraform, прочитав документацию yandex cloud. Используйте файл ```personal.auto.tfvars``` и гитигнор или иной, безопасный способ передачи токена!
> 2. Подключитесь к ВМ по ssh и установите стек docker.
>3. Найдите в документации docker provider способ настроить подключение terraform на вашей рабочей станции к remote docker context вашей ВМ через ssh.
> 4. Используя terraform и  remote docker context, скачайте и запустите на вашей ВМ контейнер ```mysql:8``` на порту ```127.0.0.1:3306```, передайте ENV-переменные. Сгенерируйте разные пароли через random_password и передайте их в контейнер, > используя интерполяцию из примера с nginx.(```name  = "example_${random_password.random_string.result}"```  , двойные кавычки и фигурные скобки обязательны!) 
```
    environment:
      - "MYSQL_ROOT_PASSWORD=${...}"
      - MYSQL_DATABASE=wordpress
      - MYSQL_USER=wordpress
      - "MYSQL_PASSWORD=${...}"
      - MYSQL_ROOT_HOST="%"
```

### Ответ:
[Сылка на репазиторий с заданием 2 ]([https://github.com/bitsl40/HWTER1/blob/main/task2/main.tf])

Скрин с вывода env-переменных в контейнере на ВМ в облаке 
![Изображение](https://github.com/bitsl40/HWTER1/blob/main/task2/%D1%82%D0%B0%D1%81%D0%BA2.png)
