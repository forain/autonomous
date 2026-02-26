#!/bin/bash
mongo admin <<EOF
db.getSiblingDB("unifi").createUser({
  user: "unifi",
  pwd: "${MONGO_PASS}",
  roles: [{ role: "dbOwner", db: "unifi" }]
});
db.getSiblingDB("unifi_stat").createUser({
  user: "unifi",
  pwd: "${MONGO_PASS}",
  roles: [{ role: "dbOwner", db: "unifi_stat" }]
});
EOF
