#!/bin/bash

source "./scripts/deploy/functions.sh"

CURRENT_BRANCH=$1
SOURCE_BRANCH=$2
STEPS=$3

FILES_TO_CHANGE="$(getFilesByFilter "${CURRENT_BRANCH}" "${SOURCE_BRANCH}" "ACMRT" "force-app/")"
FILES_TO_CHANGE_SIZE=$(echo -n "$FILES_TO_CHANGE" | wc -c)

printf "${FILES_TO_CHANGE}\n\n"

COMMAND="sfdx force:source:deploy -p \"${FILES_TO_CHANGE::-1}\" -u ${USER_EMAIL}"

printf "\n$COMMAND\n\n"

if [[ -z ${STEPS} ]]; then
	COMMAND=$COMMAND" -l RunLocalTests -c"
elif [[ ${STEPS} == "DEPLOY_WITH_TEST" ]]; then
	COMMAND=$COMMAND" -l RunLocalTests"
elif [[ ${STEPS} == "DEPLOY" ]]; then
	COMMAND=$COMMAND" "
elif [[ ${STEPS} == "VALIDATE" ]]; then
	COMMAND=$COMMAND" -c"
else
	COMMAND=$COMMAND" -l RunLocalTests -c"
fi

if [[ ${FILES_TO_CHANGE_SIZE} -gt 0 ]]; then
	eval "${COMMAND}"
else
	echo "No files to deploy"
fi
