#!/bin/bash

# Fail this script if any subcommand fails.
set -e

# The default execution directory of this script is the ci_scripts directory.
echo "Current working directory: $(pwd)" # print the current working directory.
cd $CI_PRIMARY_REPOSITORY_PATH

# Check if required environment variables are set
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ] || [ -z "$POWERSYNC_URL" ] || \
   [ -z "$WEB_CLIENT_ID" ] || [ -z "$ANDROID_CLIENT_ID" ] || [ -z "$IOS_CLIENT_ID" ] || \
   [ -z "$SUPABASE_AUTH_EXTERNAL_GOOGLE_SECRET" ]; then
  echo "Error: One or more required environment variables are missing"
  exit 1
fi

# Define .env file paths
PROD_ENV_FILE=".env.prod"
DEV_ENV_FILE=".env.dev"

# Create the .env.prod file with the variables for production
echo "Creating ${PROD_ENV_FILE} with the production variables..."

cd packages/env/

cat > "$PROD_ENV_FILE" <<EOF
SUPABASE_URL=$SUPABASE_URL
SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
POWERSYNC_URL=$POWERSYNC_URL

WEB_CLIENT_ID=$WEB_CLIENT_ID
ANDROID_CLIENT_ID=$ANDROID_CLIENT_ID
IOS_CLIENT_ID=$IOS_CLIENT_ID

SUPABASE_AUTH_EXTERNAL_GOOGLE_SECRET=$SUPABASE_AUTH_EXTERNAL_GOOGLE_SECRET
EOF

# Create the .env.dev file with the variables for development
echo "Creating ${DEV_ENV_FILE} with the development variables..."

cat > "$DEV_ENV_FILE" <<EOF
SUPABASE_URL=$SUPABASE_URL
SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
POWERSYNC_URL=$POWERSYNC_URL

WEB_CLIENT_ID=$WEB_CLIENT_ID
ANDROID_CLIENT_ID=$ANDROID_CLIENT_ID
IOS_CLIENT_ID=$IOS_CLIENT_ID

SUPABASE_AUTH_EXTERNAL_GOOGLE_SECRET=$SUPABASE_AUTH_EXTERNAL_GOOGLE_SECRET
EOF

echo cat $PROD_ENV_FILE
echo cat $DEV_ENV_FILE

# Confirm creation of the files
echo ".env.prod and .env.dev files have been created successfully."

cd $CI_PRIMARY_REPOSITORY_PATH

# Add Flutter, Dart, and Melos to PATH
export PATH="$PATH:$HOME/flutter/bin:$HOME/flutter/bin/cache/dart-sdk/bin:$HOME/.pub-cache/bin"

# Ensure Dart is installed
dart --version

# Activate Melos globally if not available
if ! command -v melos &> /dev/null; then
    echo "Melos not found, activating it..."
    dart pub global activate melos
fi

# Ensure Melos is installed
melos --version

# Install dependencies
melos bootstrap

# Run build_runner
melos run build_runner --no-select

exit 0