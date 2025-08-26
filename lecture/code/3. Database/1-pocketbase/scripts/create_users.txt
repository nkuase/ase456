POCKET_BASE_PATH=$HOME/pocketbase
POCKET_BASE=$POCKET_BASE_PATH/pocketbase

$POCKET_BASE superuser upsert admin@example.com admin123456

curl -X POST http://127.0.0.1:8090/api/collections/users/records \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password","passwordConfirm":"password"}'