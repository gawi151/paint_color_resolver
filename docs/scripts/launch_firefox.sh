#!/bin/bash
# Flutter Firefox Launch Script for Linux/Mac
# Usage: ./scripts/launch_firefox.sh

echo "Starting Flutter web server..."
echo ""

flutter run -d web-server --web-port=8080 --web-hostname=localhost &
FLUTTER_PID=$!

echo "Waiting for server to start..."
sleep 5

echo "Opening Firefox..."
if command -v firefox &> /dev/null; then
    firefox http://localhost:8080 &
elif command -v open &> /dev/null; then
    open -a Firefox http://localhost:8080
else
    echo "Firefox not found. Please open http://localhost:8080 manually."
fi

echo ""
echo "Firefox launched! The app should open at http://localhost:8080"
echo "Press Ctrl+C to stop the Flutter web server (PID: $FLUTTER_PID)."
echo ""

wait $FLUTTER_PID
