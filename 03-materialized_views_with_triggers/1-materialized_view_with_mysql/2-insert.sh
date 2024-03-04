#!/bin/bash

DB_USER="codely"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="rrss"
DB_HOST="127.0.0.1"
DB_PORT="3306"

declare -a USER_IDS

NUM_USERS=100
MAX_POSTS_PER_USER=10
MAX_LIKES_PER_POST=200

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

  INSERTS="INSERT INTO users (id, name, email, profile_picture, status) VALUES ('$USER_ID', '$NAME', '$EMAIL', '$PROFILE_PICTURE', '$STATUS');"

  for j in $(seq 1 $NUM_POSTS); do
    NUM_LIKES=$(($RANDOM % MAX_LIKES_PER_POST + 1))

    echo "  → Generating post n° $j with $NUM_LIKES likes"

    POST_ID=$(uuidgen)
    CONTENT="This is post $j of user $i"
    CREATED_AT="2025-03-04 15:30:45"

    INSERTS+="INSERT INTO posts (id, user_id, content, created_at) VALUES ('$POST_ID', '$USER_ID', '$CONTENT', '$CREATED_AT');"

    for k in $(seq 1 $NUM_LIKES); do
      LIKE_ID=$(uuidgen)
      LIKED_AT="2025-03-05 15:30:45"
      LIKER_ID=${USER_IDS[$RANDOM % ${#USER_IDS[@]}]}

      INSERTS+="INSERT INTO post_likes (id, post_id, user_id, liked_at) VALUES ('$LIKE_ID', '$POST_ID', '$LIKER_ID', '$LIKED_AT');"
    done
  done

  MYSQL_PWD=$DB_PASS mysql -u $DB_USER -h $DB_HOST -P $DB_PORT -D $DB_NAME -e "START TRANSACTION; $INSERTS COMMIT;" > /dev/null
done

echo "Dooone!"
