set -e;

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
echo ${CURRENT_DIR}


${CURRENT_DIR}/copy_downloads_to_node_modules.sh