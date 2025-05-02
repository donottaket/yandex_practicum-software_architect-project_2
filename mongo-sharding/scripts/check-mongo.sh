#!/bin/bash

echo "Подключение к mongos-router и выполнение анализа шардирования..."

docker exec -i mongos-router mongosh --port 27020 --quiet <<EOF
print("\nАктивная база: somedb");
use somedb;

print("\nРаспределение документов по шардам (db.helloDoc):");

try {
  db.helloDoc.getShardDistribution();
} catch (e) {
  print("Ошибка при вызове getShardDistribution(). Возможно, коллекция не шардирована или пуста.");
}

print("\nИнформация о статусе шардирования:");
sh.status({ verbose: true });
EOF