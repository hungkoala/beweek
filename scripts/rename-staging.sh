set -e

# step 1: export env
if [ "$APP_SCHEME" = "STAGING" ]; then
    export $(cat environment/staging/.env | sed 's/#.*//g' | xargs)
elif [ "$APP_SCHEME" = "DEVELOPMENT" ]; then
    export $(cat environment/development/.env | sed 's/#.*//g' | xargs)
elif [ "$APP_SCHEME" = "PRODUCTION" ]; then
    export $(cat environment/production/.env | sed 's/#.*//g' | xargs)
else
    echo "Environment variable APP_SCHEME not found, please setup environment variable"
    exit 1
fi

echo "APP_SCHEME=$APP_SCHEME, PLATFORM=$PLATFORM, AUTH0_DOMAIN=$AUTH0_DOMAIN"

# Rename App for staging environment
if [ "$APP_SCHEME" = "STAGING" ]; then
    rm -rf android/app/src/main/java/care/zoop/bewell/staging/ || true
    rm -rf android/app/src/debug/java/care/zoop/bewell/staging || true
    rm -rf ios/BewellStaging-Bridging-Header.h || true
    rm -rf ios/BewellStaging.xcodeproj/ || true
    rm -rf ios/BewellStaging/ || true
    rm -rf ios/BewellStagingTests/ || true

    if [ "$PLATFORM" = "ANDROID" ]; then
        git status
        # Apply react-native-rename for android
        npx react-native-rename --skipGitStatusCheck "BewellStaging" -b "care.zoop.bewell.staging"
        git restore --staged .
        cd ios && git checkout -- . && cd ..

        # Update Firebase google-services.json
        cp environment/staging/google-services.json android/app/google-services.json

        # Update Appcenter appcenter-config.json
        cp environment/staging/appcenter-config.json android/app/src/main/assets/appcenter-config.json

        # Update codepush deployment key for android
        gsed -i "s/$(cat environment/production/ANDROID_CODEPUSH_KEY)/$(cat environment/staging/ANDROID_CODEPUSH_KEY)/g" android/app/src/main/res/values/strings.xml
        # gsed -i "s/\"Bewell\"/\"BewellStaging\"/g" app.json

        gsed -i "s/\"care.zoop.bewell\"/\"care.zoop.bewell.staging\"/g" android/app/src/debug/AndroidManifest.xml
        gsed -i "s/package care.zoop.bewell/package care.zoop.bewell.staging/g" android/app/src/main/java/care/zoop/bewell/staging/CustomActivity.java

        gsed -i "s/BewellStagingStaging/Bewell Staging/g" app.json
        gsed -i "s/\"bewellstagingstaging\"\,/\"BewellStaging\"\,/g" package.json

        # remove ios code
        rm -rf ios/BewellStaging-Bridging-Header.h || true
        rm -rf ios/BewellStaging.xcodeproj/ || true
        rm -rf ios/BewellStaging/ || true
        rm -rf ios/BewellStagingTests/ || true

    else
        bundle install
        # Apply Inline replace App name and bundle ID for iOS
        gsed -i 's/care\.zoop\.bewell/care\.zoop\.bewell\.staging/g' ios/Bewell.xcodeproj/project.pbxproj
        gsed -i 's/Bewell/Bewell Staging/g' ios/Bewell/info.plist

        # Update Firebase GoogleService-Info.plist
        cp environment/staging/GoogleService-Info.plist ios/GoogleService-Info.plist

        # Update Firebase AppCenter-Config.plist
        cp environment/staging/AppCenter-Config.plist ios/AppCenter-Config.plist

        # Update codepush deployment key for ios
        gsed -i "s/$(cat environment/production/IOS_CODEPUSH_KEY)/$(cat environment/staging/IOS_CODEPUSH_KEY)/g" ios/Bewell/Info.plist

        # Update bundle name for ios
        gsed -i "s/@\"Bewell\"/@\"BewellStaging\"/g" ios/Bewell/AppDelegate.mm
        gsed -i "s/\"Bewell\"/\"BewellStaging\"/g" app.json
    fi
fi

# Rename App for staging development
if [ "$APP_SCHEME" = "DEVELOPMENT" ]; then
    if [ "$PLATFORM" = "ANDROID" ]; then
        # Apply react-native-rename for android
        # npx react-native-rename "Bewell Dev" -b care.zoop.bewell

        # Update Firebase google-services.json
        # cp environment/development/google-services.json android/app/google-services.json

        # Update Appcenter appcenter-config.json
        cp environment/development/appcenter-config.json android/app/src/main/assets/appcenter-config.json

        # Update codepush deployment key for android
        gsed -i "s/$(cat environment/production/ANDROID_CODEPUSH_KEY)/$(cat environment/staging/ANDROID_CODEPUSH_KEY)/g" android/app/src/main/res/values/strings.xml
        gsed -i "s/\"Bewell\"/\"BewellDev\"/g" app.json

    else
        bundle install
        # Apply Inline replace App name and bundle ID for iOS
        # gsed -i 's/care\.zoop\.bewell/care\.zoop\.bewell\.staging/g' ios/Bewell.xcodeproj/project.pbxproj
        # gsed -i 's/Bewell/Bewell Dev/g' ios/Bewell/info.plist

        # Update Firebase GoogleService-Info.plist
        # cp environment/development/GoogleService-Info.plist ios/GoogleService-Info.plist

        # Update Firebase AppCenter-Config.plist
        cp environment/development/AppCenter-Config.plist ios/AppCenter-Config.plist

        # Update codepush deployment key for ios
        gsed -i "s/$(cat environment/production/IOS_CODEPUSH_KEY)/$(cat environment/development/IOS_CODEPUSH_KEY)/g" ios/Bewell/Info.plist

        # Update bundle name for ios
        # gsed -i "s/@\"Bewell\"/@\"BewellDev\"/g" ios/Bewell/AppDelegate.m
        # gsed -i "s/\"Bewell\"/\"BewellDev\"/g" app.json
    fi
fi

# copy .env file
if [ "$APP_SCHEME" = "STAGING" ]; then
    # Copy environment staging
    cp environment/staging/.env .env

elif [ "$APP_SCHEME" = "DEVELOPMENT" ]; then
    # Copy environment development
    cp environment/development/.env .env
elif [ "$APP_SCHEME" = "PRODUCTION" ]; then
    # Copy environment production
    cp environment/production/.env .env
fi

gsed -i "s/\"BUILD_NUMBER\"/\"${APPCENTER_BUILD_ID}\"/g" package.json

# Update AUTH0 domain url
gsed -i "s/bewell-development.jp.auth0.com/${AUTH0_DOMAIN}/g" android/app/build.gradle
gsed -i "s/bewell-production.jp.auth0.com/${AUTH0_DOMAIN}/g" android/app/build.gradle
gsed -i "s/bewell-staging.jp.auth0.com/${AUTH0_DOMAIN}/g" android/app/build.gradle

echo "end of rename staging -------------------------------------------------"
# exit 1;
