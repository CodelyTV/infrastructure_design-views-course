#!/bin/bash

DB_USER="codely"
DB_PASS="C0d3lyS3cr3t"
DB_SERVICE="FREEPDB1"
DB_HOST="localhost"
DB_PORT="1521"

declare -a USER_IDS

NUM_USERS=2
MAX_POSTS_PER_USER=1
MAX_LIKES_PER_POST=2

printf "Starting\n\n"

CONNECTION_STRING="$DB_USER/$DB_PASS@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=$DB_HOST)(Port=$DB_PORT))(CONNECT_DATA=(SERVICE_NAME=$DB_SERVICE)))"
DOCKER_COMMAND_PREFIX="docker exec -i codely_oracle_rrss_database sqlplus -s $CONNECTION_STRING"

for i in $(seq 1 $NUM_USERS); do
  NUM_POSTS=$(($RANDOM % MAX_POSTS_PER_USER + 1))

  echo "($i/$NUM_USERS) Generating user with $NUM_POSTS posts"

  USER_ID=$(uuidgen)
  USER_IDS+=($USER_ID)
  NAME="User_$i"
  EMAIL="user_$i@example.com"
  PROFILE_PICTURE="https://example.com/pictures/user_$i.jpg"
  STATUS="active"

  # Insert user
  echo "INSERT INTO users (id, name, email, profile_picture, status) VALUES (HEXTORAW(REPLACE('$USER_ID', '-', '')), '$NAME', '$EMAIL', '$PROFILE_PICTURE', '$STATUS');" | $DOCKER_COMMAND_PREFIX

  for j in $(seq 1 $NUM_POSTS); do
    NUM_LIKES=$(($RANDOM % MAX_LIKES_PER_POST + 1))
    echo "  → Generating post n° $j with $NUM_LIKES likes"

    POST_ID=$(uuidgen)
    CONTENT="This is post $j of user $i"
    CREATED_AT="TO_DATE('2025-03-04 15:30:45', 'YYYY-MM-DD HH24:MI:SS')"

    # Insert post
    echo "INSERT INTO posts (id, user_id, content, created_at) VALUES (HEXTORAW(REPLACE('$POST_ID', '-', '')), HEXTORAW(REPLACE('$USER_ID', '-', '')), '$CONTENT', $CREATED_AT);" | $DOCKER_COMMAND_PREFIX

    for k in $(seq 1 $NUM_LIKES); do
      LIKE_ID=$(uuidgen)
      LIKED_AT="TO_DATE('2025-03-05 15:30:45', 'YYYY-MM-DD HH24:MI:SS')"
      LIKER_ID=${USER_IDS[$RANDOM % ${#USER_IDS[@]}]}

      # Insert post like
      echo "INSERT INTO post_likes (id, post_id, user_id, liked_at) VALUES (HEXTORAW(REPLACE('$LIKE_ID', '-', '')), HEXTORAW(REPLACE('$POST_ID', '-', '')), HEXTORAW(REPLACE('$LIKER_ID', '-', '')), $LIKED_AT);" | $DOCKER_COMMAND_PREFIX
    done
  done
done

# Commit changes
echo "COMMIT;" | $DOCKER_COMMAND_PREFIX

echo "Done!"
