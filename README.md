# my_carpool_app

Sample Car Pool Mobile App.

## Getting Started

This repository has sample Flutter and Dart code that create a carpool mobile app.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to build and test this app in 4 steps, on macos and iOS simulator
```
cd mycarpool
# optional: use flutter clean when a fix need to be updated in pubspec.yaml file
flutter clean
# optional: use flutter pub get , when pubspec.yaml is changed
flutter pub get
# flutter test will compile the code and runs the tests
flutter test
flutter run
```
## How to add a new app icon
1. Create a new icon and place the image file to lib/assets/icons/ folder
2. Update pubspec.yaml file, assuming icon_v1.png is the icon file name
```
flutter_icons:
  ios: true
  image_path_ios: "lib/assets/icons/icon_v1.png"
```
3. Run below commands to generate icons using the above image
```
dart pub global activate flutter_launcher_icons
dart pub global run flutter_launcher_icons:main
# Run the icon generator
dart run flutter_launcher_icons:main
```
4. Validate icons are created by checkig the iOS folder 
5. Build and Run the app
```
flutter clean
flutter run
```