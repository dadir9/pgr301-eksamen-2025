#!/bin/bash
# Script to complete the orphan branch force push to origin main
# This script should be run by someone with proper GitHub authentication

set -e  # Exit on error

echo "=========================================="
echo "Orphan Branch Force Push to Origin Main"
echo "=========================================="
echo ""

# Verify we're in a git repository
if [ ! -d .git ]; then
    echo "❌ Error: Not in a git repository root directory"
    exit 1
fi

# Check if main branch exists locally
if ! git show-ref --verify --quiet refs/heads/main; then
    echo "❌ Error: Local 'main' branch does not exist"
    echo "You need to run the orphan branch creation commands first:"
    echo "  git checkout --orphan newbranch"
    echo "  git add ."
    echo "  git commit -m 'Initial commit'"
    echo "  git branch -D main (if exists)"
    echo "  git branch -m main"
    exit 1
fi

# Show current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"

# Show main branch commit
echo ""
echo "Main branch commit:"
git log --oneline -1 main
echo ""

# Verify this is an orphan commit (root commit with no parents)
PARENT_COUNT=$(git rev-list --parents main | head -1 | wc -w)
PARENT_COUNT=$((PARENT_COUNT - 1))
if [ "$PARENT_COUNT" -eq 0 ]; then
    echo "✅ Verified: main branch is an orphan commit (no parent commits)"
else
    echo "⚠️  Warning: main branch has $PARENT_COUNT parent commit(s)"
    echo "This may not be a clean orphan branch"
fi

# Show file count
FILE_COUNT=$(git ls-tree -r -z main --name-only | tr -cd '\0' | wc -c)
echo "Files in main branch: $FILE_COUNT"
echo ""

# Confirmation prompt
echo "⚠️  WARNING: This will FORCE PUSH to origin/main"
echo "This will:"
echo "  - Replace the entire history of origin/main"
echo "  - Remove all previous commits from the remote"
echo "  - Cannot be easily undone"
echo ""
read -p "Are you sure you want to continue? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Aborted. No changes made to remote."
    exit 0
fi

echo ""
echo "Executing: git push -f origin main"
echo ""

# Force push to origin main
if git push -f origin main; then
    echo ""
    echo "=========================================="
    echo "✅ SUCCESS: Force push to origin/main completed"
    echo "=========================================="
    echo ""
    echo "The remote repository now has a clean history with only:"
    git log --oneline -1 main
    echo ""
    echo "All previous commit history has been removed from the remote."
else
    echo ""
    echo "=========================================="
    echo "❌ FAILED: Force push encountered an error"
    echo "=========================================="
    echo ""
    echo "Common issues:"
    echo "  - Authentication failed (check your credentials)"
    echo "  - Branch protection rules (admin may need to disable)"
    echo "  - Network connectivity issues"
    exit 1
fi
