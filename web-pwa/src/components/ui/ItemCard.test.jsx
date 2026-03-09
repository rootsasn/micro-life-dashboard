import { describe, it, expect, vi } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import ItemCard from './ItemCard';

describe('ItemCard', () => {
  it('renders task with checkbox', () => {
    const task = { id: 1, text: 'Test task', completed: false };
    const onToggle = vi.fn();
    const onDelete = vi.fn();

    render(<ItemCard type="task" item={task} onToggle={onToggle} onDelete={onDelete} />);
    
    expect(screen.getByText('Test task')).toBeDefined();
    expect(screen.getByLabelText('Mark complete')).toBeDefined();
  });

  it('renders note with date', () => {
    const note = { id: 1, text: 'Test note', date: new Date().toISOString() };
    const onDelete = vi.fn();

    render(<ItemCard type="note" item={note} onDelete={onDelete} />);
    
    expect(screen.getByText('Test note')).toBeDefined();
  });

  it('renders reminder with timeframe badge', () => {
    const reminder = { id: 1, text: 'Test reminder', timeframe: 'today' };
    const onDelete = vi.fn();

    render(<ItemCard type="reminder" item={reminder} onDelete={onDelete} />);
    
    expect(screen.getByText('Test reminder')).toBeDefined();
    expect(screen.getByText('today')).toBeDefined();
  });

  it('calls onToggle when task checkbox clicked', () => {
    const task = { id: 1, text: 'Test task', completed: false };
    const onToggle = vi.fn();
    const onDelete = vi.fn();

    render(<ItemCard type="task" item={task} onToggle={onToggle} onDelete={onDelete} />);
    
    fireEvent.click(screen.getByLabelText('Mark complete'));
    expect(onToggle).toHaveBeenCalledWith(1);
  });
});
