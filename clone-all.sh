

# Pull in 'config.sh'
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
CURDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
source "${CURDIR}/config.sh"

function repositories () {
  curl -s "${OLD_GITHUB_HTTP}/api/v2/json/repos/show/${OLD_ORGNAME}" |
    underscore extract 'repositories' |
    underscore map -q 'console.log(value.name)'
}

set -e
repositories | while read REPO; do
  REPO=$REPO
  log "Cloning $OLD_ORGNAME/$REPO ..."
  echo "git clone ${OLD_GITHUB_GITPREFIX}${OLD_ORGNAME}/${REPO}.git"
  git clone ${OLD_GITHUB_GITPREFIX}${OLD_ORGNAME}/${REPO}.git
  cd ${REPO}
  echo "git remote add newrepo ${NEW_GITHUB_GITPREFIX}${NEW_ORGNAME}/${REPO}.git"
  git remote add newrepo ${NEW_GITHUB_GITPREFIX}${NEW_ORGNAME}/${REPO}.git
done


