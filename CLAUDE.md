# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AdaptiveGrid is a Swift Package Manager (SPM) library that provides an adaptive grid layout for SwiftUI. It automatically determines the optimal number of columns based on available width and content size, while maintaining equal row heights.

**Platforms:** iOS 16+, macOS 13+ (runtime); Xcode 16+ (build)
**Swift Version:** 5.10+ (uses @Entry macro from iOS 18 SDK for backward-compatible code)

## Build and Development

```bash
# Build the package
swift build

# Run tests
swift test

# Build for release
swift build -c release
```

To use in Xcode, open `Package.swift` or add to a project as a Swift Package dependency.

## Architecture

### Core Components

**AdaptiveGrid.swift** - Public API
- Main view that users interact with
- Reads `equalWidth` environment value using `@Environment`
- Passes configuration to `AdaptiveGridLayout`

**AdaptiveGridLayout.swift** - Layout Engine
- Implements SwiftUI's `Layout` protocol
- Contains the core layout algorithm in `sizeThatFits()`
- Two layout modes:
  - **Equal Width Mode**: All columns have identical width (widest item + proportional stretch)
  - **Adaptive Width Mode**: Each column width based on widest item in that column + proportional stretch
- Algorithm iterates through possible column counts to find optimal layout that fits available width
- Applies proportional stretching to fill available width

**EqualWidthModifier.swift** - Configuration
- Defines `equalWidth` environment key using `@Entry` macro (modern SwiftUI syntax)
- Provides `.equalWidth()` modifier for users

**AdaptiveGrid+Previews.swift** - Examples
- Comprehensive preview scenarios demonstrating both layout modes using `#Preview` macro
- Wrapped in `#if compiler(>=6)` to check compiler version (Xcode 16+) rather than language mode
- Useful for visual testing and documentation

### Layout Algorithm

**Equal Width Mode:**
1. Find maximum width across all subviews
2. Calculate how many columns fit: `floor((width + spacing) / (maxWidth + spacing))`
3. Stretch columns equally to fill available width

**Adaptive Width Mode:**
1. Iterate from 1 to N columns
2. For each column count, group items and calculate per-column widths
3. Find largest column count where total width fits
4. Apply proportional stretching based on natural column widths

**Row Heights:**
- Always equal across all rows
- Determined by tallest subview in the entire grid

### Concurrency

- All SwiftUI view code is `@MainActor` isolated by default
- Layout calculations are synchronous and thread-safe
- No async/await or actor types used - simple synchronous SwiftUI layout implementation
- Compatible with both Swift 5.10+ and Swift 6 concurrency models
