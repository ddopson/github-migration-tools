# Overview

This tool is designed to automate the process of porting an entire organization with many individual projects from one Github deployment to a new Github deployment.  

The phases involved in migration are described below:

# Prerequisites

Some of the scripts make use of other tools.  You need to install:

 * [underscore-cli] (https://github.com/ddopson/underscore-cli) - used to parse JSON data from the github APIs.  Implies installing Node.js, but that is very easy and the steps are described on the underscore-cli page.
 * [ack] (http://betterthangrep.com/) - "Better than grep" - used in 'bulk-replace.sh'. You could convert all the ack references to use grep, but ACK is an awesome tool and you should check it out.

# Phase Zero: Edit 'config.sh'

### Filling in the basics

Most of the values are pretty easy, like OLD_ORGNAME for the name of the github org being migrated, and OLD_GITHUB for the host name of the github server.  You can also change whether to access github with HTTPS or not as some deployments require it, and others don't support HTTPS.

So, something like this:

    OLD_GITHUB='github.com'
    NEW_GITHUB='github.company.com'
    OLD_ORGNAME='myOrganization'
    NEW_ORGNAME='myOrganization'

Now, you can verify that you have API access to the old github by running:

    ./list-repos.sh

### Filling in Auth Data for Github (the new one):

There are 3 values used for the 'create-new-repos.sh' script: COOKIE_TEXT, AUTH_TOKEN, and TEAM_ID.  We get these values by snooping the network traffic from the Chrome browser.  Subsequently, the programmatic requests will look like a continuation of your browser session (don't log out in your browser, or that session will end, and the scripts will stop working)


0. Open '${NEW_GITHUB_HTTP}/organizations/${NEW_ORGNAME}/repositories/new' in Chrome.  Open the Developer Console
1. Create a repo manually, and look at the 'Network' tab in Chrome's developer console
2. Copy (Dev Console -> Network -> select the POST request to 'repositories' -> Headers tab -> Request Headers section -> Cookie)
3. Copy (Dev Console -> Network -> select the POST request to 'repositories' -> Headers tab -> Form Data section -> authenticity_token)
4. Copy (Dev Console -> Network -> select the POST request to 'repositories' -> Headers tab -> Form Data section -> team_id)

e.g.

    COOKIE_TEXT='tracker=direct; _fi_sess=NCh7CjoMY29udG84thefNdzoJdXFlcmkZOg9zZXFzaW9uX2lkIiU3MGYzZjllYzllMDY1FGM0FDdiZGIxMGY4FNEyFDFhZNoQX2FzcmZfdG9rZW4iMWxpRnFjRNdFMEsyVzhDWXNORWdGWEdaNWh1Q1lMbUMwRWp6VUI3Mmw5M1k9OhNmaW5nZXJwcmludCIlMDhhFjMxFjY2ZjEyYzkxFjIyMzgyOGJlMWI0Nosovig%3D--0ac65914205ac86e4b4b285683d23f91ca307d3; _gh_manage=NCh8CC%3D%3D%0C--f816de4f77aa285ba407eaba94bd1ca'
    AUTH_TOKEN=liFqcE7E0K2W8UbRySvot3cMhuCYLto9emYUB72l93Y=
    TEAM_ID=80

 
# Phase I: Performing the Migration 'First Pass'

This step is about getting the data from old github into new github.  During this phase, there are zero changes to how your team operates.  Continue pushing to the old location.

1) Clone all the repos locally:
    
    ./clone-all.sh
 
2) Create the new repositories (see 'config.sh' for the special session values):

    ./create-new-repos.sh

# Phase II: Synchronizing OLD --> NEW

Once you have the new location set up, you can flow all changes from the old location to the new location:

    ./pump-changes.sh

That script will run in a loop and all changes pushed to the old location will be available from the new location within one cycle time (might be 30m or more if you have a lot of data).

# Phase III: Team Migration

The team migration is the only step of this process that needs to be 'atomic'.  Your team must never push changes to both locations concurrently.  Once the new location is up and running, at a single coordinated instant, the entire team needs to switch their commit-and-push behavior from the old location to the new location.  For a small team, this is pretty easy ( "hey team, starting today, all changes go to the new location" ).

The other key component of your migration plan will be updating automated build and deploy tools.  Make sure you have a plan to address everything on this checklist that is applicable to your project:

 * Scripts and config files checked into your projects
 * Hudson/Jenkins build jobs
 * External Deployment Tools (eg Rightscale scripts) that pull from github
 * Deployed Code - Servers that have scripts deployed on them which talk to github (we had a NPM repository which used github)

### Migrating read-only tools early

Keep in mind that because the new github has a semi-fresh (within ~30m) copy of the data, you can migrate your read-only consumers, like Hudson and other build tools, to use the new location in advance of the full switch-over.

### Doing bulk string replace inside all of your code

You may choose to do a bulk textual string-replace operation on your project code.  Keep in mind that you may need to edit multiple branches of a project.  You should also skim through all textual references to github PRIOR to running an automated job.

There is a tool that you can use to recursively scan all branches of all projects that have been migrated.  It does a brute force string-replace, so use it at your own risk:

    ./bulk-replace.sh

