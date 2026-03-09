import { useState } from 'react';

function AddButton({ onAddTask, onAddNote, onAddReminder, taskCount, noteCount, reminderCount }) {
  const [showMenu, setShowMenu] = useState(false);
  const [showInput, setShowInput] = useState(null);
  const [inputValue, setInputValue] = useState('');
  const [timeframe, setTimeframe] = useState('today');

  const handleAdd = () => {
    if (!inputValue.trim()) return;

    if (showInput === 'task') {
      onAddTask(inputValue);
    } else if (showInput === 'note') {
      onAddNote(inputValue);
    } else if (showInput === 'reminder') {
      onAddReminder(inputValue, timeframe);
    }

    setInputValue('');
    setShowInput(null);
    setShowMenu(false);
  };

  if (showInput) {
    return (
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 shadow-lg">
        <div className="max-w-2xl mx-auto">
          <input
            type="text"
            value={inputValue}
            onChange={(e) => setInputValue(e.target.value)}
            placeholder={`Add ${showInput}...`}
            className="w-full p-3 text-lg border border-gray-300 rounded-lg mb-3"
            autoFocus
          />
          {showInput === 'reminder' && (
            <select
              value={timeframe}
              onChange={(e) => setTimeframe(e.target.value)}
              className="w-full p-3 border border-gray-300 rounded-lg mb-3"
            >
              <option value="today">Today</option>
              <option value="tomorrow">Tomorrow</option>
              <option value="next week">Next Week</option>
            </select>
          )}
          <div className="flex gap-2">
            <button
              onClick={handleAdd}
              className="flex-1 bg-blue-500 text-white py-3 rounded-lg text-lg font-semibold"
            >
              Add
            </button>
            <button
              onClick={() => { setShowInput(null); setInputValue(''); }}
              className="px-6 bg-gray-200 text-gray-700 py-3 rounded-lg text-lg font-semibold"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>
    );
  }

  if (showMenu) {
    return (
      <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 p-4 shadow-lg">
        <div className="max-w-2xl mx-auto space-y-2">
          <button
            onClick={() => { setShowInput('task'); setShowMenu(false); }}
            disabled={taskCount >= 5}
            className="w-full bg-blue-500 text-white py-4 rounded-lg text-lg font-semibold disabled:bg-gray-300"
          >
            Add Task {taskCount >= 5 && '(Max reached)'}
          </button>
          <button
            onClick={() => { setShowInput('note'); setShowMenu(false); }}
            disabled={noteCount >= 5}
            className="w-full bg-green-500 text-white py-4 rounded-lg text-lg font-semibold disabled:bg-gray-300"
          >
            Add Note {noteCount >= 5 && '(Max reached)'}
          </button>
          <button
            onClick={() => { setShowInput('reminder'); setShowMenu(false); }}
            disabled={reminderCount >= 2}
            className="w-full bg-purple-500 text-white py-4 rounded-lg text-lg font-semibold disabled:bg-gray-300"
          >
            Add Reminder {reminderCount >= 2 && '(Max reached)'}
          </button>
          <button
            onClick={() => setShowMenu(false)}
            className="w-full bg-gray-200 text-gray-700 py-4 rounded-lg text-lg font-semibold"
          >
            Cancel
          </button>
        </div>
      </div>
    );
  }

  return (
    <button
      onClick={() => setShowMenu(true)}
      className="fixed bottom-6 right-6 w-16 h-16 bg-blue-500 text-white rounded-full shadow-lg text-4xl flex items-center justify-center hover:bg-blue-600"
      aria-label="Add item"
    >
      +
    </button>
  );
}

export default AddButton;
