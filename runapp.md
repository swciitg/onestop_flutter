To run the App on your machine, Follow these Steps Carefully

## Step I Go this location
![image](https://github.com/swciitg/onestop_flutter/assets/112700624/ef500cf3-56ab-4496-925e-2a84604b9282)
## Step II Copy runArgs from [here](runargs)
## Step III Paste them here
![image](https://github.com/swciitg/onestop_flutter/assets/112700624/8ff5fa9c-4568-42a3-aa84-2bd3fd08f466)

## If you use Flutter run, then modify your command to "flutter run [runargs](runargs) "

##  or use vscode launch.json configuration
```json
{
    "name": "OneStop Dev",
    "request": "launch",
    "type": "dart",
    "program": "lib/main.dart",
    "args": [
        "--flavor", "dev",
        "--dart-define", "ENV=dev",
        "--dart-define","SERVER_URL=https://swc.iitg.ac.in/test/onestop/api/v3",
        "--dart-define","SECURITY_KEY=0ne5t0p-Test",
        "--dart-define","GMAP_KEY=gmapkey",
        "--dart-define","GIT_ISSUE_TOKEN=X",
        "--dart-define","IRBS_SERVER_URL=https://swc.iitg.ac.in/test/irbs",
        "--dart-define","GATELOG_WEBSOCKET_URL=wss://swc.iitg.ac.in/test/khokhaEntry/api/v1/ws",
        "--dart-define","GATELOG_SERVER_URL=https://swc.iitg.ac.in/test/khokhaEntry/api/v1",
        "--dart-define","MODERATION_SERVER_URL=https://swc.iitg.ac.in/onestopModerate",
        "--dart-define","EVENT_SERVER_URL=https://swc.iitg.ac.in/events"
    ]
}
```

**Don't use "--flavor dev" for IOS builds, flavors for IOS is yet to be implemented.**

---

## Building the App (Release)

Use the interactive build script to create release builds:

```bash
./build.sh
```

The script will ask:
1. **Environment** — `1` for dev, `2` for prod
2. **Build type** — `1` for appbundle (Play Store), `2` for apk, `3` for ipa (iOS)

It reads env vars from `.env.dev` or `.env.prod` (gitignored — do not commit these), shows the final command for review, and asks for confirmation before building.

### Setting up env files

Copy the template and fill in the values:

```bash
# For dev
cp .env.dev.example .env.dev   # or create .env.dev manually

# For prod
cp .env.prod.example .env.prod  # or create .env.prod manually
```

The env files use a simple `KEY=value` format:

```
ENV=dev
SERVER_URL=https://...
SECURITY_KEY=...
GMAP_KEY=...
GIT_ISSUE_TOKEN=...
IRBS_SERVER_URL=https://...
GATELOG_WEBSOCKET_URL=wss://...
GATELOG_SERVER_URL=https://...
MODERATION_SERVER_URL=https://...
EVENT_SERVER_URL=https://...
LIB_TOKEN_SOCKET_URL=wss://...
LIB_TOKEN_BASE_URL=https://...
```

> **Note:** `.env.dev` and `.env.prod` are gitignored. Never commit them.
