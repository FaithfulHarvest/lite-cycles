#!/bin/bash

# TRON Light Cycles - Web Deployment Script
# This script helps deploy the game to GitHub Pages

echo "🎮 TRON Light Cycles - Web Deployment"
echo "======================================"

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init
    git add .
    git commit -m "Initial commit: TRON Light Cycles web game"
fi

# Check if remote origin exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo ""
    echo "📝 To deploy to GitHub Pages:"
    echo "1. Create a new repository on GitHub"
    echo "2. Run: git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git"
    echo "3. Run: git push -u origin main"
    echo "4. Enable GitHub Pages in repository settings"
    echo "5. Your game will be available at: https://YOUR_USERNAME.github.io/YOUR_REPO"
    echo ""
else
    echo "Pushing to GitHub..."
    git add .
    git commit -m "Update TRON Light Cycles web game"
    git push origin main
    echo "✅ Game updated on GitHub Pages!"
fi

echo ""
echo "🌐 Alternative Free Hosting Options:"
echo "• Netlify: Drag index.html to netlify.com/drop"
echo "• Vercel: Connect GitHub repo at vercel.com"
echo "• Surge.sh: npm install -g surge && surge"
echo ""
echo "🎮 Your TRON Light Cycles game is ready to play!"
