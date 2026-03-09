import { useLiveQuery } from 'dexie-react-hooks';
import { db } from '../lib/database';

export function useArchive() {
  // Get all archived items
  const archivedItems = useLiveQuery(
    () => db.archive
      .orderBy('archivedAt')
      .reverse()
      .toArray(),
    []
  ) || [];

  // Get archive by type
  const getArchivedByType = (type) => {
    return archivedItems.filter(item => item.type === type);
  };

  // Restore item from archive
  const restoreItem = async (archiveId) => {
    try {
      const archived = await db.archive.get(archiveId);
      if (!archived) return false;

      const { type, data } = archived;
      
      // Remove archive-specific fields
      const { id, ...itemData } = data;
      itemData.archived = 0;

      // Add back to appropriate table
      if (type === 'task') {
        await db.tasks.add(itemData);
      } else if (type === 'note') {
        await db.notes.add(itemData);
      } else if (type === 'reminder') {
        await db.reminders.add(itemData);
      }

      // Remove from archive
      await db.archive.delete(archiveId);
      return true;
    } catch (error) {
      console.error('Error restoring item:', error);
      return false;
    }
  };

  // Permanently delete archived item
  const deleteArchivedItem = async (archiveId) => {
    try {
      await db.archive.delete(archiveId);
      return true;
    } catch (error) {
      console.error('Error deleting archived item:', error);
      return false;
    }
  };

  // Clear all archive
  const clearArchive = async () => {
    try {
      await db.archive.clear();
      return true;
    } catch (error) {
      console.error('Error clearing archive:', error);
      return false;
    }
  };

  return {
    archivedItems,
    getArchivedByType,
    restoreItem,
    deleteArchivedItem,
    clearArchive
  };
}
