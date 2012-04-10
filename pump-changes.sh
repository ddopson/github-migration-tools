
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
      git co -f $b
      git pull origin $b
    done
    git push --all newrepo
    cd -
  done  | egrep -v "Already up-to-date|$(pwd)"
done
