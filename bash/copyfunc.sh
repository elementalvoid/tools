# See: http://stackoverflow.com/questions/1203583/how-do-i-rename-a-bash-function
copy_function() {
    declare -F $1 > /dev/null || return 1
    eval "$(echo "${2}()"; declare -f ${1} | tail -n +2)"
}

# Example usage:
# copy-func copy-keys copy-keys-orig
# function copy-keys {
#   copy-keys-orig &&
#   echo "ran original copy-keys. running my own stuff now"
#   for num in $(seq 1 5); do
#     echo "$num.."
#   done
# }
# copy-keys
