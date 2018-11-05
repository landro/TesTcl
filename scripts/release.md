
Script for replacing verision number in all files

Mac OS X/Free BSD

    find -E .. -regex '^.*\.(tcl|md)$' -exec sed -i '' 's/OLD_VERSION_NUMBER/NEW_VERSION_NUMBER/g' {} \;

Tagging a new release and pushing to origin

    git tag -a v1.0.12 -m 'Release 1.0.12' 
    git push --tags