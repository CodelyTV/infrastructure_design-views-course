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

printf "Starting\n\n"

for i in $(seq 1 $NUM_USERS); do
  echo "($i/$NUM_USERS) Generating user, posts and post likes"

  USER_ID=$(uuidgen)
  NAME="User_$i"
  EMAIL="user_$i@example.com"
  PROFILE_PICTURE="https://example.com/pictures/user_$i.jpg"
  STATUS="active"

  # Preparar inserción del usuario
  INSERTS="INSERT INTO users (id, name, email, profile_picture, status) VALUES ('$USER_ID', '$NAME', '$EMAIL', '$PROFILE_PICTURE', '$STATUS');"

  NUM_POSTS=$(($RANDOM % MAX_POSTS_PER_USER + 1))

  for j in $(seq 1 $NUM_POSTS); do
    echo "    ($j/$NUM_POSTS) Generating post"
    POST_ID=$(uuidgen)
    CONTENT="This is post $j of user $i"
    CREATED_AT=$(date +'%Y-%m-%d %H:%M:%S')

    # Preparar inserción de la publicación
    INSERTS+="INSERT INTO posts (id, user_id, content, created_at) VALUES ('$POST_ID', '$USER_ID', '$CONTENT', '$CREATED_AT');"

    NUM_LIKES=$(($RANDOM % MAX_LIKES_PER_POST + 1))

    for k in $(seq 1 $NUM_LIKES); do
      echo "      ($k/$NUM_LIKES) Generating post likes"

      LIKE_ID=$(uuidgen)
      LIKED_AT=$(date +'%Y-%m-%d %H:%M:%S')
      LIKER_ID=$USER_ID  # Simplicidad: el usuario se gusta su propio post, ajusta según sea necesario

      # Preparar inserción de likes
      INSERTS+="INSERT INTO post_likes (id, post_id, user_id, liked_at) VALUES ('$LIKE_ID', '$POST_ID', '$LIKER_ID', '$LIKED_AT');"
    done
  done

echo "going to insert"
  # Ejecutar todas las inserciones en una transacción
  psql -U $DB_USER -h $DB_HOST -p $DB_PORT -d $DB_NAME -c "BEGIN; $INSERTS COMMIT;" > /dev/null
  echo "User, posts, and likes created"
done

echo "Data insertion completed."
