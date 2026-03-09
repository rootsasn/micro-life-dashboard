# Database Layer

## database.js

Dexie.js configuration for IndexedDB storage.

### Tables

**tasks**
- id (auto-increment)
- text (string)
- completed (0 or 1)
- createdAt (timestamp)
- updatedAt (timestamp)
- archived (0 or 1)

**notes**
- id (auto-increment)
- text (string)
- date (ISO string)
- createdAt (timestamp)
- archived (0 or 1)

**reminders**
- id (auto-increment)
- text (string)
- timeframe ('today' | 'tomorrow' | 'next week')
- createdAt (timestamp)
- archived (0 or 1)

**archive**
- id (auto-increment)
- type ('task' | 'note' | 'reminder')
- data (original item object)
- archivedAt (timestamp)

### Functions

**archiveOldItems()**
Archives items older than 7 days:
- Completed tasks (based on updatedAt)
- All notes (based on createdAt)
- All reminders (based on createdAt)

Returns: `{ tasksArchived, notesArchived, remindersArchived }`

**initializeDatabase()**
Opens database and runs initial cleanup.

### Offline-First Design
- All data stored locally in IndexedDB
- No network required for CRUD operations
- Survives browser restarts and page refreshes
- Fast queries with indexed fields
