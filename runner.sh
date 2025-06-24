#!/bin/bash
err=0

#################LAB SPECIFIC CODE HERE#############
required_files_non_compile=("README.md" "story.txt")
# Check if all files are found
for file in "${required_files_non_compile[@]}"; do
  if [ -f "$file" ]; then
    echo "✅$file found."
  else
    echo "❌$file does not exist."
    err=1
  fi
done


# Array of required compileable files
required_files=("HelloWorld.java")

# Check if all files are found and compile
for file in "${required_files[@]}"; do
  if [ -f "$file" ]; then
    echo "✅$file found"
    if javac $file; then
      echo "✅$file compiled"
    else
      echo "❌Failed to compile $file"
      err=1
    fi
  else
    echo "❌$file does not exist."
    err=1
  fi
done

#Run this class and print output
CLASSNAME=HelloWorld
if [ -f $CLASSNAME.class ]; then
  echo "Attempting to run $CLASSNAME.java:"
  output=$(timeout 1 java $CLASSNAME)
  status=$?
  if [ $status -ne 0 ]; then
    echo "❌Command 'java $CLASSNAME' failed"
    err=1
  else
    echo "✅It ran with output: '$output'"
    echo "Expected:             'Hello World!" 
  fi  
else
   echo "❌Cannot run $CLASSNAME.java, no class file found."
   err=1
fi



commit_count=$(git rev-list --count main)
# Check if commit count is less than 5
if [[ ! "$commit_count" =~ ^[0-9]+$ ]]; then
  echo "❌ Could not determine commit count. Are you in a git repo with a 'main' branch?"
  err=1
elif [ "$commit_count" -lt 4 ]; then
  echo "❌ Less than 4 commits in class. 3 for the madlibs, and 1 for your helloworld."
  err=1
else
  echo "✅ Commit count is sufficient ONLY if you have 3 for the madlibs, and 1 for your helloworld."
  echo "❌ You are also required to commit from home! This script will not validate if you do it"
fi

#cause the build to fail if any of the err=1 statements trigger.
exit $err
