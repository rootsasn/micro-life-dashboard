import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent } from '@testing-library/react';
import InstallPrompt from './InstallPrompt';

vi.mock('../../hooks/useInstallPrompt', () => ({
  useInstallPrompt: vi.fn()
}));

import { useInstallPrompt } from '../../hooks/useInstallPrompt';

describe('InstallPrompt', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('does not render when not installable', () => {
    useInstallPrompt.mockReturnValue({
      isInstallable: false,
      promptInstall: vi.fn()
    });

    const { container } = render(<InstallPrompt />);
    expect(container.firstChild).toBeNull();
  });

  it('renders when installable', () => {
    useInstallPrompt.mockReturnValue({
      isInstallable: true,
      promptInstall: vi.fn()
    });

    render(<InstallPrompt />);
    expect(screen.getByText('Install MicroLife')).toBeDefined();
    expect(screen.getByText(/Add to your home screen/)).toBeDefined();
  });

  it('calls promptInstall when install button clicked', async () => {
    const mockPromptInstall = vi.fn().mockResolvedValue(true);
    useInstallPrompt.mockReturnValue({
      isInstallable: true,
      promptInstall: mockPromptInstall
    });

    render(<InstallPrompt />);
    const installButton = screen.getByText('Install');
    
    fireEvent.click(installButton);
    expect(mockPromptInstall).toHaveBeenCalled();
  });

  it('dismisses when not now clicked', () => {
    useInstallPrompt.mockReturnValue({
      isInstallable: true,
      promptInstall: vi.fn()
    });

    const { container } = render(<InstallPrompt />);
    const notNowButton = screen.getByText('Not now');
    
    fireEvent.click(notNowButton);
    expect(container.firstChild).toBeNull();
  });
});
