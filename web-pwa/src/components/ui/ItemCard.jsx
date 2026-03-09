import { useState } from 'react';

function ItemCard({ type, item, onToggle, onDelete }) {
  const [isDeleting, setIsDeleting] = useState(false);

  const handleDelete = async () => {
    setIsDeleting(true);
    await onDelete(item.id);
  };

  const formatDate = (isoDate) => {
    const date = new Date(isoDate);
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  };

  const timeframeStyles = {
    today: 'bg-red-50 text-red-700 border-red-200',
    tomorrow: 'bg-yellow-50 text-yellow-700 border-yellow-200',
    'next week': 'bg-blue-50 text-blue-700 border-blue-200'
  };

  return (
    <div className={`group relative bg-white border border-gray-200 rounded-lg p-4 shadow-sm hover:shadow-md transition-all ${isDeleting ? 'opacity-50' : ''}`}>
      <div className="flex items-start gap-3">
        {type === 'task' && (
          <button
            onClick={() => onToggle(item.id)}
            className="mt-0.5 flex-shrink-0"
            aria-label={item.completed ? 'Mark incomplete' : 'Mark complete'}
          >
            <div className={`w-6 h-6 rounded border-2 flex items-center justify-center transition-colors ${
              item.completed 
                ? 'bg-blue-500 border-blue-500' 
                : 'border-gray-300 hover:border-blue-400'
            }`}>
              {item.completed && (
                <svg className="w-4 h-4 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                </svg>
              )}
            </div>
          </button>
        )}

        <div className="flex-1 min-w-0">
          <p className={`text-base leading-relaxed ${
            type === 'task' && item.completed 
              ? 'line-through text-gray-400' 
              : 'text-gray-900'
          }`}>
            {item.text}
          </p>

          {type === 'note' && (
            <p className="text-sm text-gray-500 mt-2">{formatDate(item.date)}</p>
          )}

          {type === 'reminder' && (
            <span className={`inline-block text-xs font-medium px-2.5 py-1 rounded-md border mt-2 ${timeframeStyles[item.timeframe]}`}>
              {item.timeframe}
            </span>
          )}
        </div>

        <button
          onClick={handleDelete}
          disabled={isDeleting}
          className="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center text-gray-400 hover:text-red-500 hover:bg-red-50 transition-colors opacity-0 group-hover:opacity-100"
          aria-label="Delete"
        >
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    </div>
  );
}

export default ItemCard;
