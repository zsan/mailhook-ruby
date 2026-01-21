# Release Process

This document describes the steps to release a new version of `mailhook-ruby`.

## Versioning

This gem follows [Semantic Versioning](https://semver.org/):
- **MAJOR** (1.0.0): Breaking changes, not backward compatible
- **MINOR** (0.1.0): New features, backward compatible
- **PATCH** (0.0.1): Bug fixes, backward compatible

## Pre-Release Checklist

Before releasing, ensure:

- [ ] All tests passing: `bundle exec rspec`
- [ ] Code style OK: `bundle exec rubocop`
- [ ] CHANGELOG.md is updated
- [ ] Version number is updated in `lib/mailhook/version.rb`

## Release Steps

### 1. Update Version

Edit `lib/mailhook/version.rb`:

```ruby
module Mailhook
  VERSION = "X.Y.Z"  # Replace with new version
end
```

### 2. Update CHANGELOG

Edit `CHANGELOG.md`:

```markdown
## [Unreleased]

## [X.Y.Z] - YYYY-MM-DD

### Added
- New features...

### Changed
- Changes...

### Fixed
- Bug fixes...

### Removed
- Removed items...
```

### 3. Run Tests

```bash
bundle exec rspec
bundle exec rubocop
```

Ensure all tests pass before proceeding.

### 4. Commit Changes

```bash
git add -A
git commit -m "Release vX.Y.Z"
```

### 5. Create Git Tag

```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z"
```

### 6. Push to GitHub

```bash
git push origin main
git push origin vX.Y.Z
```

### 7. Create GitHub Release (Optional)

1. Go to the repository on GitHub
2. Click "Releases" → "Create a new release"
3. Select tag `vX.Y.Z`
4. Title: `vX.Y.Z`
5. Description: Copy from CHANGELOG.md for this version
6. Click "Publish release"

### 8. Publish to RubyGems (Optional)

To publish to RubyGems:

```bash
# Build gem
gem build mailhook.gemspec

# Push to RubyGems (requires rubygems.org account)
gem push mailhook-X.Y.Z.gem
```

## Quick Release Script

For convenience, use this command (replace X.Y.Z):

```bash
# Set version
VERSION="X.Y.Z"

# Verify tests pass
bundle exec rspec && bundle exec rubocop

# Commit, tag, push
git add -A
git commit -m "Release v$VERSION"
git tag -a "v$VERSION" -m "Release v$VERSION"
git push origin main
git push origin "v$VERSION"
```

## Hotfix Release

For quick patch releases (urgent bug fixes):

1. Create branch from last tag: `git checkout -b hotfix/vX.Y.Z vX.Y.Z`
2. Fix bug and commit
3. Update version to next patch (X.Y.Z+1)
4. Follow release steps from step 4

## Notes

- Always test before releasing
- Never skip updating CHANGELOG
- Tag must match VERSION in code
- Use date format: YYYY-MM-DD
