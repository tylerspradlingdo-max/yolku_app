# Which Branch to Pull in Xcode?

## Quick Answer

**Use the `main` branch for Xcode development.**

## Full Instructions

When working with the Yolku iOS app in Xcode, follow these steps:

### 1. Clone the Repository (First Time)

```bash
git clone https://github.com/tylerspradlingdo-max/yolku_app.git
cd yolku_app
```

### 2. Checkout the Main Branch

```bash
git checkout main
git pull origin main
```

### 3. Open in Xcode

```bash
cd YolkuApp
open YolkuApp.xcodeproj
```

## Branch Strategy

- **`main`** - Stable, production-ready code. Use this for development.
- **Feature branches** - Used for developing new features. If you create a feature branch, regularly merge or rebase from `main` to stay up to date.

## Keeping Your Branch Updated

If you're working on a feature branch and want to stay current with `main`:

```bash
# While on your feature branch
git fetch origin
git merge origin/main

# Or use rebase for a cleaner history
git rebase origin/main
```

## Troubleshooting

**Q: I'm on a different branch, how do I switch to main?**
```bash
# Save your current work first
git stash

# Switch to main
git checkout main
git pull origin main

# Restore your work if needed (may require conflict resolution)
git stash apply
# Or use 'git stash pop' to remove from stash after applying
```

**Q: How do I know which branch I'm on?**
```bash
git branch
# The current branch will have an asterisk (*)
```

**Q: Can I work on a feature branch?**

Yes! Create a feature branch from `main`:
```bash
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

When ready to merge back:
```bash
# Push your feature branch
git push origin feature/your-feature-name

# Then create a Pull Request on GitHub to merge into main
```

## Related Documentation

- [XCODE_GUIDE.md](XCODE_GUIDE.md) - Complete guide for iOS development
- [README.md](README.md) - Project overview and setup instructions

---

**Need more help?** Check out the [XCODE_GUIDE.md](XCODE_GUIDE.md) for detailed Xcode development instructions.
