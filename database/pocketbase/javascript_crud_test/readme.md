# 1. Installation
## Install PocketBase

Visit "https://pub.dev/packages/pocketbase" and check the code 

Install node and dart (if you don't have them in your system)

## Install dependenciese for node
npm install 

## 

# 2. Run Pocketbase

For example, if you are in the `javascript_crud_test` directory and database is in the parent's db directory. 

## Create super user
`pocketbase --dir="../db" superuser upsert EMAIL PASSWORD`
For example, 
```
pocketbase --dir="../db" superuser upsert hello@gmail.com 12345678

Successfully saved superuser "hello@gmail.com"!
```
## Start Server

`pocketbase serve --dir="Your DB Directory`

```
pocketbase serve --dir="../db"
2025/06/07 19:11:48 Server started at http://127.0.0.1:8090
├─ REST API:  http://127.0.0.1:8090/api/
└─ Dashboard: http://127.0.0.1:8090/_/
```

## Login
Use your browser to login. Use the credentials (superuser) you made. 

# 3. Create Collection in Pockebase.
Use web browser to login 

```
http://localhost:8090/_/#/login
```

# 4. Configuration 
## Create a user
users (collection) at the left sidebar -> + New record -> give email and password.
For example, I create the goodbye@gmail.com/12345678.

Copy the id of the user, for example, 6gy70y404py67o2

## Create a collection manually

+ New collection > name > field > API Rules
For the API rules, it chooses who can do what.

Give the following information (replace the id) to give access priviledge. 
```
@request.auth.id = "abc123xyz"

@request.auth.id IN ["abc123xyz", "user2id", "user3id"]
```

## Create a collection programmatically
Use the `new_collection.js` to create a collection. 

```javascript
import PocketBase from 'pocketbase';

const pb = new PocketBase('http://127.0.0.1:8090');

// Authenticate as a superuser (replace with your credentials)
await pb.collection('_superusers').authWithPassword('hello@gmail.com', '12345678');

const newCollection = await pb.collections.create({
    name: 'records', // Name of your collection
    type: 'base',            // 'base', 'auth', or 'view'
    fields: [
      {
        name: 'data',
        type: 'json',
        required: true,
        min: 3,
      }
    ],
    // Optional: set API rules
    createRule: '@request.auth.id != ""',
    updateRule: '@request.auth.id != ""',
    deleteRule: '@request.auth.id != ""',
    listRule: '',
    viewRule: '',
  });
  console.log('Created collection:', newCollection);
```  


## Etc
We can get the information using GET function in the browser or similar tools. Replace <c> with the collection name.

```
GET /api/collections/<c>/records
```

To make this possible, set the rule so that anyone can read the record (empty the rules).