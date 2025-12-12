# Debug vs Release Build Comparison

## Build Performance

| Metric | Debug Build | Release Build | Difference |
|--------|-------------|---------------|------------|
| **Build Time** | ~28.0s | ~36.7s | +31% slower |
| **Total Size** | 128.86 MB | 61.47 MB | **-52% smaller** |

## Detailed File Sizes

### Debug Build (build/windows/x64/runner/Debug/)
| File | Size |
|------|------|
| sandwich_shop.exe | 1.11 MB |
| flutter_windows.dll | 40.53 MB |
| sandwich_shop.pdb | 7.69 MB |
| data/ folder | 79.53 MB |
| **Total** | **128.86 MB** |

### Release Build (build/windows/x64/runner/Release/)
| File | Size |
|------|------|
| sandwich_shop.exe | 0.09 MB |
| flutter_windows.dll | 17.65 MB |
| data/ folder | 43.73 MB |
| **Total** | **61.47 MB** |

## Key Differences

### Size Optimization
- **52% reduction** in total build size (128.86 MB → 61.47 MB)
- Main executable: 92% smaller (1.11 MB → 0.09 MB)
- Flutter DLL: 56% smaller (40.53 MB → 17.65 MB)
- No .pdb debug symbols in release (saves 7.69 MB)
- Data folder: 45% smaller (79.53 MB → 43.73 MB)

### Build Process
- Release build takes 31% longer due to AOT compilation and optimization
- Debug includes symbol files (.pdb) for debugging
- Release uses Ahead-of-Time (AOT) compilation for better performance
- Debug uses JIT compilation for faster rebuild during development

### Performance Characteristics

**Debug Build:**
- Contains debug symbols for breakpoint debugging
- Larger binary with unoptimized code
- Faster build time for rapid iteration
- Includes assertions and additional runtime checks
- Better error messages and stack traces

**Release Build:**
- AOT-compiled native code for optimal performance
- Stripped debug symbols and assertions
- Optimized binary with dead code elimination
- Tree-shaking removes unused code
- Better startup time and runtime performance
- Smaller memory footprint

## Recommendations

**Use Debug Build for:**
- Development and testing
- Debugging with breakpoints
- Quick iteration cycles
- Detailed error diagnostics

**Use Release Build for:**
- Production deployment
- Performance testing
- End-user distribution
- App store submissions

## Notes

- Firebase dependencies were temporarily disabled to resolve CMake compatibility issues on Windows
- The app functionality remains intact for core features (sandwich ordering, cart, checkout, orders)
- Profile screen Firebase integration is commented out but can be re-enabled for other platforms
- Both builds successfully compile and run on Windows 11
