#!/bin/bash

# Get last and new passwords
LAST_PASS=$(cat /var/lib/mongodb/lastPass)

set -e
NEW_PASS=$(cat /newPass)

# Create any missing directories
mkdir -p /var/lib/mongodb/data/
mkdir -p /var/lib/mongodb/logs/
mkdir -p /var/lib/mongodb/pids/

# Update password if not the same
if [ "$LAST_PASS" != "$NEW_PASS" ]; then

  echo Starting mongod in standalone mode
  /usr/bin/mongod \
    --port 27017 \
    --logpath /var/lib/mongodb/logs/mongod.log \
    --bind_ip 127.0.0.1 \
    --pidfilepath /var/lib/mongodb/pids/mongod.pid \
    --nounixsocket \
    --fork \
    --storageEngine wiredTiger \
    --dbpath /var/lib/mongodb/data/ \
    --directoryperdb
  APP_PID=$(cat /var/lib/mongodb/pids/mongod.pid)
  echo mongod is running locally with pid $APP_PID
  
  echo Update the password
  CHANGE_PASS_JS=$(mktemp --suffix=.js)
  cat > $CHANGE_PASS_JS << _EOF
    db.disableFreeMonitoring()
  
    var existingUser = db.getUser("root")
    if (existingUser == undefined) {
      db.createUser(
        {
          user: "root",
          pwd: "$NEW_PASS",
          roles: [ "root" ]
        }
      )
    } else {
      db.changeUserPassword("root", "$NEW_PASS")
    }
_EOF
  /usr/bin/mongo admin $CHANGE_PASS_JS
  rm $CHANGE_PASS_JS
  
  echo Stop mongod and wait for it to be stopped
  kill $APP_PID
  while [ -d /proc/$APP_PID ]; do
    sleep 1s
    echo .
  done

  echo $NEW_PASS > /var/lib/mongodb/lastPass
fi

# Start
echo Starting
  /usr/bin/mongod \
    --port 27017 \
    --logpath /var/lib/mongodb/logs/mongod.log \
    --bind_ip_all \
    --pidfilepath /var/lib/mongodb/pids/mongod.pid \
    --nounixsocket \
    --fork \
    --auth \
    --storageEngine wiredTiger \
    --dbpath /var/lib/mongodb/data/ \
    --directoryperdb
APP_PID=$(cat /var/lib/mongodb/pids/mongod.pid)
echo Started


echo mongod is running with pid $APP_PID and is ready to serve
while [ -d /proc/$APP_PID ]; do
  sleep 5s
done
