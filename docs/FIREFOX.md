# Running Flutter App in Firefox

Flutter does not natively support Firefox as a device target on Windows. Only Chrome and Edge are auto-detected.

This document provides two methods to run the app in Firefox.

---

## Method 1: Automated Script (Recommended)

### Windows

Run the batch script:
```bash
docs\scripts\launch_firefox.bat
```

### Linux/Mac

Make the script executable and run it:
```bash
chmod +x docs/scripts/launch_firefox.sh
./docs/scripts/launch_firefox.sh
```

**What it does:**
1. Starts Flutter web server on `localhost:8080`
2. Automatically opens Firefox
3. Displays the app in Firefox with hot reload support

Press `Ctrl+C` to stop the server when done.

---

## Method 2: Manual Steps

### Step 1: Start the Web Server
```bash
flutter run -d web-server --web-port=8080
```

This starts a development server without opening a browser.

### Step 2: Open Firefox

Navigate to: `http://localhost:8080`

### Step 3: Development

Changes will hot reload automatically. Check the terminal for hot reload confirmations.

### Step 4: Stop the Server

Press `Ctrl+C` in the terminal to stop the server.

---

## Why Firefox Isn't Auto-Detected

Flutter's device discovery only recognizes:
- `chrome` - Google Chrome
- `edge` - Microsoft Edge (Windows only)
- `windows` - Windows desktop app

Firefox is not in Flutter's supported web device list. The workaround is to use `web-server` mode, which starts an HTTP server without launching a specific browser.

---

## Troubleshooting

### Script doesn't open Firefox

**Windows:** Ensure Firefox is installed and in your PATH, or edit `launch_firefox.bat` to use the full path:
```bat
start "C:\Program Files\Mozilla Firefox\firefox.exe" http://localhost:8080
```

**Linux/Mac:** Install Firefox via your package manager:
```bash
# Ubuntu/Debian
sudo apt install firefox

# macOS
brew install firefox
```

### Port 8080 already in use

Change the port in the script or manual command:
```bash
flutter run -d web-server --web-port=3000
```

Then open `http://localhost:3000` in Firefox.

### Hot reload not working

Refresh the Firefox tab manually with `Ctrl+R` or `F5`.
