# Yandex Practicum. Software architect (sprint 2)

---

## Задание 2. Шардирование

---

### Уровень 1. Описание

Этот проект реализует MongoDB с шардированием. Приложение `pymongo-api` взаимодействует с MongoDB через два шарда.

- **pymongo-api** — REST API для взаимодействия с MongoDB.
- **MongoDB Config Server (`mongo-config`)** — необходим для управления метаданными шардов.
- **Shard 1 (`mongo-shard-1`)** — первый шард.
- **Shard 2 (`mongo-shard-2`)** — второй шард.
- **Mongo Router (`mongos-router`)** — маршрутизатор, через который осуществляется подключение к MongoDB.

[Схема (drow.io)](./mongo-sharding.drawio)
[Схема (картинка)](./mongo-sharding.png)

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