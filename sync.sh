if (( $# < 2 )); then
    echo "Usage: sync.sh source_repo target_repo [branches]"
    exit 1
fi
SOURCE_REPO=$1
TARGET_REPO=$2

BRANCHES="${@:3}"
if [ -z "${BRANCHES}" ]; then
    BRANCHES="master"
fi

export TEMP_DIR="temp_dir"
if [ -d "$TEMP_DIR" ]; then
  echo "$TEMP_DIR already exists, please delete before proceeding"
  exit 1
fi

git clone $TARGET_REPO temp_dir
cd temp_dir
git fetch origin --tags
git remote add upstream $SOURCE_REPO
git fetch upstream --tags

for BRANCH in $BRANCHES; do
  echo "Updating branch $BRANCH"
  git checkout -b $BRANCH
  git pull upstream $BRANCH --no-edit
  git push origin $BRANCH
  echo "Branch $BRANCH updated successfully"
done