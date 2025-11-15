#!/bin/bash
# OBxFlow 2.0 - Automated Project Foundation Builder
# This script creates the complete project structure with all necessary files

set -e  # Exit on error

PROJECT_ROOT="$(pwd)"
echo "🚀 Building OBxFlow 2.0 project foundation at: $PROJECT_ROOT"
echo ""

# Create directory structure
echo "📁 Creating directory structure..."
mkdir -p .ai
mkdir -p docs/{setup,guides,brand}
mkdir -p n8n/custom/branding/{css,logos,images}
mkdir -p n8n/custom/nodes
mkdir -p n8n/{backups,logs}
mkdir -p workflows/{templates,examples}
mkdir -p .github/workflows

# Create .gitkeep files for empty directories
touch n8n/custom/branding/logos/.gitkeep
touch n8n/custom/branding/images/.gitkeep
touch n8n/custom/nodes/.gitkeep
touch n8n/backups/.gitkeep
touch n8n/logs/.gitkeep

echo "✅ Directory structure created"
echo ""

# Initialize git
if [ ! -d ".git" ]; then
    echo "🔧 Initializing git repository..."
    git init
    git branch -M main
    echo "✅ Git initialized"
    echo ""
fi

echo "🎉 Project foundation structure complete!"
echo ""
echo "Next steps:"
echo "1. Create documentation files in .ai/"
echo "2. Create user documentation in docs/"
echo "3. Create Docker configuration in n8n/"
echo "4. Create branding CSS files"
echo "5. Create README and other root files"
echo "6. Commit to GitHub"

