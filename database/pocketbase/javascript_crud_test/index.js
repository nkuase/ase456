import PocketBase from 'pocketbase';
import fs from 'fs/promises';

const email = 'goodbye@gmail.com';
const password = '12345678'
// Initialize PocketBase client
const pb = new PocketBase('http://127.0.0.1:8090');

await pb.collection('users').authWithPassword(email, password);

// Helper to generate random data object
function randomData() {
    return {
        foo: Math.random().toString(36).substring(2, 10),
        bar: Math.floor(Math.random() * 1000)
    };
}

// # 1. Create
// Upload to PocketBase (replace 'records' with your collection name)
async function uploadRecord() {
    // Create a random Record object
    let record = {
        data: randomData(),
    };
    try {
        const created = await pb.collection('records').create(record);
        console.log('Record uploaded:', created);
    } catch (err) {
        console.error('Error uploading record:', err);
    }
}
await uploadRecord();

async function uploadFromJson() {
    try {
        const filePath = './data.json'; // Adjust to your actual file location
        // Read and parse the JSON file
        const fileContent = await fs.readFile(filePath, 'utf-8');
        const records = JSON.parse(fileContent);

        // Loop through each record and create it in PocketBase
        for (const record of records) {
            const created = await pb.collection('records').create(record);
            console.log('Created record:', created);
        }
        console.log('All records imported successfully.');
    } catch (error) {
        console.error('Error importing records:', error);
    }
}
await uploadFromJson();

// # 2. Read
// get the first record
async function getRecord(number = 1, blockSize = 5) {
    try {
        // Replace 'records' with your collection name
        // 1 record per 1 page
        const result = await pb.collection('records').getList(number, blockSize);

        if (result.items.length > 0) {
            const firstRecord = result.items[0];
            return firstRecord;
        } else {
            console.log('No records found.');
        }
    } catch (err) {
        console.error('Error uploading record:', err);
    }
}
const firstRecord = await getRecord();
//console.log("First Record:")
//console.log(firstRecord);

// # 3. Update
async function updateRecord() {
    // example update data
    const data = {
        data: {
            "foo": "P-" + firstRecord.data.foo
        }
    };
    try {
        const updated = await pb.collection('records').update(firstRecord.id, data);
        console.log(updated);
    } catch (err) {
        console.error('Error uploading record:', err);
    }
}
await updateRecord();

// # 4. Delete


const secondRecord = await getRecord(2, 1);

async function deleteRecord() {
    try {
        const deleted = await pb.collection('records').delete(secondRecord.id);
        console.log(`Deleted record: ${deleted.id}`);
    } catch (err) {
        console.error('Error deleting record:', err);
    }
}
await deleteRecord();

// Replace 'records' with your actual collection name
async function deleteAllRecords() {
  let page = 1;
  const perPage = 10; // Adjust as needed for batch size

  while (true) {
    // Fetch a page of records
    const result = await pb.collection('records').getList(page, perPage);

    if (result.items.length === 0) break;

    // Delete each record in the current page
    for (const item of result.items) {
      await pb.collection('records').delete(item.id);
      console.log(`Deleted record: ${item.id}`);
    }

    // If fewer than perPage items returned, we're done
    if (result.items.length < perPage) break;
    // Otherwise, continue to the next page (records shift as you delete)
  }

  console.log('All records deleted.');
}

await deleteAllRecords();
