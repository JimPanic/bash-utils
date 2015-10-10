# Exit with an error when a command returns with something other than 0
#
# Use with:
#   $(fail_on_nontrue_return_value)
function fail_on_nontrue_return_value () {
  echo 'set -o errexit'
  return 0
}

# Exit with an error when using not set variables
#
# Use with:
#   $(fail_on_unbound_variables)
function fail_on_unbound_variables () {
  echo 'set -o nounset'
  return 0
}

# Show every line of bash being executed explicitely
#
# Use with:
#   $(be_explicit)
function be_explicit () {
  echo 'set -x'
  return 0
}

# Get the canonical path of a directory
#
# To get the canonical path for a file:
#
#   $(canonical_path $(dirname "file"))/$(basename "file")
function canonical_path () {
  pushd "$1" &> /dev/null
  canonical=`pwd -P`
  popd &> /dev/null

  echo "${canonical}"
  return 0
}

# Check whether first and second argument are equal integers
# Returns 0 when equal
# Returns not 0 otherwise
#
# Example:
#   equal $# 1 && {
#     echo 'One argument given'
#     exit 0
#   }
#
function equal () {
  test "$#" -eq "2" && test "$1" -eq "$2"
  return $?
}

# Check whether first and second argument are NOT equal integers
# Returns 0 when inequal
# Returns not 0 otherwise
#
# Example:
#   equal $# 1 && {
#     echo 'One argument given'
#     exit 0
#   }
#
function not_equal () {
  test "$#" -eq "2" && test "$1" -ne "$2"
  return $?
}

# Check whether the first and second argument are equal strings
# Returns 0 when strings match
# Returns not 0 otherwise
#
# Example:
#   match "foo" $foo && {
#     echo '$foo is "foo"'
#   }
#
function match () {
  equal $# 2 && test "$1" = "$2"
  return $?
}

# Check whether the first and second argument are NOT equal strings
# Returns 0 when strings don't match
# Returns not 0 otherwise
#
# Example:
#   match_not "foo" $foo && {
#     echo '$foo is not "foo"'
#   }
#
function match_not () {
  equal $# 2 && test "$1" != "$2"
  return $?
}

# Check if a given file path exists (as a file or directory)
# Returns 0 if the path exists
# Returns 1 otherwise
#
# Example:
#   exists "/var/log/mylog" && {
#     echo "I'm logging!" >> /var/log/mylog
#   }
#
function exists () {
  test "$#" -eq "1" && ls "$1" &> /dev/null
  return $?
}

# Check if a given file path does NOT exist (as a file or directory)
# Returns 0 if the path is absent
# Returns not 0 otherwise
#
# Example:
#   exists_not "/var/log/mylog" && {
#     echo 'ERROR: Cannot open logfile.'
#     exit 1
#   }
#
function exists_not () {
  test "$#" -eq "1" && ls "$1" &> /dev/null
  not_equal $? 0
  return $?
}

# Check whether the given argument is string '-h' or '--help'
# Used for small scripts to quickly check if the user wants to display
# the usage.
#
# Example:
#   want_help $1 && {
#     echo "$usage"
#     exit 0
#   }
#
function want_help () {
  match "$1" "-h" || match "$1" "--help"
  return $?
}

# URI encode slashes (%2F) and spaces (%20)
function uri_encode () {
  echo $1 | sed -e "s|/|%2F|g" -e "s| |%20|g"
}

# Check whether given string is empty
function empty () {
  test "$1" = ""
  return $?
}

# Check whether given string is NOT empty
function not_empty () {
  test "$1" != ""
  return $?
}
