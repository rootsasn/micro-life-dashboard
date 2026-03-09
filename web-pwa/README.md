# Micro Life Dashboard - PWA

A brutally simple, offline-first PWA for daily essentials.

## Features

- 5 max tasks with checkboxes
- 5 max notes with dates
- 2 max reminders with timeframes
- Offline-first with IndexedDB (Dexie.js)
- Auto-archive items older than 7 days
- PWA installable on mobile/desktop
- <1s load time on 3G networks
- Service worker with Workbox

## Setup

```bash
npm install
npm run dev
```

## Build for Production

```bash
npm run build
npm run preview
```

## PWA Features

### Manifest
- Installable on home screen
- Standalone display mode
- Custom splash screens (iOS)
- App shortcuts for quick actions
- Maskable icons for adaptive display

### Service Worker (Workbox)
- Offline-first caching strategy
- Auto-update on new version
- Runtime caching for fonts
- Background sync ready

### Performance Optimizations
- Code splitting (React, Dexie vendors)
- Critical CSS inlined
- Preconnect to font CDNs
- ES2015 target for modern browsers
- Lazy loading for non-critical components

## Testing

```bash
npm run test
```

Auto-test hook generates tests on file save with edge cases.

## PWA Installation

1. Build: `npm run build`
2. Serve: `npm run preview`
3. Open in browser
4. Click "Install" prompt or use browser menu

## Icon Generation

See `/public/icon-generator.md` for creating all required icons.

## Performance Targets

- First Contentful Paint: <1s on 3G
- Time to Interactive: <2s on 3G
- Lighthouse PWA score: 100

## Browser Support

- Chrome/Edge 90+
- Safari 14+
- Firefox 88+
- Mobile browsers with PWA support
