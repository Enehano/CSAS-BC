#!/bin/bash

source "./scripts/deploy/functions.sh"

CURRENT_BRANCH=$1
SOURCE_BRANCH=$2
STEPS=$3

FILES_TO_CHANGE="$(getFilesByFilter ${CURRENT_BRANCH} ${SOURCE_BRANCH} ACMRT force-app)"
FILES_TO_CHANGE_SIZE=$(echo -n "$FILES_TO_CHANGE" | wc -c)

FILES_TO_DELETE="$(getFilesByFilter ${CURRENT_BRANCH} ${SOURCE_BRANCH} D force-app)"
FILES_TO_DELETE_SIZE=$(echo -n "$FILES_TO_DELETE" | wc -c)

if [[ ${FILES_TO_DELETE_SIZE} -gt 0 ]]; then
    COMMAND2="sfdx force:source:delete -p \"${FILES_TO_DELETE::-1}\" -u ${USER_EMAIL} -r"
fi
if [[ ${FILES_TO_CHANGE_SIZE} -gt 0 ]]; then
    COMMAND="sfdx force:source:deploy -p \"${FILES_TO_CHANGE::-1}\" -u ${USER_EMAIL}"
fi

if [[ -z ${STEPS} ]]; then
	COMMAND=$COMMAND" -l RunLocalTests -c"
	COMMAND2=$COMMAND2" -l RunLocalTests -c"
elif [[ ${STEPS} == "DEPLOY_WITH_TEST" ]]; then
	COMMAND=$COMMAND" -l RunLocalTests"
	COMMAND2=$COMMAND2" -l RunLocalTests"
elif [[ ${STEPS} == "DEPLOY" ]]; then
	COMMAND=$COMMAND" "
	COMMAND2=$COMMAND2" "
elif [[ ${STEPS} == "VALIDATE" ]]; then
	COMMAND=$COMMAND" -c"
	COMMAND2=$COMMAND2" -c"
else
	COMMAND=$COMMAND" -l RunLocalTests -c"
	COMMAND2=$COMMAND2" -l RunLocalTests -c"
fi

if [[ ${FILES_TO_DELETE_SIZE} -gt 0 ]]; then
    printf "\n$COMMAND2\n\n"
	eval "${COMMAND2}"
else
	echo "No files to delete"
fi

if [[ ${FILES_TO_CHANGE_SIZE} -gt 0 ]]; then
    printf "\n$COMMAND\n\n"
	eval "${COMMAND}"
else
	echo "No files to deploy"
fi
