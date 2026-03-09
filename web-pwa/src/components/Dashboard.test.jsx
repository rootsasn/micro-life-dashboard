import { describe, it, expect, vi } from 'vitest';
import { render, screen } from '@testing-library/react';
import Dashboard from './Dashboard';

vi.mock('../hooks/useLocalStorage', () => ({
  useLocalStorage: () => ({
    tasks: [],
    notes: [],
    reminders: [],
    addTask: vi.fn(),
    toggleTask: vi.fn(),
    deleteTask: vi.fn(),
    addNote: vi.fn(),
    deleteNote: vi.fn(),
    addReminder: vi.fn(),
    deleteReminder: vi.fn()
  })
}));

describe('Dashboard', () => {
  it('renders all sections', () => {
    render(<Dashboard />);
    expect(screen.getByText('Tasks')).toBeDefined();
    expect(screen.getByText('Notes')).toBeDefined();
    expect(screen.getByText('Reminders')).toBeDefined();
  });

  it('shows empty states when no items', () => {
    render(<Dashboard />);
    expect(screen.getByText('No tasks yet')).toBeDefined();
    expect(screen.getByText('No notes yet')).toBeDefined();
    expect(screen.getByText('No reminders yet')).toBeDefined();
  });
});
