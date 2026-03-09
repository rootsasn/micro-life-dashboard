# PWA Icon Generation Guide

## Required Icons

Generate these icons from a 512x512 source image:

### Standard Icons
- icon-72.png (72x72)
- icon-96.png (96x96)
- icon-128.png (128x128)
- icon-144.png (144x144)
- icon-152.png (152x152)
- icon-192.png (192x192)
- icon-384.png (384x384)
- icon-512.png (512x512)

### Maskable Icons (with safe zone)
- icon-maskable-192.png (192x192)
- icon-maskable-512.png (512x512)

### Apple Touch Icons
- apple-touch-icon.png (180x180)

### Splash Screens (iOS)
- splash-640x1136.png (iPhone SE)
- splash-750x1334.png (iPhone 8)
- splash-1242x2208.png (iPhone 8 Plus)
- splash-1125x2436.png (iPhone X)
- splash-1242x2688.png (iPhone XS Max)

## Quick Generation with ImageMagick

```bash
# Standard icons
convert source-512.png -resize 72x72 icon-72.png
convert source-512.png -resize 96x96 icon-96.png
convert source-512.png -resize 128x128 icon-128.png
convert source-512.png -resize 144x144 icon-144.png
convert source-512.png -resize 152x152 icon-152.png
convert source-512.png -resize 192x192 icon-192.png
convert source-512.png -resize 384x384 icon-384.png
cp source-512.png icon-512.png

# Apple touch icon
convert source-512.png -resize 180x180 apple-touch-icon.png

# Maskable (add 20% padding)
convert source-512.png -resize 154x154 -gravity center -extent 192x192 -background white icon-maskable-192.png
convert source-512.png -resize 410x410 -gravity center -extent 512x512 -background white icon-maskable-512.png
```

## Design Guidelines

- Use simple, recognizable icon
- High contrast for visibility
- Avoid text (too small at small sizes)
- Maskable icons: keep important content in center 80%
- Splash screens: centered logo on white background
