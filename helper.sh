#!/usr/bin/env bash

RCFILENAME='httpierc'

# Function to print the usage
function usage {
	echo "[*] Usage: $(basename $0) VERB ENDPOINT"
	echo "$(basename $0) supports the following arguments:"

	echo -e "\t-h --help"
	echo -e "\t\tDisplay this usage message and exit"

	echo -e "\t--endpoints"
	echo -e "\t\tPrint the endpoints read from the $RCFILENAME file"
}

# Function to print the endpoints array
function print_endpoints {
	echo "[+] Endpoints read from $RCFILENAME:"
	for key in "${!endpoints[@]}"; do
			echo -e "\tName:   ${key}"
			echo -e "\tURL: ${endpoints[$key]}"
	done
}

echo '[*] Starting Httpie Helper!'

# Check if the rc file exists
if [ ! -f "$RCFILENAME" ]; then
	echo "[-] $RCFILENAME file not found in current directory!"
	echo "[*] Quitting"
	exit
fi

# Associative array to hold endpoints
declare -A endpoints

# Read lines from rc file
# Add the endpoints to the array
while read line
do
	IFS="=" read -a fields <<< $line
	endpoints[${fields[0]}]=${fields[1]}
done < $RCFILENAME

# If no arguments are given
if [ -z "$1" ]; then
	echo "[x] No arguments provided. Please see usage information."
	usage
	exit
fi

# Parsing command line arguments
# -- at the end stands for the rest of the arguments passed
PARSED_ARGS=$(getopt -n httpiewrapper -o h --long help,endpoints -- "$@")
VALID_ARGS=$?
if [ "$VALID_ARGS" != "0" ]; then
	echo "[x] Invalid arguments. Please see usage information."
	usage
	exit
fi

# Iterate over the values
eval set -- "$PARSED_ARGS"
while :
do
	case "$1" in
		--endpoints)
			print_endpoints
			shift
			;;
		-h | --help)
			usage
			exit
			shift
			;;
		--)
			# Rest of the args
			shift
			break
	esac
done

# If the rest of the args are blank
if [ -z "$1" ] || [ -z "$2" ]; then
	echo "[-] Endpoint or HTTP method not specified. Please see usage information."
	usage
	exit
fi

URL=${endpoints["$2"]}
ARGS_COPY=("$@")
eval "http $1 $URL ${ARGS_COPY[@]:2}"

echo "[*] Quitting"

