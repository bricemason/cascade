# ==================================================
# Acts as a configuration file.
# The most common variables to modify to suit your environment are:
# - SDKDIR - Path to the Sencha Touch framework
# - APPSDIR - Target directory where apps are scaffolded
# - CORDOVADOMAIN - Domain to use for identifying cordova app
# ==================================================

#!/bin/sh

# directory path for the current script
SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Path to the Sencha SDK to use for app generation
SDKDIR="$HOME/lib/touch-2.4.0"

# directory where apps will be generated
APPSDIR="$HOME/projects"

# default domain used for the cordova namespace
CORDOVADOMAIN=com.example

# directory where supporting libraries are downloaded
LIBDIR="$SCRIPTDIR/lib"

# directory where the standard build scripts are
LIBSCRIPTSDIR="$LIBDIR/scripts"

# directory where ionicons is downloaded
IONICONSDIR="$LIBDIR/ionicons"

# directory for the base theme
BASETHEMEDIR="$LIBDIR/base-theme"

# directory for marcy template assets
MARCYTEMPLATEDIR="$LIBDIR/marcy-templates"

function banner {
    echo "=================================================="
    echo "Cascade"
    echo "Scaffolding and build scripts for Sencha Touch"
    echo "https://github.com/bricemason/cascade"
    echo "=================================================="
}

function errorIncorrectParameter {
    banner
    echo "Scaffold a default Sencha Touch application"
    echo "./scaffold.sh <applicationName> <applicationDirectory>"
    echo
    echo "Scaffold an app with the Marcy framework (https://github.com/bricemason/marcy):"
    echo "./scaffold.sh -marcy <applicationName> <applicationDirectory>"
}