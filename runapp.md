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
        "--dart-define","GITHUB_ISSUE_TOKEN=X",
        "--dart-define","IRBS_SERVER_URL=https://swc.iitg.ac.in/test/irbs",
        "--dart-define","GATELOG_WEBSOCKET_URL=wss://swc.iitg.ac.in/test/khokhaEntry/api/v1/ws",
        "--dart-define","GATELOG_SERVER_URL=https://swc.iitg.ac.in/test/khokhaEntry/api/v1",
        "--dart-define","MODERATION_SERVER_URL=https://swc.iitg.ac.in/onestopModerate",
        "--dart-define","EVENT_SERVER_URL=https://swc.iitg.ac.in/events"
    ]
}
```
