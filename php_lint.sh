#!/bin/sh
# WORKSPACE/php_lint.sh

exit_code=0

echo "##### php-lint start #####"

# Chanage to project directory
if [ -z "$WORKSPACE" ]
  then
    echo "WORKSPACE not exist"
  else
    echo "WORKSPACE =" $WORKSPACE
    cd $WORKSPACE
fi


# Get commit_id
commit_id=HEAD

if [ -z "$1" ]
  then
    echo "No argument supplied, use default argument:" $commit_id
  else
    echo "argument:" $1
    commit_id=$1
fi

# Get PHP file list
if [ "all" == $commit_id ]
  then
    # check_list=$(find . -type f -not -path './vendor/*' -name '*.php')
    check_list=$(git ls-files -- '*.php')
  else
    check_list=$(git diff-tree --no-commit-id --name-only -r $commit_id -- '*.php')
fi

# Do PHP lint
for i in $check_list
do
  php -l $i
  ex=$?
  if [[ 0 != $ex ]]; then
    exit_code=$ex
  fi
done

echo "##### php-lint finished #####"
echo "exit_code =" $exit_code
# if exit_code not 0, then exit with error
exit $exit_code
