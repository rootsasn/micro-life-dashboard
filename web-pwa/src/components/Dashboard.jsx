import { useState } from 'react';
import { useLocalStorage } from '../hooks/useLocalStorage';
import ItemCard from './ui/ItemCard';
import AddModal from './ui/AddModal';
import OfflineIndicator from './ui/OfflineIndicator';
import SyncIndicator from './ui/SyncIndicator';
import InstallPrompt from './ui/InstallPrompt';
import UpdatePrompt from './ui/UpdatePrompt';

function Dashboard() {
  const { 
    tasks, 
    notes, 
    reminders, 
    addTask, 
    toggleTask, 
    deleteTask, 
    addNote, 
    deleteNote, 
    addReminder, 
    deleteReminder 
  } = useLocalStorage();
  
  const [isModalOpen, setIsModalOpen] = useState(false);

  const handleAdd = (type, text, timeframe) => {
    if (type === 'task') {
      addTask(text);
    } else if (type === 'note') {
      addNote(text);
    } else if (type === 'reminder') {
      addReminder(text, timeframe);
    }
  };

  const EmptyState = ({ icon, message }) => (
    <div className="flex flex-col items-center justify-center py-8 text-gray-400">
      <svg className="w-12 h-12 mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        {icon}
      </svg>
      <p className="text-sm">{message}</p>
    </div>
  );

  return (
    <div className="min-h-screen bg-gray-50">
      <OfflineIndicator />
      <SyncIndicator />
      <UpdatePrompt />

      {/* Header */}
      <header className="bg-white border-b border-gray-200 sticky top-0 z-30 shadow-sm">
        <div className="max-w-2xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <h1 className="text-2xl font-bold text-gray-900">Today</h1>
            <div className="flex items-center gap-2 text-sm text-gray-500">
              <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
              <span>{new Date().toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })}</span>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-2xl mx-auto px-4 py-6 pb-24">
        {/* Tasks Section */}
        <section className="mb-8">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-gray-700">Tasks</h2>
            <span className="text-sm text-gray-500 bg-gray-100 px-2.5 py-1 rounded-full">
              {tasks.length}/5
            </span>
          </div>
          <div className="space-y-3">
            {tasks.length === 0 ? (
              <EmptyState 
                icon={<path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />}
                message="No tasks yet"
              />
            ) : (
              tasks.map(task => (
                <ItemCard
                  key={task.id}
                  type="task"
                  item={task}
                  onToggle={toggleTask}
                  onDelete={deleteTask}
                />
              ))
            )}
          </div>
        </section>

        {/* Notes Section */}
        <section className="mb-8">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-gray-700">Notes</h2>
            <span className="text-sm text-gray-500 bg-gray-100 px-2.5 py-1 rounded-full">
              {notes.length}/5
            </span>
          </div>
          <div className="space-y-3">
            {notes.length === 0 ? (
              <EmptyState 
                icon={<path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />}
                message="No notes yet"
              />
            ) : (
              notes.map(note => (
                <ItemCard
                  key={note.id}
                  type="note"
                  item={note}
                  onDelete={deleteNote}
                />
              ))
            )}
          </div>
        </section>

        {/* Reminders Section */}
        <section className="mb-8">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold text-gray-700">Reminders</h2>
            <span className="text-sm text-gray-500 bg-gray-100 px-2.5 py-1 rounded-full">
              {reminders.length}/2
            </span>
          </div>
          <div className="space-y-3">
            {reminders.length === 0 ? (
              <EmptyState 
                icon={<path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />}
                message="No reminders yet"
              />
            ) : (
              reminders.map(reminder => (
                <ItemCard
                  key={reminder.id}
                  type="reminder"
                  item={reminder}
                  onDelete={deleteReminder}
                />
              ))
            )}
          </div>
        </section>
      </main>

      {/* Floating Action Button */}
      <button
        onClick={() => setIsModalOpen(true)}
        className="fixed bottom-6 right-6 w-16 h-16 bg-blue-500 text-white rounded-full shadow-lg hover:bg-blue-600 active:scale-95 transition-all flex items-center justify-center z-30"
        aria-label="Add new item"
      >
        <svg className="w-8 h-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
        </svg>
      </button>

      {/* Add Modal */}
      <AddModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        onAdd={handleAdd}
        taskCount={tasks.length}
        noteCount={notes.length}
        reminderCount={reminders.length}
      />

      {/* Install Prompt */}
      <InstallPrompt />
    </div>
  );
}

export default Dashboard;
