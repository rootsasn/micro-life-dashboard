# Performance Optimization Guide

## Current Optimizations

### Bundle Size
- Code splitting: React and Dexie in separate chunks
- Tree shaking enabled
- ES2015 target (smaller than ES5)
- CSS code splitting

### Loading Performance
- Critical CSS inlined in HTML
- Preconnect to font CDNs
- DNS prefetch for external resources
- Lazy loading for non-critical components

### Caching Strategy
- Service worker with Workbox
- Cache-first for static assets
- Network-first for API calls (future)
- Stale-while-revalidate for fonts

### Runtime Performance
- IndexedDB for fast local storage
- Dexie live queries for reactive updates
- Minimal re-renders with proper React hooks
- Debounced search/filter (if added)

## Performance Targets

### 3G Network (1.6 Mbps, 150ms RTT)
- First Contentful Paint: <1s
- Time to Interactive: <2s
- Total Bundle Size: <200KB gzipped

### Lighthouse Scores
- Performance: 90+
- PWA: 100
- Accessibility: 95+
- Best Practices: 95+

## Measuring Performance

### Local Testing
```bash
npm run build
npm run preview
npm run lighthouse
```

### Chrome DevTools
1. Open DevTools
2. Network tab → Throttling → Slow 3G
3. Performance tab → Record page load
4. Lighthouse tab → Generate report

### Key Metrics to Monitor
- First Contentful Paint (FCP)
- Largest Contentful Paint (LCP)
- Time to Interactive (TTI)
- Total Blocking Time (TBT)
- Cumulative Layout Shift (CLS)

## Further Optimizations

### If bundle size grows:
- Implement route-based code splitting
- Use dynamic imports for modals
- Compress images with WebP
- Remove unused dependencies

### If load time increases:
- Add resource hints (preload, prefetch)
- Implement HTTP/2 server push
- Use CDN for static assets
- Enable Brotli compression

### If runtime slows:
- Virtualize long lists
- Implement pagination
- Add request debouncing
- Use Web Workers for heavy tasks

## Monitoring in Production

### Recommended Tools
- Google Analytics (Core Web Vitals)
- Sentry (Performance monitoring)
- Lighthouse CI (Automated testing)
- WebPageTest (Real-world testing)

### Key Metrics Dashboard
Track these over time:
- P75 FCP, LCP, TTI
- Bounce rate by connection speed
- PWA install rate
- Offline usage percentage
