YELLOW="\033[38;5;226m"
NOCOLOR="\033[39;0m"

function log() {
  echo
  echo -e "${YELLOW}$*${NOCOLOR}"
}

OLD_GITHUB='FILL_THIS_IN' # eg github.com
NEW_GITHUB='FILL_THIS_IN' # eg github.company.com

OLD_ORGNAME='FILL_THIS_IN'
NEW_ORGNAME='FILL_THIS_IN'

# HTTP vs HTTPS - you can change that here
OLD_GITHUB_HTTP="http://${OLD_GITHUB}"
NEW_GITHUB_HTTP="https://${NEW_GITHUB}"

OLD_GITHUB_GITPREFIX="git@${OLD_GITHUB}:"
NEW_GITHUB_GITPREFIX="git@${NEW_GITHUB}:"



# Filling in Auth Data for Github:
# 0) Open '${NEW_GITHUB_HTTP}/organizations/${NEW_ORGNAME}/repositories/new' in Chrome.  Open the Developer Console
# 1) Create a repo manually, and look at the 'Network' tab in Chrome's developer console
# 2) Copy (Dev Console -> Network -> select the POST request to 'repositories' -> Headers tab -> Request Headers section -> Cookie)
# e.g. COOKIE_TEXT='tracker=direct; _fi_sess=NCh7CjoMY29udG84thefNdzoJdXFlcmkZOg9zZXFzaW9uX2lkIiU3MGYzZjllYzllMDY1FGM0FDdiZGIxMGY4FNEyFDFhZNoQX2FzcmZfdG9rZW4iMWxpRnFjRNdFMEsyVzhDWXNORWdGWEdaNWh1Q1lMbUMwRWp6VUI3Mmw5M1k9OhNmaW5nZXJwcmludCIlMDhhFjMxFjY2ZjEyYzkxFjIyMzgyOGJlMWI0Nosovig%3D--0ac65914205ac86e4b4b285683d23f91ca307d3; _gh_manage=NCh8CC%3D%3D%0C--f816de4f77aa285ba407eaba94bd1ca'
# 3) Copy (Dev Console -> Network -> select the POST request to 'repositories' -> Headers tab -> Form Data section -> authenticity_token)
# e.g. AUTH_TOKEN=liFqcE7E0K2W8UbRySvot3cMhuCYLto9emYUB72l93Y=
# 4) Copy (Dev Console -> Network -> select the POST request to 'repositories' -> Headers tab -> Form Data section -> team_id)
# e.g. TEAM_ID=80


COOKIE_TEXT='_FILL_THIS_IN__HUGE_BLOCK_OF_COOKIE_TEXT'
AUTH_TOKEN='FILL_THIS_IN'
TEAM_ID='FILL_THIS_IN'




if [ "$OLD_ORGNAME" = "FILL_THIS_IN" ]; then
  echo "You must edit 'config.sh' first!"
  exit 1
fi



