#!/bin/sh

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
echo "Current working directory: $(pwd)" # print the current working directory.
cd $CI_PRIMARY_REPOSITORY_PATH # change working directory to the root of your cloned repo.

# Install Flutter using git.
echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Installing melos globally.
echo "Installing Melos..."
dart pub global activate melos

# Install Flutter artifacts for iOS (--ios), or macOS (--macos) platforms.
echo "Installing Flutter artifacts..."
flutter precache --ios

# Install Flutter dependencies.
echo "Installing Flutter dependencies..."
flutter pub get

# Install CocoaPods using Homebrew.
HOMEBREW_NO_AUTO_UPDATE=1 # disable homebrew's automatic updates.
echo "Installing CocoaPods..."
brew install cocoapods

# Install Melos dependencies.
echo "Installing Melos dependencies..."
melos bootstrap

# Run Melos build_runner.
echo "Running Melos build_runner..."
melos run build_runner

# Install CocoaPods dependencies.
echo "Installing CocoaPods dependencies..."
cd ios && pod install # run `pod install` in the `ios` directory.

exit 0