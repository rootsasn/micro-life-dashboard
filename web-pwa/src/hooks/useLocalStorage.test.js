import { describe, it, expect, beforeEach, vi } from 'vitest';
import { renderHook, act, waitFor } from '@testing-library/react';
import { useLocalStorage } from './useLocalStorage';
import { db } from '../lib/database';

// Mock Dexie
vi.mock('dexie-react-hooks', () => ({
  useLiveQuery: (fn) => {
    try {
      return fn() || [];
    } catch {
      return [];
    }
  }
}));

describe('useLocalStorage', () => {
  beforeEach(async () => {
    // Clear all tables before each test
    await db.tasks.clear();
    await db.notes.clear();
    await db.reminders.clear();
    await db.archive.clear();
  });

  it('initializes with empty arrays', () => {
    const { result } = renderHook(() => useLocalStorage());
    
    expect(Array.isArray(result.current.tasks)).toBe(true);
    expect(Array.isArray(result.current.notes)).toBe(true);
    expect(Array.isArray(result.current.reminders)).toBe(true);
  });

  it('provides all CRUD operations', () => {
    const { result } = renderHook(() => useLocalStorage());
    
    expect(typeof result.current.addTask).toBe('function');
    expect(typeof result.current.toggleTask).toBe('function');
    expect(typeof result.current.deleteTask).toBe('function');
    expect(typeof result.current.addNote).toBe('function');
    expect(typeof result.current.deleteNote).toBe('function');
    expect(typeof result.current.addReminder).toBe('function');
    expect(typeof result.current.deleteReminder).toBe('function');
  });

  it('adds task successfully', async () => {
    const { result } = renderHook(() => useLocalStorage());
    
    await act(async () => {
      const success = await result.current.addTask('Test task');
      expect(success).toBe(true);
    });

    const tasks = await db.tasks.toArray();
    expect(tasks.length).toBe(1);
    expect(tasks[0].text).toBe('Test task');
  });

  it('enforces 5 task limit', async () => {
    const { result } = renderHook(() => useLocalStorage());
    
    // Add 5 tasks
    for (let i = 0; i < 5; i++) {
      await act(async () => {
        await result.current.addTask(`Task ${i + 1}`);
      });
    }

    // Try to add 6th task
    await act(async () => {
      const success = await result.current.addTask('Task 6');
      expect(success).toBe(false);
    });

    const tasks = await db.tasks.toArray();
    expect(tasks.length).toBe(5);
  });
});
