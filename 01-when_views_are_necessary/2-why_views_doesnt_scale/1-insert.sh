#!/bin/bash

# Configuración de la base de datos
DB_USER="postgres"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="postgres"
DB_HOST="localhost"
DB_PORT="5432"

# Conéctate a PostgreSQL usando psql con host y puerto
export PGPASSWORD=$DB_PASS

# Número de usuarios, posts por usuario y likes por post
NUM_USERS=1000
MAX_POSTS_PER_USER=100
MAX_LIKES_PER_POST=200

printf "Starting\n"

for i in $(seq 1 $NUM_USERS); do
  echo "($i/$NUM_USERS) Creating user"

  USER_ID=$(uuidgen)
  NAME="User_$i"
  EMAIL="user_$i@example.com"
  PROFILE_PICTURE="https://example.com/pictures/user_$i.jpg"
  STATUS="active"

  psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -c "INSERT INTO users (id, name, email, profile_picture, status) VALUES ('$USER_ID', '$NAME', '$EMAIL', '$PROFILE_PICTURE', '$STATUS');" > /dev/null

  NUM_POSTS=$(($RANDOM % MAX_POSTS_PER_USER + 1))

  echo "  → Creating $NUM_POSTS random posts"
  for j in $(seq 1 $NUM_POSTS); do
    echo "    ($j/$NUM_POSTS) Post created"
    POST_ID=$(uuidgen)
    CONTENT="This is post $j of user $i"
    CREATED_AT=$(date +'%Y-%m-%d %H:%M:%S')

    psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -c "INSERT INTO posts (id, user_id, content, created_at) VALUES ('$POST_ID', '$USER_ID', '$CONTENT', '$CREATED_AT');" > /dev/null

    NUM_LIKES=$(($RANDOM % MAX_LIKES_PER_POST + 1))

    echo "    → Creating $NUM_LIKES random posts likes"
    for k in $(seq 1 $NUM_LIKES); do
      echo "    ($k/$NUM_LIKES) Post liked"

      LIKE_ID=$(uuidgen)
      LIKED_AT=$(date +'%Y-%m-%d %H:%M:%S')
      # Seleccionar un usuario al azar para el like
      LIKER_ID=$(psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -t -c "SELECT id FROM users ORDER BY RANDOM() LIMIT 1;" | sed 's/ //g')

      psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -c "INSERT INTO post_likes (id, post_id, user_id, liked_at) VALUES ('$LIKE_ID', '$POST_ID', '$LIKER_ID', '$LIKED_AT');" > /dev/null
    done
  done
done

echo "Inserción de datos finalizada."
