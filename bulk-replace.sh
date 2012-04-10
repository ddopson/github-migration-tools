# Pull in 'config.sh'
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
CURDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
source "${CURDIR}/config.sh"

while true; do
  for d in *; do
    if [ ! -d $d ]; then
      continue;
    fi
    echo
    echo "Entering '$d' ..."
    cd $d
    git fetch origin
    for b in $(git branch -a | grep origin | perl -pe 's#.*remotes/origin/([^ \n\t]+).*#$1#' | grep -v HEAD); do
      git co -f "$b"
      CHANGE=
      for f in $(ack -l ${OLD_GITHUB} --all); do
        perl -pe "s/${OLD_GITHUB}/${NEW_GITHUB}/g" -i "$f"
        CHANGE=yes
        git add "$f"
      done
      if [ ! -z "$CHANGE" ]; then
        git commit -m "Bulk Migration: ${OLD_GITHUB} --> ${NEW_GITHUB}"
      fi
    done
    git push --all newrepo
    cd -
  done  | egrep -v "Already up-to-date|$(pwd)"
done
