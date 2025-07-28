#!/bin/bash

# Generate Marp Presentation Script
# This script converts the Marp slides to HTML for presentation

echo "🎯 Generating Marp Presentation for Foobar Flutter Firebase App"
echo "=================================================="

# Check if Marp CLI is installed
if ! command -v marp &> /dev/null; then
    echo "❌ Marp CLI is not installed. Installing now..."
    echo "Please run: npm install -g @marp-team/marp-cli"
    echo "Or if you prefer, install the VS Code Marp extension instead."
    exit 1
fi

# Navigate to the doc directory
cd "$(dirname "$0")"

echo "📍 Current directory: $(pwd)"

# Generate HTML presentation
echo "🔄 Converting slides.md to HTML presentation..."
marp slides.md -o foobar-flutter-firebase-presentation.html --theme default --html

# Check if generation was successful
if [ $? -eq 0 ]; then
    echo "✅ Presentation generated successfully!"
    echo "📄 Output file: foobar-flutter-firebase-presentation.html"
    echo ""
    echo "🌐 To view the presentation:"
    echo "   1. Open foobar-flutter-firebase-presentation.html in your browser"
    echo "   2. Or use 'open foobar-flutter-firebase-presentation.html' on macOS"
    echo "   3. Or use 'start foobar-flutter-firebase-presentation.html' on Windows"
    echo ""
    echo "🎮 Presentation Controls:"
    echo "   • Arrow keys: Navigate slides"
    echo "   • F key: Fullscreen mode"
    echo "   • ESC key: Exit fullscreen"
    echo ""
    echo "📚 For PDF export, run:"
    echo "   marp slides.md -o presentation.pdf --theme default"
else
    echo "❌ Error generating presentation. Please check slides.md for syntax errors."
    exit 1
fi

# Optional: Generate PDF if requested
read -p "🤔 Would you like to generate a PDF version as well? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔄 Generating PDF presentation..."
    marp slides.md -o foobar-flutter-firebase-presentation.pdf --theme default --allow-local-files
    
    if [ $? -eq 0 ]; then
        echo "✅ PDF presentation generated successfully!"
        echo "📄 Output file: foobar-flutter-firebase-presentation.pdf"
    else
        echo "❌ Error generating PDF. This may require additional setup."
        echo "💡 Try installing Chrome/Chromium for PDF generation support."
    fi
fi

echo ""
echo "🎉 Documentation generation complete!"
echo "📁 Available files in the doc directory:"
ls -la *.md *.html *.pdf 2>/dev/null || ls -la *.md *.html 2>/dev/null || ls -la *.md

echo ""
echo "📖 Next steps:"
echo "   1. Review the generated presentation"
echo "   2. Customize slides.md if needed"
echo "   3. Use in your classroom or learning environment"
echo "   4. Share with students and colleagues"
