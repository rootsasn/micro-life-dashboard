import Dexie from 'dexie';

export const db = new Dexie('MicroLifeDB');

db.version(1).stores({
  tasks: '++id, text, completed, createdAt, updatedAt, archived',
  notes: '++id, text, date, createdAt, archived',
  reminders: '++id, text, timeframe, createdAt, archived',
  archive: '++id, type, data, archivedAt'
});

// Auto-archive items older than 7 days
export async function archiveOldItems() {
  const sevenDaysAgo = Date.now() - (7 * 24 * 60 * 60 * 1000);
  
  try {
    // Archive old completed tasks
    const oldTasks = await db.tasks
      .where('completed').equals(1)
      .and(task => task.updatedAt < sevenDaysAgo)
      .toArray();
    
    if (oldTasks.length > 0) {
      await db.archive.bulkAdd(
        oldTasks.map(task => ({
          type: 'task',
          data: task,
          archivedAt: Date.now()
        }))
      );
      await db.tasks.bulkDelete(oldTasks.map(t => t.id));
    }

    // Archive old notes
    const oldNotes = await db.notes
      .where('createdAt').below(sevenDaysAgo)
      .toArray();
    
    if (oldNotes.length > 0) {
      await db.archive.bulkAdd(
        oldNotes.map(note => ({
          type: 'note',
          data: note,
          archivedAt: Date.now()
        }))
      );
      await db.notes.bulkDelete(oldNotes.map(n => n.id));
    }

    // Archive old reminders
    const oldReminders = await db.reminders
      .where('createdAt').below(sevenDaysAgo)
      .toArray();
    
    if (oldReminders.length > 0) {
      await db.archive.bulkAdd(
        oldReminders.map(reminder => ({
          type: 'reminder',
          data: reminder,
          archivedAt: Date.now()
        }))
      );
      await db.reminders.bulkDelete(oldReminders.map(r => r.id));
    }

    return {
      tasksArchived: oldTasks.length,
      notesArchived: oldNotes.length,
      remindersArchived: oldReminders.length
    };
  } catch (error) {
    console.error('Error archiving old items:', error);
    return { tasksArchived: 0, notesArchived: 0, remindersArchived: 0 };
  }
}

// Initialize database and run cleanup
export async function initializeDatabase() {
  try {
    await db.open();
    await archiveOldItems();
    return true;
  } catch (error) {
    console.error('Failed to initialize database:', error);
    return false;
  }
}
