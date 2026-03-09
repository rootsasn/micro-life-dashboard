import { useState, useEffect } from 'react';
import { useRegisterSW } from 'virtual:pwa-register/react';

function UpdatePrompt() {
  const [showPrompt, setShowPrompt] = useState(false);

  const {
    needRefresh: [needRefresh, setNeedRefresh],
    updateServiceWorker
  } = useRegisterSW({
    onRegistered(r) {
      console.log('SW Registered:', r);
    },
    onRegisterError(error) {
      console.log('SW registration error', error);
    }
  });

  useEffect(() => {
    if (needRefresh) {
      setShowPrompt(true);
    }
  }, [needRefresh]);

  const handleUpdate = () => {
    updateServiceWorker(true);
    setShowPrompt(false);
  };

  if (!showPrompt) return null;

  return (
    <div className="fixed bottom-4 left-4 right-4 z-50 animate-slide-up">
      <div className="bg-gray-900 text-white rounded-lg shadow-2xl p-4 max-w-md mx-auto">
        <div className="flex items-start gap-3">
          <div className="flex-shrink-0 w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center">
            <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
            </svg>
          </div>
          
          <div className="flex-1">
            <h3 className="font-semibold text-sm mb-1">Update Available</h3>
            <p className="text-xs text-gray-300 mb-3">
              A new version is ready. Reload to update.
            </p>
            
            <div className="flex gap-2">
              <button
                onClick={handleUpdate}
                className="flex-1 bg-blue-500 text-white py-2 px-4 rounded-lg text-sm font-semibold hover:bg-blue-600 transition-colors"
              >
                Reload
              </button>
              <button
                onClick={() => setShowPrompt(false)}
                className="px-4 py-2 rounded-lg text-sm font-semibold text-gray-300 hover:text-white transition-colors"
              >
                Later
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default UpdatePrompt;
