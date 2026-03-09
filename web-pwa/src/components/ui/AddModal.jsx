import { useState, useEffect, useRef } from 'react';

function AddModal({ isOpen, onClose, onAdd, taskCount, noteCount, reminderCount }) {
  const [step, setStep] = useState('menu'); // 'menu' | 'task' | 'note' | 'reminder'
  const [inputValue, setInputValue] = useState('');
  const [timeframe, setTimeframe] = useState('today');
  const inputRef = useRef(null);

  useEffect(() => {
    if (step !== 'menu' && inputRef.current) {
      inputRef.current.focus();
    }
  }, [step]);

  useEffect(() => {
    if (!isOpen) {
      setStep('menu');
      setInputValue('');
      setTimeframe('today');
    }
  }, [isOpen]);

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!inputValue.trim()) return;

    if (step === 'task') {
      onAdd('task', inputValue);
    } else if (step === 'note') {
      onAdd('note', inputValue);
    } else if (step === 'reminder') {
      onAdd('reminder', inputValue, timeframe);
    }

    setInputValue('');
    setStep('menu');
    onClose();
  };

  if (!isOpen) return null;

  const renderMenu = () => (
    <div className="space-y-2">
      <button
        onClick={() => setStep('task')}
        disabled={taskCount >= 5}
        className="w-full flex items-center gap-4 p-4 rounded-lg border-2 border-gray-200 hover:border-blue-400 hover:bg-blue-50 transition-all disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:border-gray-200 disabled:hover:bg-white"
      >
        <div className="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
          <svg className="w-6 h-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
          </svg>
        </div>
        <div className="flex-1 text-left">
          <p className="font-semibold text-gray-900">Add Task</p>
          <p className="text-sm text-gray-500">{taskCount}/5 tasks</p>
        </div>
      </button>

      <button
        onClick={() => setStep('note')}
        disabled={noteCount >= 5}
        className="w-full flex items-center gap-4 p-4 rounded-lg border-2 border-gray-200 hover:border-green-400 hover:bg-green-50 transition-all disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:border-gray-200 disabled:hover:bg-white"
      >
        <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center">
          <svg className="w-6 h-6 text-green-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
          </svg>
        </div>
        <div className="flex-1 text-left">
          <p className="font-semibold text-gray-900">Add Note</p>
          <p className="text-sm text-gray-500">{noteCount}/5 notes</p>
        </div>
      </button>

      <button
        onClick={() => setStep('reminder')}
        disabled={reminderCount >= 2}
        className="w-full flex items-center gap-4 p-4 rounded-lg border-2 border-gray-200 hover:border-purple-400 hover:bg-purple-50 transition-all disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:border-gray-200 disabled:hover:bg-white"
      >
        <div className="w-10 h-10 rounded-full bg-purple-100 flex items-center justify-center">
          <svg className="w-6 h-6 text-purple-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
          </svg>
        </div>
        <div className="flex-1 text-left">
          <p className="font-semibold text-gray-900">Add Reminder</p>
          <p className="text-sm text-gray-500">{reminderCount}/2 reminders</p>
        </div>
      </button>
    </div>
  );

  const renderForm = () => (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label htmlFor="item-input" className="block text-sm font-medium text-gray-700 mb-2">
          {step === 'task' ? 'Task' : step === 'note' ? 'Note' : 'Reminder'}
        </label>
        <input
          ref={inputRef}
          id="item-input"
          type="text"
          value={inputValue}
          onChange={(e) => setInputValue(e.target.value)}
          placeholder={`Enter ${step}...`}
          className="w-full px-4 py-3 text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
        />
      </div>

      {step === 'reminder' && (
        <div>
          <label htmlFor="timeframe" className="block text-sm font-medium text-gray-700 mb-2">
            When
          </label>
          <select
            id="timeframe"
            value={timeframe}
            onChange={(e) => setTimeframe(e.target.value)}
            className="w-full px-4 py-3 text-base border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none"
          >
            <option value="today">Today</option>
            <option value="tomorrow">Tomorrow</option>
            <option value="next week">Next Week</option>
          </select>
        </div>
      )}

      <div className="flex gap-3 pt-2">
        <button
          type="submit"
          disabled={!inputValue.trim()}
          className="flex-1 bg-blue-500 text-white py-3 px-4 rounded-lg font-semibold hover:bg-blue-600 disabled:bg-gray-300 disabled:cursor-not-allowed transition-colors"
        >
          Add
        </button>
        <button
          type="button"
          onClick={() => setStep('menu')}
          className="px-6 py-3 rounded-lg font-semibold text-gray-700 bg-gray-100 hover:bg-gray-200 transition-colors"
        >
          Back
        </button>
      </div>
    </form>
  );

  return (
    <>
      <div 
        className="fixed inset-0 bg-black/50 z-40 animate-fade-in"
        onClick={onClose}
      />
      <div className="fixed inset-x-0 bottom-0 z-50 animate-slide-up">
        <div className="bg-white rounded-t-2xl shadow-2xl max-w-2xl mx-auto">
          <div className="p-6">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-bold text-gray-900">
                {step === 'menu' ? 'Add New Item' : `Add ${step.charAt(0).toUpperCase() + step.slice(1)}`}
              </h2>
              <button
                onClick={onClose}
                className="w-8 h-8 rounded-full flex items-center justify-center text-gray-400 hover:text-gray-600 hover:bg-gray-100 transition-colors"
                aria-label="Close"
              >
                <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>

            {step === 'menu' ? renderMenu() : renderForm()}
          </div>
        </div>
      </div>
    </>
  );
}

export default AddModal;
