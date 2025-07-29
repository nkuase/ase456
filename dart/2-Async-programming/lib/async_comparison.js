function fetchUserData(userId) {
  return new Promise((resolve, reject) => {
    if (userId > 0) {
      // Success case
      setTimeout(() => {
        // Promise succeeds with this value
        resolve("John Doe"); 
      }, 1000);
    } else {
      // Failure case 
      // Promise fails with this error 
      reject(new Error("Invalid user ID")); 
    }
  });
}

async function main() {
  try {
    const user = await fetchUserData(123); //   Gets "John Doe"
    console.log(user);
  } catch (error) {
    console.log(error.message); // Handles any   rejection
  }
}  
main()