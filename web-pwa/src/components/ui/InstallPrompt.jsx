import { useState } from 'react';
import { useInstallPrompt } from '../../hooks/useInstallPrompt';

function InstallPrompt() {
  const { isInstallable, promptInstall } = useInstallPrompt();
  const [isDismissed, setIsDismissed] = useState(false);

  if (!isInstallable || isDismissed) return null;

  const handleInstall = async () => {
    const installed = await promptInstall();
    if (!installed) {
      setIsDismissed(true);
    }
  };

  return (
    <div className="fixed bottom-20 left-4 right-4 z-40 animate-slide-up">
      <div className="bg-blue-500 text-white rounded-lg shadow-2xl p-4 max-w-md mx-auto">
        <div className="flex items-start gap-3">
          <div className="flex-shrink-0 w-10 h-10 bg-white rounded-lg flex items-center justify-center">
            <svg className="w-6 h-6 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
            </svg>
          </div>
          
          <div className="flex-1 min-w-0">
            <h3 className="font-semibold text-sm mb-1">Install MicroLife</h3>
            <p className="text-xs text-blue-100 mb-3">
              Add to your home screen for quick access and offline use
            </p>
            
            <div className="flex gap-2">
              <button
                onClick={handleInstall}
                className="flex-1 bg-white text-blue-500 py-2 px-4 rounded-lg text-sm font-semibold hover:bg-blue-50 transition-colors"
              >
                Install
              </button>
              <button
                onClick={() => setIsDismissed(true)}
                className="px-4 py-2 rounded-lg text-sm font-semibold text-blue-100 hover:text-white transition-colors"
              >
                Not now
              </button>
            </div>
          </div>
          
          <button
            onClick={() => setIsDismissed(true)}
            className="flex-shrink-0 text-blue-100 hover:text-white transition-colors"
            aria-label="Dismiss"
          >
            <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>
    </div>
  );
}

export default InstallPrompt;
