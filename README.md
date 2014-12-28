# Cascade
## Scaffolding and Build Scripts for Sencha Touch

Cascade is a set of bash scripts used for quickly scaffolding and building Sencha Touch applications. It's main purpose is to quickly generate apps for testing. The build scripts take the following opinion when scaffolding apps:

1. Apps will be generated as cordova hybrid apps supporting iOS and Android
2. Apps will generate a base sass theme
3. The base sass theme includes the [ionicons](https://github.com/driftyco/ionicons) icon font

### Getting Started

Once you've cloned the repo, you'll probably want to make a few modifications to the config.sh file. This file defines a few global variables used in the scaffold script. The three variables you'll want to modify are:

- SDKDIR - This is the path to the Sencha Touch framework on your system
- APPSDIR - This is the path to the directory where you want to generate your apps to
- CORDOVADOMAIN - The base domain namespace for identifying your cordova app

#### Scaffolding

To generate your first app, run the scaffold.sh script:

`./scaffold.sh [APPNAME] [APPDIRNAME]`

An example scaffold might look like this:

`./scaffold.sh MyApp my-app`

#### Building

Once your app has been generated, there will be a build.sh script under the `scripts` directory of your app. To execute a build run the following command:

`./build.sh [BUILDTYPE]`

Where `[BUILDTYPE]` is one of:

- testing
- production
- native

If a native build is chosen, the script will check if an android device is connected. If it is, the debug .apk will be deployed to the device.

An example native build command would look like this:

`./build.sh native`
