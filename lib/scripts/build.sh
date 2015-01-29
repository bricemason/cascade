#!/bin/sh

# directory path for the current script
SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $SCRIPTDIR

BUILDTYPE=$1
ANDROIDCONNECTED=
APPNAME=`cat ../app.json | grep "\"name\"" | awk -F\" '{print $4}'`
APKFILE="cordova/platforms/android/ant-build/${APPNAME}-debug.apk"

# ensure a build type is specified
if [ $# = 0 ]; then
    echo "Please specify a build type (testing, production, native)."
    exit 1
fi

# change to the app directory
cd ..

# run the build
sencha app build $BUILDTYPE

if [ $BUILDTYPE = "native" ]; then
    # check if an android device is connected
    ANDROIDCONNECTED=$(adb devices | grep 'device$')

    # if an android device is connected, deploy the debug build
    if [ "$ANDROIDCONNECTED" != "" ]; then
        if [ ! -e "$APKFILE" ]; then
            # protect against cordova 4.0+ app renaming
            APKFILE="cordova/platforms/android/ant-build/CordovaApp-debug.apk"
        fi

        adb -d install -r $APKFILE
    fi
fi

cd scripts

say "Build complete"
