import { useOfflineSync } from '../../hooks/useOfflineSync';

function SyncIndicator() {
  const { syncStatus, lastSyncTime, manualSync } = useOfflineSync();

  if (syncStatus === 'idle') return null;

  const statusConfig = {
    syncing: {
      icon: (
        <svg className="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
          <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
          <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
        </svg>
      ),
      text: 'Syncing...',
      color: 'bg-blue-500'
    },
    synced: {
      icon: (
        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
        </svg>
      ),
      text: 'Synced',
      color: 'bg-green-500'
    },
    error: {
      icon: (
        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
      ),
      text: 'Sync failed',
      color: 'bg-red-500'
    }
  };

  const config = statusConfig[syncStatus];

  return (
    <div className={`fixed top-16 right-4 z-40 ${config.color} text-white px-3 py-2 rounded-lg shadow-lg flex items-center gap-2 text-sm animate-slide-down`}>
      {config.icon}
      <span>{config.text}</span>
      {lastSyncTime && syncStatus === 'synced' && (
        <span className="text-xs opacity-75 ml-1">
          {lastSyncTime.toLocaleTimeString()}
        </span>
      )}
    </div>
  );
}

export default SyncIndicator;
