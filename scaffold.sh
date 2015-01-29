#!/bin/sh

# load configuration
source config.sh

WITHMARCY=0
APPNAME=$1
APPDIR=$2

# if there are three arguments, the first one must be asking
# to include the marcy framework
if [ "$#" = 3 ]; then
    if [ $1 = "-marcy" ]; then
        WITHMARCY=1
        APPNAME=$2
        APPDIR=$3
    else
        errorIncorrectParameter
        exit 1
    fi
elif [ "$#" != 2 ]; then
    errorIncorrectParameter
    exit 1
fi

PROJECTDIR="$APPSDIR/$APPDIR"
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

# pull down the base marcy theme
git clone https://github.com/bricemason/theme-marcy.git $THEMEDIR

# create the theme lib directory
mkdir $THEMELIBDIR

# copy ionicons to the theme
cp -r $IONICONSDIR "$THEMELIBDIR"

# add ionicons to the font partial in the theme
echo "@import 'lib/ionicons/scss/ionicons';" >> "$THEMEDIR/_fonts.scss"

# hook in the theme
echo "@import '$THEMENAME/theme';" > "$SASSDIR/app.scss"

# compile styles
cd $SASSDIR && compass compile --force

# patch in the cordova library
cd $PROJECTDIR
touch cordova.js

if [ $WITHMARCY = 1 ]; then
    # pull down the framework
    git clone https://github.com/bricemason/marcy lib/marcy

    # copy over the Application class template
    cp "$MARCYTEMPLATEDIR/Application.js" "$PROJECTDIR/app/Application.js"

    # copy over the app.js template
    cp "$MARCYTEMPLATEDIR/app.js" "$PROJECTDIR/app.js"

    # add marcy to the classpath
    sed -i.bak 's@app.classpath=${app.dir}/app.js,${app.dir}/app@&,${app.dir}/lib/marcy@' "$PROJECTDIR/.sencha/app/sencha.cfg"

    # modify the Application.js and app.js files to use the proper app name
    sed -i '' "s@MyApp@$APPNAME@" "$PROJECTDIR/app/Application.js"
    sed -i '' "s@MyApp@$APPNAME@" "$PROJECTDIR/app.js"

    # since we modified the class path, we need to refresh the build
    sencha app refresh
fi

# initialize the native projects by running a build
cd $SCRIPTSDIR
./build.sh native

cd $SCRIPTDIR

say "Scaffold complete"