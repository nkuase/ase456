#!/bin/bash

# Firebase CLI Setup Demo Script
# Educational script to demonstrate Firebase CLI collection creation

echo "🔥 Firebase CLI Collection Creation Demo"
echo "=" | tr ' ' '=' | head -c 50; echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}📋 Step: $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${PURPLE}💡 $1${NC}"
}

# Check if Firebase CLI is installed
check_firebase_cli() {
    print_step "Checking Firebase CLI installation"
    
    if command -v firebase &> /dev/null; then
        local version=$(firebase --version)
        print_success "Firebase CLI is installed (version: $version)"
        return 0
    else
        print_error "Firebase CLI is not installed"
        print_info "Install with: npm install -g firebase-tools"
        return 1
    fi
}

# Check if user is logged in
check_firebase_auth() {
    print_step "Checking Firebase authentication"
    
    if firebase projects:list &> /dev/null; then
        print_success "You are logged in to Firebase"
        echo "Available projects:"
        firebase projects:list 2>/dev/null || echo "No projects found"
        return 0
    else
        print_warning "You are not logged in to Firebase"
        print_info "Login with: firebase login"
        return 1
    fi
}

# Create sample data files
create_sample_data() {
    print_step "Creating sample data files"
    
    # Create JSON data file
    cat > sample-collections.json << 'EOF'
{
  "foobars": {
    "demo1": {
      "foo": "Hello CLI",
      "bar": 42,
      "createdAt": "2024-01-15T10:00:00Z",
      "source": "command-line"
    },
    "demo2": {
      "foo": "Firebase Power",
      "bar": 2024,
      "createdAt": "2024-01-15T10:01:00Z",
      "source": "automation"
    },
    "demo3": {
      "foo": "DevOps Ready",
      "bar": 100,
      "createdAt": "2024-01-15T10:02:00Z",
      "source": "script"
    }
  },
  "students": {
    "student1": {
      "name": "Alice Johnson",
      "email": "alice@university.edu",
      "major": "Computer Science",
      "year": 3,
      "gpa": 3.8
    },
    "student2": {
      "name": "Bob Chen",
      "email": "bob@university.edu", 
      "major": "Software Engineering",
      "year": 2,
      "gpa": 3.6
    }
  },
  "courses": {
    "ase456": {
      "title": "Database Systems",
      "code": "ASE456",
      "credits": 3,
      "instructor": "Prof. Smith",
      "enrolled": 45
    },
    "ase123": {
      "title": "Software Engineering Principles",
      "code": "ASE123", 
      "credits": 4,
      "instructor": "Prof. Johnson",
      "enrolled": 38
    }
  }
}
EOF

    # Create Node.js import script
    cat > import-collections.js << 'EOF'
const admin = require('firebase-admin');
const fs = require('fs');

// Initialize Firebase Admin (you'll need to set up service account)
// For demo purposes, this shows the structure
console.log('📚 Firebase Collection Import Script');
console.log('=====================================');

async function importCollections() {
  try {
    // Note: In real usage, you would initialize with service account:
    // admin.initializeApp({
    //   credential: admin.credential.cert(serviceAccount)
    // });
    
    console.log('📖 Reading sample data...');
    const data = JSON.parse(fs.readFileSync('sample-collections.json', 'utf8'));
    
    console.log('📊 Collections to import:');
    Object.keys(data).forEach(collection => {
      const docCount = Object.keys(data[collection]).length;
      console.log(`   • ${collection}: ${docCount} documents`);
    });
    
    console.log('\n💡 To actually import this data:');
    console.log('   1. Set up Firebase service account');
    console.log('   2. Initialize admin.firestore()');
    console.log('   3. Use batch operations to import data');
    console.log('   4. Run: node import-collections.js');
    
    console.log('\n🔧 Example import code:');
    console.log(`
    const db = admin.firestore();
    const batch = db.batch();
    
    Object.entries(data).forEach(([collectionName, documents]) => {
      Object.entries(documents).forEach(([docId, docData]) => {
        const docRef = db.collection(collectionName).doc(docId);
        batch.set(docRef, {
          ...docData,
          importedAt: admin.firestore.FieldValue.serverTimestamp()
        });
      });
    });
    
    await batch.commit();
    console.log('✅ Import complete!');
    `);
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

importCollections();
EOF

    # Create Firebase rules file
    cat > demo-firestore.rules << 'EOF'
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Educational demo rules - VERY PERMISSIVE
    // ⚠️ DO NOT use in production!
    
    // Allow all reads and writes for demo purposes
    match /{document=**} {
      allow read, write: if true;
    }
    
    // Example of more restrictive rules for reference:
    // match /students/{studentId} {
    //   allow read: if true;
    //   allow write: if request.auth != null;
    // }
    
    // match /courses/{courseId} {
    //   allow read: if true;
    //   allow write: if request.auth != null && 
    //     request.auth.token.role == 'instructor';
    // }
  }
}
EOF

    print_success "Created sample data files:"
    echo "   📄 sample-collections.json (data to import)"
    echo "   📄 import-collections.js (import script)"  
    echo "   📄 demo-firestore.rules (security rules)"
}

