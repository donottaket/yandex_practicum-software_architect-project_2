#!/bin/bash

echo "Подключение к mongos-router:27024 и анализ шардирования..."

docker exec -i mongos-router mongosh --port 27024 --quiet <<EOF
print("\nАктивная база: somedb");
use somedb;

print("\nРаспределение документов по шардам в коллекции db.helloDoc:");

try {
  db.helloDoc.getShardDistribution();
} catch (e) {
  print("Ошибка при вызове getShardDistribution(). Возможно, коллекция не шардирована или пуста.");
}

print("\nТекущий статус шардирования (включая чанки и шарды):");
sh.status({ verbose: true });
EOF