function NoteList({ notes, onDelete, maxItems }) {
  const formatDate = (isoDate) => {
    const date = new Date(isoDate);
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  };

  return (
    <section className="mb-8">
      <h2 className="text-lg font-semibold text-gray-700 mb-3">Notes ({notes.length}/{maxItems})</h2>
      <div className="space-y-2">
        {notes.map(note => (
          <div key={note.id} className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
            <div className="flex-1">
              <p className="text-base text-gray-900">{note.text}</p>
              <p className="text-sm text-gray-500 mt-1">{formatDate(note.date)}</p>
            </div>
            <button
              onClick={() => onDelete(note.id)}
              className="text-red-500 text-xl px-2"
              aria-label="Delete note"
            >
              ×
            </button>
          </div>
        ))}
      </div>
    </section>
  );
}

export default NoteList;
