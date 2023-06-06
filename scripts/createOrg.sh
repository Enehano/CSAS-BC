#!/bin/bash

set -e

POSITIONAL=()

while [[ $# -gt 0 ]]; do
	key="$1"

	case ${key} in
	-h | --devhub)
		DEVHUB="$2"
		shift
		shift
		;;
	-n | --name)
		NAME="$2"
		shift
		shift
		;;
	-d | --days)
		DAYS="$2"
		shift
		shift
		;;
	*)
		POSITIONAL+=("$1")
		shift
		;;
	esac
done

printf "\n*** 1/5 CHECKING INPUT ***\n"

if [[ -z $DEVHUB ]]; then
	DEVHUB=$(sfdx config:get defaultdevhubusername | tail -n1 | awk '{print $2}')
	if [[ $DEVHUB = "true" ]]; then
		read -p "Specify Dev Hub to use for creating Scratch Org: " DEVHUB
	else
		read -p "Is this the Dev Hub you want to use for creating Scratch Org? Leave empty for YES or specify Dev Hub - $DEVHUB: " DEVHUB2
	fi
	[[ -n $DEVHUB2 ]] && DEVHUB=$DEVHUB2
	if [[ -z $DEVHUB ]]; then
		printf "Dev Hub must be set. \n"
		exit 1
	fi
	sfdx config:set "defaultdevhubusername=$DEVHUB"
fi

if [[ -z $NAME ]]; then
	read -p "Specify name for your new Scratch Org: " NAME
	if [[ -z $NAME ]]; then
		printf "Name must be set. \n"
		exit 1
	fi
fi

if [[ -z $DAYS ]]; then
	read -p "Specify the lifespan of your new Scratch Org in days (1 - 30), leave empty for 10: " DAYS
	if [[ -z $DAYS ]]; then
		DAYS=10
	fi
fi

printf "\n*** 2/5 CREATING SCRATCH ORG ***\n"
sfdx force:org:create -s -a $NAME -d $DAYS -f config/project-scratch-def.json -w 30
