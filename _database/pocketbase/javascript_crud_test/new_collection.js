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
  