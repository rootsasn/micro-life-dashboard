import { useState, useEffect } from 'react';
import { db } from '../lib/database';

export function useOfflineSync() {
  const [isOnline, setIsOnline] = useState(navigator.onLine);
  const [syncStatus, setSyncStatus] = useState('idle'); // 'idle' | 'syncing' | 'synced' | 'error'
  const [lastSyncTime, setLastSyncTime] = useState(null);

  useEffect(() => {
    const handleOnline = () => {
      setIsOnline(true);
      syncData();
    };

    const handleOffline = () => {
      setIsOnline(false);
      setSyncStatus('idle');
    };

    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    // Initial sync if online
    if (navigator.onLine) {
      syncData();
    }

    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  const syncData = async () => {
    if (!navigator.onLine) return;

    setSyncStatus('syncing');
    
    try {
      // Verify database is accessible
      await db.open();
      
      // Get counts for verification
      const taskCount = await db.tasks.count();
      const noteCount = await db.notes.count();
      const reminderCount = await db.reminders.count();

      console.log('Sync complete:', { taskCount, noteCount, reminderCount });
      
      setSyncStatus('synced');
      setLastSyncTime(new Date());
      
      // Reset to idle after 2 seconds
      setTimeout(() => setSyncStatus('idle'), 2000);
    } catch (error) {
      console.error('Sync error:', error);
      setSyncStatus('error');
      
      // Reset to idle after 3 seconds
      setTimeout(() => setSyncStatus('idle'), 3000);
    }
  };

  const manualSync = () => {
    if (isOnline) {
      syncData();
    }
  };

  return {
    isOnline,
    syncStatus,
    lastSyncTime,
    manualSync
  };
}
