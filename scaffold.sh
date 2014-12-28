#!/bin/sh

# load configuration
source config.sh

APPNAME=$1
PROJECTDIR="$APPSDIR/$2"
CORDOVANAMESPACE="$CORDOVADOMAIN.$APPNAME"
FONTSDIR="$PROJECTDIR/resources/fonts"
SASSDIR="$PROJECTDIR/resources/sass"
THEMENAME="$APPNAME-theme"
THEMEDIR="$SASSDIR/$THEMENAME"
THEMELIBDIR="$THEMEDIR/lib"
SCRIPTSDIR="$PROJECTDIR/scripts"

banner

# make sure the sdk directory exists
if [ ! -e "$SDKDIR" ]; then
    echo "The SDKDIR directory $SDKDIR does not exist"
    exit 1
fi

# make sure we have two arguments passed in
if [ "$#" != 2 ]; then
    echo "You must pass in an app name and project directory name."
    exit 1
fi

# make sure the project directory doesn't already exist
if [ -e "$PROJECTDIR" ]; then
    echo "The project directory $PROJECTDIR already exists"
    exit 1
fi

# create a sencha workspace in the apps directory if one doesn't already exist
if [ ! -e "$APPSDIR/.sencha" ]; then
    sencha -sdk $SDKDIR generate workspace $APPSDIR

    # handle errors
    RC=$?
    if [ $RC != 0 ]; then
        echo "Error attempting to create sencha workspace."
        exit 1
    fi
fi

# generate the sencha app
cd $FRAMEWORKDIR && sencha generate app $APPNAME $PROJECTDIR

# handle errors
RC=$?
if [ $RC != 0 ]; then
    echo "Error attempting to generate application."
    exit 1
fi

# change to the project directory
cd $PROJECTDIR

# generate the cordova projects
sencha cordova init $CORDOVANAMESPACE

# support ios and android platforms
echo "cordova.platforms=ios android" > cordova.local.properties

# copy over the scripts
cp -r $LIBSCRIPTSDIR $SCRIPTSDIR

# download ionicons if we need to
if [ ! -e $IONICONSDIR ]; then
    cd $LIBDIR

    git clone https://github.com/driftyco/ionicons.git

    cd $PROJECTDIR
fi

# create the fonts directory in the app
mkdir $FONTSDIR

# copy the ionicons font set to the app
cp $IONICONSDIR/fonts/* $FONTSDIR

# copy the base theme over to the app
cp -r $BASETHEMEDIR "$THEMEDIR"

# create the theme lib directory
mkdir $THEMELIBDIR

# copy ionicons to the theme
cp -r $IONICONSDIR "$THEMELIBDIR"

# add ionicons to the font partial in the theme
echo "@import 'lib/ionicons/scss/ionicons';" > "$THEMEDIR/_fonts.scss"

# hook in the theme
echo "@import '$THEMENAME/theme';" > "$SASSDIR/app.scss"

# compile styles
cd $SASSDIR && compass compile --force

cd $SCRIPTDIR

say "Scaffold complete"