# Pull in 'config.sh'
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
CURDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
source "${CURDIR}/config.sh"

function repositories () {
    curl -s "${OLD_GITHUB}/api/v2/json/repos/show/${OLD_ORGNAME}" | underscore extract 'repositories'
}

if [ "$2" = "-v" ]; then
  repositories 
else 
  repositories | underscore map -q "
  nl=_.max(_.map(list, function (el) { return el.name.length; })),
  pattern='$OLD_ORGNAME\t%-' + nl + 's\t%s\t%s',
  console.log(_.sprintf(pattern, value.name, value.description, value.homepage))"
fi
