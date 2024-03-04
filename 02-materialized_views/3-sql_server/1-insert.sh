#!/bin/bash

DB_USER="sa"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="master"
DB_HOST="localhost"
DB_PORT="1433"
CONTAINER_NAME="codely_sqlserver_rrss_database"
SCHEMA_NAME="rrss"

declare -a USER_IDS

NUM_USERS=100
MAX_POSTS_PER_USER=10
MAX_LIKES_PER_POST=50

printf "Starting\n\n"

for i in $(seq 1 $NUM_USERS); do
  NUM_POSTS=$(($RANDOM % MAX_POSTS_PER_USER + 1))

  echo "($i/$NUM_USERS) Generating user with $NUM_POSTS posts"

  USER_ID=$(uuidgen)

  USER_IDS+=($USER_ID)
  NAME="User_$i"
  EMAIL="user_$i@example.com"
  PROFILE_PICTURE="https://example.com/pictures/user_$i.jpg"
  STATUS="active"

  INSERTS="INSERT INTO $SCHEMA_NAME.users (id, name, email, profile_picture, status) VALUES ('$USER_ID', '$NAME', '$EMAIL', '$PROFILE_PICTURE', '$STATUS');"

  for j in $(seq 1 $NUM_POSTS); do
    NUM_LIKES=$(($RANDOM % MAX_LIKES_PER_POST + 1))

    echo "  → Generating post n° $j with $NUM_LIKES likes"

    POST_ID=$(uuidgen)
    CONTENT="This is post $j of user $i"
    CREATED_AT="2025-03-04T15:30:45"

    INSERTS+="INSERT INTO $SCHEMA_NAME.posts (id, user_id, content, created_at) VALUES ('$POST_ID', '$USER_ID', '$CONTENT', '$CREATED_AT');"

    for k in $(seq 1 $NUM_LIKES); do
      LIKE_ID=$(uuidgen)
      LIKED_AT="2025-03-05T15:30:45"
      LIKER_ID=${USER_IDS[$RANDOM % ${#USER_IDS[@]}]}

      INSERTS+="INSERT INTO $SCHEMA_NAME.post_likes (id, post_id, user_id, liked_at) VALUES ('$LIKE_ID', '$POST_ID', '$LIKER_ID', '$LIKED_AT');"
    done
  done

  docker exec -i $CONTAINER_NAME bash -c "/opt/mssql-tools/bin/sqlcmd -S localhost -I -U $DB_USER -P $DB_PASS -d $DB_NAME -Q \"$INSERTS\"" > /dev/null

done

echo "Dooone!"
