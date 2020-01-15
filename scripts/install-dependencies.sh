#!/bin/bash

MODULE_COMPILE=""

function GET_BUILD_MODULE(){
    echo "git log -p --name-only --oneline | cat "
    git log -p --name-only --oneline | cat
    echo "TESTING_VALUE ${TESTING_VALUE}"
    if [ -z "${BUILD_BRANCH}" ]
    then
        GIT_CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    else
        GIT_CURRENT_BRANCH="${BUILD_BRANCH}"
        echo "git checkout ${GIT_CURRENT_BRANCH}"
        git checkout "${GIT_CURRENT_BRANCH}"
    fi
    GIT_LAST_COMMIT=$(git log -p --name-only --oneline | head -1 | awk '{print $1}')
    GIT_LAST_MERGE=$(git log -p --name-only --oneline | grep "Merge pull request" | head -1 | awk '{print $1}')
    echo "GIT_CURRENT_BRANCH: ${GIT_CURRENT_BRANCH}"
    echo "GIT_LAST_COMMIT: ${GIT_LAST_COMMIT}"
    echo "GIT_LAST_MERGE: ${GIT_LAST_MERGE}"
    MODULE_COMPILE=$(git log -p --name-only --oneline ${GIT_LAST_MERGE}..${GIT_LAST_COMMIT} | grep "/" | grep  -v " " | grep -v ".md" | awk '{split($0, val, "/"); print val[1]}' | sort | uniq -c | awk '{print $2}')
}

function INSTALL_DEPENDENCIES(){
    COUNT_MODULES=$(echo "${MODULE_COMPILE}" | wc -l)
    let INCREMENT=1
    while [ ${INCREMENT} -le ${COUNT_MODULES} ];
    do
        MODULE=$(echo "${MODULE_COMPILE}" | head -${INCREMENT} | tail -1)
        if [ "${MODULE}" != "scripts" ]; then
            echo "make -C ${MODULE} install"
            make -C "${MODULE}" install
        fi
        let INCREMENT=${INCREMENT}+1
    done
}

GET_BUILD_MODULE
INSTALL_DEPENDENCIES