# Create Firebase emulator demo
create_emulator_demo() {
    print_step "Creating emulator configuration"
    
    cat > firebase.json << 'EOF'
{
  "firestore": {
    "rules": "demo-firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "emulators": {
    "firestore": {
      "port": 8080
    },
    "ui": {
      "enabled": true,
      "port": 4000
    }
  }
}
EOF

    cat > firestore.indexes.json << 'EOF'
{
  "indexes": [
    {
      "collectionGroup": "students",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "major", "order": "ASCENDING"},
        {"fieldPath": "gpa", "order": "DESCENDING"}
      ]
    },
    {
      "collectionGroup": "courses", 
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "credits", "order": "ASCENDING"},
        {"fieldPath": "enrolled", "order": "DESCENDING"}
      ]
    }
  ],
  "fieldOverrides": []
}
EOF

    print_success "Created Firebase configuration files"
}

# Show CLI commands
show_cli_commands() {
    print_step "Essential Firebase CLI Commands"
    
    echo "🔧 Setup Commands:"
    echo "   firebase login                    # Login to Firebase"
    echo "   firebase init                     # Initialize project"
    echo "   firebase use --add               # Add/select project"
    echo ""
    echo "🔥 Emulator Commands:"
    echo "   firebase emulators:start         # Start all emulators"
    echo "   firebase emulators:start --only firestore  # Firestore only"
    echo "   firebase emulators:kill          # Stop emulators"
    echo ""
    echo "📊 Data Commands:"
    echo "   firebase firestore:delete --all-collections  # Clear all data"
    echo "   firebase firestore:export <path>             # Export data"
    echo "   firebase firestore:import <path>             # Import data"
    echo ""
    echo "🚀 Deployment Commands:"
    echo "   firebase deploy                              # Deploy everything"
    echo "   firebase deploy --only firestore:rules      # Deploy rules only"
    echo "   firebase deploy --only firestore:indexes    # Deploy indexes only"
}

# Show tutorial access
show_tutorial_info() {
    print_step "Tutorial Resources"
    
    echo "📚 Available tutorials:"
    echo "   📖 Complete CLI Tutorial: doc/firebase_cli_tutorial.md"
    echo "   🎯 Firebase CRUD Tutorial: doc/firebase_tutorial.md" 
    echo ""
    echo "🎥 To view tutorials:"
    echo "   # Using Marp (if installed)"
    echo "   npx @marp-team/marp-cli doc/firebase_cli_tutorial.md --html"
    echo ""
    echo "   # Or view directly in any markdown viewer"
    echo "   code doc/firebase_cli_tutorial.md"
    echo ""
    echo "🌐 Open in browser:"
    echo "   # Convert to HTML and open"
    echo "   npx @marp-team/marp-cli doc/firebase_cli_tutorial.md --html --output tutorial.html"
    echo "   open tutorial.html"
}

# Create package.json for dependencies
create_package_json() {
    print_step "Creating package.json for dependencies"
    
    cat > package.json << 'EOF'
{
  "name": "firebase-cli-demo",
  "version": "1.0.0",
  "description": "Educational demo for Firebase CLI collection creation",
  "main": "import-collections.js",
  "scripts": {
    "import": "node import-collections.js",
    "emulator": "firebase emulators:start",
    "deploy": "firebase deploy",
    "tutorial": "npx @marp-team/marp-cli doc/firebase_cli_tutorial.md --html --output tutorial.html && open tutorial.html"
  },
  "keywords": ["firebase", "firestore", "cli", "education"],
  "author": "University Database Course",
  "license": "MIT",
  "devDependencies": {
    "firebase-admin": "^11.11.0",
    "@marp-team/marp-cli": "^3.4.0"
  }
}
EOF

    print_success "Created package.json"
    print_info "Run 'npm install' to install dependencies"
}

# Main execution
main() {
    echo "🎓 Firebase CLI Collection Creation - Educational Demo"
    echo ""
    
    # Run all setup steps
    create_sample_data
    echo ""
    
    create_emulator_demo
    echo ""
    
    create_package_json
    echo ""
    
    check_firebase_cli
    echo ""
    
    check_firebase_auth
    echo ""
    
    show_cli_commands
    echo ""
    
    show_tutorial_info
    echo ""
    
    print_success "🎉 Demo setup complete!"
    echo ""
    echo "📋 Next steps:"
    echo "   1. Install dependencies: npm install"
    echo "   2. Login to Firebase: firebase login"
    echo "   3. Initialize project: firebase init"
    echo "   4. Start emulators: firebase emulators:start"
    echo "   5. View tutorial: doc/firebase_cli_tutorial.md"
    echo ""
    echo "🔗 Quick links:"
    echo "   • Firebase Console: https://console.firebase.google.com"
    echo "   • Emulator UI: http://localhost:4000 (after starting emulators)"
    echo "   • Documentation: https://firebase.google.com/docs/cli"
}

# Run the demo setup
main
