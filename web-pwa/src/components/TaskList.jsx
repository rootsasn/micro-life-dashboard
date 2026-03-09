function TaskList({ tasks, onToggle, onDelete, maxItems }) {
  return (
    <section className="mb-8">
      <h2 className="text-lg font-semibold text-gray-700 mb-3">Tasks ({tasks.length}/{maxItems})</h2>
      <div className="space-y-2">
        {tasks.map(task => (
          <div key={task.id} className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg">
            <input
              type="checkbox"
              checked={task.completed}
              onChange={() => onToggle(task.id)}
              className="w-6 h-6 rounded border-gray-300"
            />
            <span className={`flex-1 text-base ${task.completed ? 'line-through text-gray-400' : 'text-gray-900'}`}>
              {task.text}
            </span>
            <button
              onClick={() => onDelete(task.id)}
              className="text-red-500 text-xl px-2"
              aria-label="Delete task"
            >
              ×
            </button>
          </div>
        ))}
      </div>
    </section>
  );
}

export default TaskList;
