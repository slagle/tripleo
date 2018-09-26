#!/bin/bash

set -ux

function apply {
        $@
        rc=$?
        if [ ! $rc -eq 0 ]; then
                echo FAILED
                git status
                conflicts=$(git status | grep "both modified:" | awk '{print $3}' | tr '\n' ' ')
                echo "vim $conflicts"
                bash
                git add $conflicts
			    git cherry-pick --continue
        fi
}

REPO_URL=${REPO_URL:-"https://git.openstack.org/openstack/${REPO}"}
REMOTE=${REMOTE:-"upstream"}

echo $REPO
echo $REPO_URL
echo $REMOTE
echo $PATCHES

for patch in $PATCHES; do
    echo "#######################################################"
    echo "Cherry picking https://review.openstack.org/${patch}"
    changeset=$(git ls-remote $REMOTE | grep $patch | awk '{print $2}' | cut -d/ -f5 | sort -n | tail -n 1)
    ref=$(git ls-remote $REMOTE | grep $patch | tail -n 1 | awk '{print $2}' | cut -d/ -f1,2,3,4 | tail -n 1)/${changeset}
	git fetch $REPO_URL $ref && apply git cherry-pick -x FETCH_HEAD
    echo "#######################################################"
done

echo "DONE!"
