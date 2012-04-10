# Pull in 'config.sh'
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
CURDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
source "${CURDIR}/config.sh"

function repo_data () {
  curl -s "${OLD_GITHUB}/api/v2/json/repos/show/${OLD_ORGNAME}" |
    underscore extract 'repositories' |
    underscore map -q "console.log('%s\t%s\t%s', value.name, value.description, value.homepage)"
}

repo_data | while read REPO DESC HOME; do

  log "Creating $NEW_ORGNAME/$REPO on $NEW_GITHUB"

  curl -is -X POST -k ${NEW_GITHUB_HTTP}/organizations/${NEW_ORGNAME}/repositories \
  -F authenticity_token="${AUTH_TOKEN}" \
  -F "repository[name]=${REPO}" \
  -F "repository[description]=${DESC}" \
  -F "repository[homepage]=${HOME}" \
  -F 'repository[public]=true' \
  -F team_id=${TEAM_ID} \
  -b "${COOKIE_TEXT}"

done
