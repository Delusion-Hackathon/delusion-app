# Delusion App

## Topology Drawing Application

This Flutter application allows users to create a network topology by dragging and dropping endpoint icons (like Switch, Router, Phone, and Server) onto a canvas and then drawing lines to connect these endpoints. The app features a side panel with draggable icons and a main canvas area where users can drop these icons and draw connections between them.

### Features

- Draggable Endpoints: Users can drag endpoints (Switch, Router, Phone, Server) from the side panel onto the canvas.
- Droppable Canvas: The main canvas area accepts dropped endpoints and displays them.
- Drawing Connections: Users can draw lines between endpoints by dragging on the canvas.

### Project Structure
```
├── lib
│   ├── main.dart
├── assets
│   └── images
│       ├── switch.png
│       ├── router.png
│       ├── mobile_phone.png
│       └── server.png
└── pubspec.yaml
```

### Getting Started
#### Prerequisites
Ensure you have Flutter installed on your machine. You can download Flutter from the official Flutter website.

#### Installation

1. Clone the repository:
```
git clone https://github.com/Delusion-Hackathon/delusion-app
cd delusion-app
```

2. Fetch the dependencies:
```
flutter pub get
```

3. Run the application:
```
flutter run
```

### Assets
Ensure you have the following images in the assets/images directory:
- `switch.png`
- `router.png`
- `mobile_phone.png`
- `server.png`

Update the `pubspec.yaml` to include the assets:

```
flutter:
  assets:
    - assets/images/switch.png
    - assets/images/router.png
    - assets/images/mobile_phone.png
    - assets/images/server.png
```
