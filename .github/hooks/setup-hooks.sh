#!/bin/bash

# Setup Git hooks for development

mkdir -p .git/hooks
cp .github/hooks/pre-push .git/hooks/pre-push
chmod +x .git/hooks/pre-push
cp .github/hooks/linter_script.R .git/hooks/linter_script.R

echo "Git hooks installed successfully"
