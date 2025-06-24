#!/bin/bash
err=0
trap 'rm -f *.class' EXIT
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

#################FILES THAT DO NOT COMPILE - CHECK IF EXIST #############
# Array of required compileable files
required_files_non_compile=("README.md" "story.txt")
# Check if all files are found
for file in "${required_files_non_compile[@]}"; do
  if [ -f "$file" ]; then
    echo -e "${GREEN}✅$file found."
  else
    echo -e "${RED}❌$file does not exist."
    err=1
  fi
done


#################FILES THAT NEED COMPILE - TRY TO COMPILE #############
# Array of required compileable files
required_files=("HelloWorld.java")

# Check if all files are found and compile
for file in "${required_files[@]}"; do
  if [ -f "$file" ]; then
    echo -e "${GREEN}✅$file found"
    if javac "$file"; then
      echo -e "${GREEN}✅$file compiled"
    else
      echo -e "${RED}❌Failed to compile $file"
      err=1
    fi
  else
    echo -e "${RED}❌$file does not exist."
    err=1
  fi
done




################# RUN A CLASS AND PRINT OUTPUT - DO NOT VALIDATE #############
CLASSNAME=HelloWorld
EXPECTED_OUTPUT="Hello World!"
if [ -f "$CLASSNAME.class" ]; then
  echo -e "${RESET}Attempting to run $CLASSNAME.java:"
  output=$(timeout 1 java "$CLASSNAME")
  status=$?
  if [ $status -ne 0 ]; then
    echo -e "${RED}❌Command 'java $CLASSNAME' failed"
    err=1
  else
    echo -e "${GREEN}✅It ran with output: '$output'"
    echo -e "${RESET}Expected:             '$EXPECTED_OUTPUT'" 
  fi  
else
   echo -e "${RED}❌Cannot run $CLASSNAME.java, no class file found."
   err=1
fi



################# Count Commits #############
commit_count=$(git rev-list --count main)
REQUIRED_COUNT=4
# Check if commit count is less than 5
if [[ ! "$commit_count" =~ ^[0-9]+$ ]]; then
  echo -e "${RED}❌ Could not determine commit count. Are you in a git repo with a 'main' branch?"
  err=1
elif [  "$commit_count" -lt "$REQUIRED_COUNT" ]; then
  echo -e "${RED}❌ Less than $REQUIRED_COUNT commits."
  echo -e "${RESET}Less than 4 commits in class. 3 for the madlibs, and 1 for your helloworld."
  err=1
else
  echo -e "${GREEN}✅ Commit count is sufficient ONLY if you have 3 for the madlibs, and 1 for your helloworld."
  echo -e "${RED}❌ You are also required to commit from home! This script will not validate if you do it"
fi


#cause the build to fail if any of the err=1 statements trigger.
exit $err
