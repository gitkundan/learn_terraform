#!/bin/bash

# script to automate git workflow
# Exit the script immediately if any command fails.
set -e

# Ensure that pipelines fail on the first command that fails, not the last.
set -o pipefail

# Store the name of the current branch in a variable.
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "--- Currently on branch: $CURRENT_BRANCH ---"

# 1. Commit local changes
echo "--- Committing local changes... ---"
git commit -am "added gitmerge for git automation"
echo "--- Changes committed successfully. ---"

# 2. Switch to the local 'master' branch
echo "--- Switching to the 'master' branch... ---"
git checkout master

# 3. Pull the latest changes from the remote 'master' branch
echo "--- Pulling latest changes from origin/master... ---"
git pull origin master
echo "--- 'master' branch is up-to-date. ---"

# 4. Switch back to the original local branch
echo "--- Switching back to the '$CURRENT_BRANCH' branch... ---"
git checkout "$CURRENT_BRANCH"

# 5. Merge the updated 'master' branch into the current branch
echo "--- Merging 'master' into '$CURRENT_BRANCH'... ---"
git merge master
echo "--- Merge complete. ---"

# 6. Push the updated local branch to the remote repository
echo "--- Pushing changes to origin/$CURRENT_BRANCH... ---"
git push origin "$CURRENT_BRANCH"
echo "--- Push successful. Remote branch is now up-to-date. ---"

echo "--- Git workflow automation script finished successfully. ---"
