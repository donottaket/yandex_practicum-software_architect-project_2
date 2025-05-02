#!/bin/bash

# Инициализация бд

docker compose exec -T mongo-config mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config",
    configsvr: true,
    members: [
      { _id : 0, host : "mongo-config:27017" }
    ]
  }
);
EOF

docker compose exec -T mongo-shard-1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "shard-1",
      members: [
        { _id : 0, host : "mongo-shard-1:27018" }
      ]
    }
);
EOF

docker compose exec -T mongo-shard-2 mongosh --port 27019 --quiet <<EOF
rs.initiate(
    {
      _id : "shard-2",
      members: [
        { _id : 1, host : "mongo-shard-2:27019" }
      ]
    }
  );
EOF

docker compose exec -T mongos-router mongosh --port 27020 --quiet <<EOF
sh.addShard( "shard-1/mongo-shard-1:27018");
sh.addShard( "shard-2/mongo-shard-2:27019");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )
EOF

# Инициализация данных

docker compose exec -T mongos-router mongosh --port 27020 --quiet <<EOF
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
EOF