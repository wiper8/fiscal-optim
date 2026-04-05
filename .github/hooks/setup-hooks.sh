#!/bin/bash

# Setup Git hooks for development

mkdir -p .git/hooks
cp .github/hooks/pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-push

echo "Git hooks installed successfully"
