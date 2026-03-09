# Hooks Documentation

## useLocalStorage

Main hook for managing tasks, notes, and reminders with Dexie.js IndexedDB.

### Features
- Real-time updates with `useLiveQuery`
- Auto-archive items older than 7 days
- Enforces limits: 5 tasks, 5 notes, 2 reminders
- Offline-first with IndexedDB persistence

### Usage
```jsx
const {
  tasks, notes, reminders,
  addTask, toggleTask, deleteTask,
  addNote, deleteNote,
  addReminder, deleteReminder,
  triggerArchive, getArchiveStats
} = useLocalStorage();
```

### Auto-Archive
- Runs on mount and every hour
- Archives completed tasks older than 7 days
- Archives notes older than 7 days
- Archives reminders older than 7 days

## useOfflineSync

Manages online/offline status and data synchronization.

### Features
- Detects online/offline status
- Auto-syncs when coming back online
- Shows sync status indicator

### Usage
```jsx
const { isOnline, syncStatus, lastSyncTime, manualSync } = useOfflineSync();
```

## useArchive

Access and manage archived items.

### Features
- View all archived items
- Restore items from archive
- Permanently delete archived items
- Clear entire archive

### Usage
```jsx
const {
  archivedItems,
  getArchivedByType,
  restoreItem,
  deleteArchivedItem,
  clearArchive
} = useArchive();
```
