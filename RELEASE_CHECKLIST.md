# Release Checklist

This checklist outlines the steps to follow when preparing a new release of the BijbelQuiz app.

## Pre-Release Steps

- [ ] Update the version in `pubspec.yaml`
- [ ] Update the version in `app/android/app/build.gradle`
- [ ] Update all version numbers in `websites/bijbelquiz.app/download.html`
- [ ] Review and update the changelog or release notes
- [ ] Ensure all tests pass (`flutter test`)
- [ ] Run code analysis (`flutter analyze`)

## Build Steps

- [ ] Run the build script at `app/build_all.sh`


## Deployment Steps

- [ ] Upload all files to `websites/bijbelquiz.app/downloads`
- [ ] Copy the web output to `websites/play.bijbelquiz.app`
- [ ] Upload Android AAB to Google Play Console
- [ ] Update download links on the website
- [ ] Create a release on GitHub with all applicable files