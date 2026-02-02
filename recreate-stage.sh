#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to check if the branch exists locally
branch_exists_locally() {
    git show-ref --verify --quiet refs/heads/$1
}

# Function to check if the branch exists remotely
branch_exists_remotely() {
    git ls-remote --exit-code --heads origin $1
}

# Define the branch names
MAIN_BRANCH="main"
STAGE_BRANCH="stage"

# Delete the local stage branch if it exists
if branch_exists_locally $STAGE_BRANCH; then
    echo "Deleting local branch '$STAGE_BRANCH'..."
    git branch -D $STAGE_BRANCH
fi

# Delete the remote stage branch if it exists
if branch_exists_remotely $STAGE_BRANCH; then
    echo "Deleting remote branch '$STAGE_BRANCH'..."
    git push origin --delete $STAGE_BRANCH
fi

# Checkout the main branch and pull the latest changes
echo "Switching to branch '$MAIN_BRANCH' and pulling latest changes..."
git checkout $MAIN_BRANCH
git pull origin $MAIN_BRANCH

# Create a new stage branch from the main branch
echo "Creating new branch '$STAGE_BRANCH' from '$MAIN_BRANCH'..."
git checkout -b $STAGE_BRANCH

# Push the new stage branch to the remote repository
echo "Pushing new branch '$STAGE_BRANCH' to remote repository..."
git push origin $STAGE_BRANCH

echo "Branch '$STAGE_BRANCH' successfully recreated from '$MAIN_BRANCH' and pushed to remote."
