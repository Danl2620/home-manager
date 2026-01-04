


git-meld3() {
    local base=$(git merge-base ${1:-master} ${2:-HEAD})
    local target=${1:-master}
    local current=${2:-HEAD}
    local temp=$(mktemp -d)

    mkdir -p $temp/target $temp/current $temp/base

    git archive $base | tar -x -C $temp/base
    git archive $target | tar -x -C $temp/target
    git archive $current | tar -x -C $temp/current

    meld $temp/target $temp/base $temp/current
    rm -rf $temp
}

