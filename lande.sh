#!/bin/bash

cat <<'EOF'
 __                            _______            
/  |                          /       \           
$$ |        ______   _______  $$$$$$$  |  ______  
$$ |       /      \ /       \ $$ |  $$ | /      \ 
$$ |       $$$$$$  |$$$$$$$  |$$ |  $$ |/$$$$$$  |
$$ |       /    $$ |$$ |  $$ |$$ |  $$ |$$    $$ |
$$ |_____ /$$$$$$$ |$$ |  $$ |$$ |__$$ |$$$$$$$$/ 
$$       |$$    $$ |$$ |  $$ |$$    $$/ $$       |
$$$$$$$$/  $$$$$$$/ $$/   $$/ $$$$$$$/   $$$$$$$/ 
                                                  
                                                  
                                                                                                            
EOF

# Function to check and print the version and path of a language
check_version() {
    local lang_name=$1
    local command=$2
    local version_command=$3

    if command -v $command &> /dev/null; then
        local path=$(command -v $command)
        # Use timeout to prevent hanging
        local version=$(timeout 2s $version_command 2>&1)
        printf "%-15s\t%s\n" "$lang_name" "$path"
    fi
}

# Associative array of languages and their commands
declare -A languages=(
    ["Python 2"]="python python --version"
    ["Python 3"]="python3 python3 --version"
    ["Ruby"]="ruby ruby --version"
    ["Node.js"]="node node --version"
    ["Java"]="java java -version"
    ["Go"]="go go version"
    ["PHP"]="php php --version"
    ["Perl"]="perl perl -v"
    ["Rust"]="rustc rustc --version"
    ["Scala"]="scala scala -version"
    ["Haskell"]="ghc ghc --version"
    ["Clojure"]="clj clj -Sdescribe"
)

# Print the initial message
echo ""
echo "Checking installed languages and their paths..."

# Print table header
printf "%-15s\t%s\n" "Language" "Path"
printf "%-15s\t%s\n" "--------" "----"

# Main execution
if [ "$#" -eq 0 ]; then
    for lang in "${!languages[@]}"; do
        if [[ "$lang" == "Java" ]]; then
            check_version "$lang" "java" "java -version"
        else
            check_version "$lang" ${languages[$lang]}
        fi
    done
else
    for lang in "$@"; do
        if [[ -n "${languages[$lang]}" ]]; then
            if [[ "$lang" == "Java" ]]; then
                check_version "$lang" "java" "java -version"
            else
                check_version "$lang" ${languages[$lang]}
            fi
        else
            echo "Unknown language: $lang"
        fi
    done
fi

echo "Done."
