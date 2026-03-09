import { useLiveQuery } from 'dexie-react-hooks';
import { db, archiveOldItems } from '../lib/database';
import { useEffect, useRef } from 'react';

export function useLocalStorage() {
  const archiveTimerRef = useRef(null);

  // Live queries for real-time updates
  const tasks = useLiveQuery(
    () => db.tasks
      .orderBy('createdAt')
      .reverse()
      .limit(5)
      .toArray(),
    []
  ) || [];

  const notes = useLiveQuery(
    () => db.notes
      .orderBy('createdAt')
      .reverse()
      .limit(5)
      .toArray(),
    []
  ) || [];

  const reminders = useLiveQuery(
    () => db.reminders
      .orderBy('createdAt')
      .reverse()
      .limit(2)
      .toArray(),
    []
  ) || [];

  // Auto-archive check every hour
  useEffect(() => {
    const runArchive = async () => {
      const result = await archiveOldItems();
      if (result.tasksArchived + result.notesArchived + result.remindersArchived > 0) {
        console.log('Auto-archived:', result);
      }
    };

    // Run on mount
    runArchive();

    // Set up hourly check
    archiveTimerRef.current = setInterval(runArchive, 60 * 60 * 1000);

    return () => {
      if (archiveTimerRef.current) {
        clearInterval(archiveTimerRef.current);
      }
    };
  }, []);

  // Task operations
  const addTask = async (text) => {
    try {
      const taskCount = await db.tasks.count();
      if (taskCount >= 5) {
        throw new Error('Maximum 5 tasks allowed');
      }

      const now = Date.now();
      await db.tasks.add({
        text: text.trim(),
        completed: 0,
        createdAt: now,
        updatedAt: now,
        archived: 0
      });
      return true;
    } catch (error) {
      console.error('Error adding task:', error);
      return false;
    }
  };

  const toggleTask = async (id) => {
    try {
      const task = await db.tasks.get(id);
      if (!task) return false;

      await db.tasks.update(id, {
        completed: task.completed ? 0 : 1,
        updatedAt: Date.now()
      });
      return true;
    } catch (error) {
      console.error('Error toggling task:', error);
      return false;
    }
  };

  const deleteTask = async (id) => {
    try {
      await db.tasks.delete(id);
      return true;
    } catch (error) {
      console.error('Error deleting task:', error);
      return false;
    }
  };

  // Note operations
  const addNote = async (text) => {
    try {
      const noteCount = await db.notes.count();
      if (noteCount >= 5) {
        throw new Error('Maximum 5 notes allowed');
      }

      const now = Date.now();
      await db.notes.add({
        text: text.trim(),
        date: new Date().toISOString(),
        createdAt: now,
        archived: 0
      });
      return true;
    } catch (error) {
      console.error('Error adding note:', error);
      return false;
    }
  };

  const deleteNote = async (id) => {
    try {
      await db.notes.delete(id);
      return true;
    } catch (error) {
      console.error('Error deleting note:', error);
      return false;
    }
  };

  // Reminder operations
  const addReminder = async (text, timeframe) => {
    try {
      const reminderCount = await db.reminders.count();
      if (reminderCount >= 2) {
        throw new Error('Maximum 2 reminders allowed');
      }

      await db.reminders.add({
        text: text.trim(),
        timeframe,
        createdAt: Date.now(),
        archived: 0
      });
      return true;
    } catch (error) {
      console.error('Error adding reminder:', error);
      return false;
    }
  };

  const deleteReminder = async (id) => {
    try {
      await db.reminders.delete(id);
      return true;
    } catch (error) {
      console.error('Error deleting reminder:', error);
      return false;
    }
  };

  // Manual archive trigger
  const triggerArchive = async () => {
    return await archiveOldItems();
  };

  // Get archive stats
  const getArchiveStats = async () => {
    try {
      const archived = await db.archive.toArray();
      return {
        total: archived.length,
        tasks: archived.filter(a => a.type === 'task').length,
        notes: archived.filter(a => a.type === 'note').length,
        reminders: archived.filter(a => a.type === 'reminder').length
      };
    } catch (error) {
      console.error('Error getting archive stats:', error);
      return { total: 0, tasks: 0, notes: 0, reminders: 0 };
    }
  };

  return {
    // Data
    tasks,
    notes,
    reminders,
    
    // Task operations
    addTask,
    toggleTask,
    deleteTask,
    
    // Note operations
    addNote,
    deleteNote,
    
    // Reminder operations
    addReminder,
    deleteReminder,
    
    // Archive operations
    triggerArchive,
    getArchiveStats
  };
}
