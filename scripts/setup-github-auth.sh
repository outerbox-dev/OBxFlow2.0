#!/bin/bash
# GitHub Authentication Setup Helper for OBxFlow 2.0

set -e

echo "🔐 GitHub Authentication Setup for OBxFlow 2.0"
echo "=============================================="
echo ""

# Check if we're in the right directory
if [ ! -d ".git" ]; then
    echo "❌ Error: Not in a git repository"
    echo "   Please run this script from ~/Projects/OBxFlow2.0"
    exit 1
fi

echo "Current remote configuration:"
git remote -v
echo ""

echo "Choose authentication method:"
echo "1) SSH Key (Recommended)"
echo "2) Personal Access Token (HTTPS)"
echo "3) Check existing configuration"
echo "4) Exit"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "🔑 SSH Key Setup"
        echo "==============="
        
        # Check for existing SSH keys
        if [ -f ~/.ssh/id_ed25519.pub ] || [ -f ~/.ssh/id_rsa.pub ]; then
            echo "✅ SSH key found!"
            echo ""
            echo "Your public key:"
            if [ -f ~/.ssh/id_ed25519.pub ]; then
                cat ~/.ssh/id_ed25519.pub
            else
                cat ~/.ssh/id_rsa.pub
            fi
            echo ""
            if command -v pbcopy &> /dev/null; then
                if [ -f ~/.ssh/id_ed25519.pub ]; then
                    cat ~/.ssh/id_ed25519.pub | pbcopy
                else
                    cat ~/.ssh/id_rsa.pub | pbcopy
                fi
                echo "📋 Key copied to clipboard!"
            fi
        else
            echo "No SSH key found. Generating one..."
            read -p "Enter your email: " email
            ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""
            echo ""
            echo "✅ SSH key generated!"
            cat ~/.ssh/id_ed25519.pub
            if command -v pbcopy &> /dev/null; then
                cat ~/.ssh/id_ed25519.pub | pbcopy
                echo "📋 Key copied to clipboard!"
            fi
        fi
        
        echo ""
        echo "Next steps:"
        echo "1. Go to https://github.com/settings/ssh/new"
        echo "2. Paste your public key"
        echo "3. Add it to GitHub"
        echo ""
        read -p "Press Enter after adding key..."
        
        # Update remote to use SSH
        current_remote=$(git remote get-url origin)
        if [[ $current_remote == https://* ]]; then
            repo_path=$(echo $current_remote | sed 's|https://github.com/||')
            new_remote="git@github.com:$repo_path"
            git remote set-url origin "$new_remote"
            echo "✅ Remote updated to SSH"
        fi
        ;;
        
    2)
        echo ""
        echo "🔑 Personal Access Token Setup"
        echo "=============================="
        echo ""
        echo "1. Go to https://github.com/settings/tokens/new"
        echo "2. Create token with 'repo' scope"
        echo "3. Use as password when pushing"
        ;;
        
    3)
        git remote -v
        git config user.name || echo "No name"
        git config user.email || echo "No email"
        ssh -T git@github.com 2>&1 | grep -q "success" && echo "✅ SSH works" || echo "❌ SSH not working"
        ;;
        
    4)
        exit 0
        ;;
esac

echo ""
echo "✅ Setup complete! Try: git push origin main"
