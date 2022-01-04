# thanks Dietrich
# https://stackoverflow.com/a/2179876/13430616

IFS="
"
for FILE in $(git ls-files)
do
    TIME=$(git log --pretty=format:%cd -n 1 --date=iso --date-order -- "$FILE")

    TIME=$(date --date="$TIME" +%Y%m%d%H%M.%S)

    touch -m -t "$TIME" "$FILE"
done

ls -lR .
