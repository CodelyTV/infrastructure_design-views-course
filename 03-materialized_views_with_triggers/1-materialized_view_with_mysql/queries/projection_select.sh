DB_USER="codely"
DB_PASS="C0d3lyS3cr3t"
DB_NAME="rrss"
DB_HOST="127.0.0.1"
DB_PORT="3306"

MYSQL_PWD=$DB_PASS mysql -u $DB_USER -h $DB_HOST -P $DB_PORT -D $DB_NAME -e "SELECT * FROM posts_projection;"
