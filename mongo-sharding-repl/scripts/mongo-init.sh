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

docker compose exec -T mongo-rs-0-1 mongosh --port 27018 --quiet <<EOF
rs.initiate(
    {
      _id : "rs0",
      members: [
        {_id : 0, host : "mongo-rs-0-1:27018"},
        {_id : 1, host : "mongo-rs-0-2:27019"},
        {_id : 2, host : "mongo-rs-0-3:27020"}
      ]
    }
);
EOF

docker compose exec -T mongo-rs-1-1 mongosh --port 27021 --quiet <<EOF
rs.initiate(
    {
      _id : "rs1",
      members: [
        { _id : 0, host : "mongo-rs-1-1:27021" },
        { _id : 1, host : "mongo-rs-1-2:27022" },
        { _id : 2, host : "mongo-rs-1-3:27023" }
      ]
    }
  );
EOF

docker compose exec -T mongos-router mongosh --port 27024 --quiet <<EOF
sh.addShard("rs0/mongo-rs-0-1:27018,mongo-rs-0-2:27019,mongo-rs-0-3:27020");
sh.addShard("rs1/mongo-rs-1-1:27021,mongo-rs-1-2:27022,mongo-rs-1-3:27023");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" })
EOF

# Инициализация данных

docker compose exec -T mongos-router mongosh --port 27024 --quiet <<EOF
use somedb;
for(var i = 0; i < 1000; i++) db.helloDoc.insert({age:i, name:"ly"+i})
EOF