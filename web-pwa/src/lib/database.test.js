import { describe, it, expect, beforeEach } from 'vitest';
import { db, archiveOldItems } from './database';

describe('Database', () => {
  beforeEach(async () => {
    await db.tasks.clear();
    await db.notes.clear();
    await db.reminders.clear();
    await db.archive.clear();
  });

  it('creates database with correct tables', async () => {
    await db.open();
    
    expect(db.tasks).toBeDefined();
    expect(db.notes).toBeDefined();
    expect(db.reminders).toBeDefined();
    expect(db.archive).toBeDefined();
  });

  it('archives old completed tasks', async () => {
    const eightDaysAgo = Date.now() - (8 * 24 * 60 * 60 * 1000);
    
    // Add old completed task
    await db.tasks.add({
      text: 'Old task',
      completed: 1,
      createdAt: eightDaysAgo,
      updatedAt: eightDaysAgo,
      archived: 0
    });

    const result = await archiveOldItems();
    
    expect(result.tasksArchived).toBe(1);
    
    const tasks = await db.tasks.toArray();
    expect(tasks.length).toBe(0);
    
    const archived = await db.archive.toArray();
    expect(archived.length).toBe(1);
    expect(archived[0].type).toBe('task');
  });

  it('does not archive recent tasks', async () => {
    const now = Date.now();
    
    await db.tasks.add({
      text: 'Recent task',
      completed: 1,
      createdAt: now,
      updatedAt: now,
      archived: 0
    });

    const result = await archiveOldItems();
    
    expect(result.tasksArchived).toBe(0);
    
    const tasks = await db.tasks.toArray();
    expect(tasks.length).toBe(1);
  });

  it('archives old notes', async () => {
    const eightDaysAgo = Date.now() - (8 * 24 * 60 * 60 * 1000);
    
    await db.notes.add({
      text: 'Old note',
      date: new Date(eightDaysAgo).toISOString(),
      createdAt: eightDaysAgo,
      archived: 0
    });

    const result = await archiveOldItems();
    
    expect(result.notesArchived).toBe(1);
  });
});
