DEV_INITIALS=uvb
RELEASE_MAJOR_MINOR=3.35
RELEASE_PATCH=0
RELEASE_PRE='' # or '' for stable release
VERSION_PREFIX='v' # for madek its 'v' 

RELEASE_MAIN="${RELEASE_MAJOR_MINOR}.${RELEASE_PATCH}"
RELEASE="${RELEASE_MAIN}${RELEASE_PRE}"
RELEASE_NAME="${VERSION_PREFIX}${RELEASE}"

echo "RELEASE_MAIN: $RELEASE_MAIN"
echo "RELEASE: $RELEASE"
echo "RELEASE_NAME: $RELEASE_NAME"