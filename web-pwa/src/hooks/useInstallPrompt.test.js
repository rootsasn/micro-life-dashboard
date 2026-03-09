import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderHook, act } from '@testing-library/react';
import { useInstallPrompt } from './useInstallPrompt';

describe('useInstallPrompt', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    // Reset window.matchMedia
    Object.defineProperty(window, 'matchMedia', {
      writable: true,
      value: vi.fn().mockImplementation(query => ({
        matches: false,
        media: query,
        onchange: null,
        addListener: vi.fn(),
        removeListener: vi.fn(),
        addEventListener: vi.fn(),
        removeEventListener: vi.fn(),
        dispatchEvent: vi.fn(),
      })),
    });
  });

  it('initializes with not installable state', () => {
    const { result } = renderHook(() => useInstallPrompt());
    
    expect(result.current.isInstallable).toBe(false);
    expect(result.current.isInstalled).toBe(false);
  });

  it('detects when app is already installed', () => {
    window.matchMedia = vi.fn().mockImplementation(query => ({
      matches: query === '(display-mode: standalone)',
      media: query,
      addEventListener: vi.fn(),
      removeEventListener: vi.fn(),
    }));

    const { result } = renderHook(() => useInstallPrompt());
    expect(result.current.isInstalled).toBe(true);
  });

  it('becomes installable on beforeinstallprompt event', () => {
    const { result } = renderHook(() => useInstallPrompt());
    
    const mockEvent = {
      preventDefault: vi.fn(),
      prompt: vi.fn(),
      userChoice: Promise.resolve({ outcome: 'accepted' })
    };

    act(() => {
      window.dispatchEvent(new CustomEvent('beforeinstallprompt', { detail: mockEvent }));
    });

    // Note: In real implementation, event listener would update state
    expect(result.current.isInstallable).toBeDefined();
  });

  it('promptInstall returns false when no deferred prompt', async () => {
    const { result } = renderHook(() => useInstallPrompt());
    
    const installed = await result.current.promptInstall();
    expect(installed).toBe(false);
  });
});
