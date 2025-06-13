## IndexedDB is a local DB
Web browsers support IndexedDB, so no installation is necessary.

However, it can connect to server to transfer and receive information. 

python3 -m http.server 8000

## The db location
chrome://settings/content/all
cd ~/Library/Application\ Support/Google/Chrome/Default/IndexedDB/

## Check DB in the Web Browser

Open Web Browser and open the Developer menu.

## Code
### Buttons and placeholder (output)
```
    <div>
        <button onclick="addRecord()">Add Random Record</button>
        <button onclick="getAllRecords()">Show All Records</button>
        <button onclick="clearAllRecords()">Clear All Records</button>
    </div>
    <div id="output"></div>
```

### Initialization
```javascript
let db;
const dbName = 'recordsDB';
const storeName = 'records';

// Initialize database
const request = indexedDB.open(dbName1);
```        

### Show output
```javascript
// Helper function to show output
function showOutput(message) {
    const output = document.getElementById('output');
    output.innerHTML += `<div>${JSON.stringify(message, null, 2)}</div><hr>`;
}
```

### CRUD
#### Create
```javascript

// choose the collection 
// const storeName = 'records';
function addRecord() {
    const data = {
        foo: Math.random().toString(36).substring(2, 10),
        bar: Math.floor(Math.random() * 1000)
    };
    const transaction = db.transaction([storeName], 'readwrite');
    const store = transaction.objectStore(storeName);
    const request = store.add({ data });
    request.onsuccess = () => {
        showOutput({ message: 'Record added', data });
    };
}
```
