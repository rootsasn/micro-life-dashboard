function ReminderList({ reminders, onDelete, maxItems }) {
  const timeframeColors = {
    today: 'bg-red-100 text-red-700',
    tomorrow: 'bg-yellow-100 text-yellow-700',
    'next week': 'bg-blue-100 text-blue-700'
  };

  return (
    <section className="mb-8">
      <h2 className="text-lg font-semibold text-gray-700 mb-3">Reminders ({reminders.length}/{maxItems})</h2>
      <div className="space-y-2">
        {reminders.map(reminder => (
          <div key={reminder.id} className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
            <div className="flex-1">
              <p className="text-base text-gray-900">{reminder.text}</p>
              <span className={`inline-block text-xs px-2 py-1 rounded mt-2 ${timeframeColors[reminder.timeframe]}`}>
                {reminder.timeframe}
              </span>
            </div>
            <button
              onClick={() => onDelete(reminder.id)}
              className="text-red-500 text-xl px-2"
              aria-label="Delete reminder"
            >
              ×
            </button>
          </div>
        ))}
      </div>
    </section>
  );
}

export default ReminderList;
