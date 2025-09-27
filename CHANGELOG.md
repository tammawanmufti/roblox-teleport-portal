# TeleportSystem Plugin Changelog

## [2.0.0] - 2025-09-27

### Added
- Repository-based plugin architecture
- One-click installation from Studio toolbar
- Auto-creation of example portals
- Same-folder teleportation logic
- Cooldown system with per-player tracking
- Visual explosion effects
- Sound effects with auto-cleanup
- Debug logging system
- Git-based update workflow

### Changed
- Complete rewrite from embedded scripts to modular architecture
- Moved source files to `src/` directory
- Plugin now reads from repository files directly

### Removed
- Hard-coded embedded script sources
- Complex multi-folder search logic
- Unnecessary dependencies (TweenService, RunService)

## [1.0.0] - 2025-09-27

### Added
- Initial release
- Basic teleportation functionality