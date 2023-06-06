#!/bin/bash

getFilesByFilter() {
	SOURCE_BRANCH=${1}
	CURRENT_BRANCH=${2}
	FILTER=${3}
	FOLDER=${4}

	IFS=$'\n'
	ORIGINAL_FILES=$(git diff -w --ignore-blank-lines --name-only --diff-filter=${FILTER} "${CURRENT_BRANCH}" "${SOURCE_BRANCH}" ${FOLDER} | sed 's/.cls-meta.xml/.cls/g' | sed 's/.trigger-meta.xml/.trigger/g' | sed s/\"//g | uniq)

	for FILE in $ORIGINAL_FILES; do
		echo "${FILE//\$/\\\$},"
	done
}