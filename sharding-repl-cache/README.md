# Yandex Practicum. Software architect (sprint 2)

---

## Задание 3. Репликация

---

### Уровень 1. Описание

Этот проект реализует MongoDB с шардированием и репликаций. Приложение `pymongo-api` взаимодействует с MongoDB через два
шарда. Так же реализован кэш Redis для уменьшения нагрузки на MongoDB.

- **pymongo-api** — REST API для взаимодействия с MongoDB.
- **MongoDB Config Server (`mongo-config`)** — необходим для управления метаданными шардов.
- **Replicaset 0 (`rs-0`)** — первый Replicaset (состоит из трех нод).
- **Replicaset 1 (`rs-1`)** — второй Replicaset (состоит из трех нод).
- **Mongo Router (`mongos-router`)** — маршрутизатор, через который осуществляется подключение к MongoDB.
- **Redis (`redis`)** — кэш для хранения данных в памяти. Развернут как один инстанс.

[Схема (drow.io)](sharding-repl-cache.drawio)
[Схема (картинка)](sharding-repl-cache.png)

---

### Уровень 2. Запуск

Запуск кластера MongoDB и приложения `pymongo-api`:

```shell
  docker compose -f compose.yaml up --build -d
```

Инициализация тестовых данных в БД:

```shell
  ./scripts/mongo-init.sh
```

---

### Уровень 3. Проверка

Проверка распределения документов по шардам:

```bash
  ./scripts/check-mongo.sh
```

Если вы запускаете проект на локальной машине откройте в браузере http://localhost:8080.

Если вы запускаете проект на предоставленной виртуальной машине:

Узнать белый ip виртуальной машины

```shell
  curl --silent http://ifconfig.me
```

Откройте в браузере http://<ip виртуальной машины>:8080.

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs.