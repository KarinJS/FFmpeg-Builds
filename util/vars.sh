#!/bin/bash

if [[ $# -lt 2 ]]; then
    echo "Invalid Arguments"
    exit -1
fi

TARGET="$1"
VARIANT="$2"
shift 2

if ! [[ -f "variants/${TARGET}-${VARIANT}.sh" ]]; then
    echo "Invalid target/variant"
    exit -1
fi

LICENSE_FILE="COPYING.LGPLv2.1"
FFMPEG_VERSION="${1:-8.1}"

ADDINS=()
ADDINS_STR=""
while [[ "$#" -gt 0 ]]; do
    ADDIN="$1"

    # 三段式版本号(如 8.0.3)拆解为:系列 addin(8.0,决定镜像与依赖开关)
    # + 精确源码 tag(n8.0.3,经 GIT_BRANCH_OVERRIDE 注入;X.Y.0 对应上游 nX.Y)
    if ! [[ -f "addins/${ADDIN}.sh" ]] && [[ "$ADDIN" =~ ^([0-9]+\.[0-9]+)\.([0-9]+)$ ]]; then
        SERIES="${BASH_REMATCH[1]}"
        PATCH="${BASH_REMATCH[2]}"
        if [[ -f "addins/${SERIES}.sh" ]]; then
            if [[ -z "$GIT_BRANCH_OVERRIDE" ]]; then
                if [[ "$PATCH" == "0" ]]; then
                    GIT_BRANCH_OVERRIDE="n${SERIES}"
                else
                    GIT_BRANCH_OVERRIDE="n${ADDIN}"
                fi
            fi
            ADDIN="$SERIES"
        fi
    fi

    if ! [[ -f "addins/${ADDIN}.sh" ]]; then
        echo "Invalid addin: $ADDIN"
        exit -1
    fi

    ADDINS+=( "$ADDIN" )
    ADDINS_STR="${ADDINS_STR}${ADDINS_STR:+-}$ADDIN"

    shift
done

REPO="btbn/ffmpeg-builds"
REGISTRY="ghcr.io"
BASE_IMAGE="${REGISTRY}/${REPO}/base:latest"
TARGET_IMAGE="${REGISTRY}/${REPO}/base-${TARGET}:latest"
IMAGE="${REGISTRY}/${REPO}/${TARGET}-${VARIANT}${ADDINS_STR:+-}${ADDINS_STR}:latest"

ffbuild_ffver() {
    case "$ADDINS_STR" in
    *4.4*)
        echo 404
        ;;
    *5.0*)
        echo 500
        ;;
    *5.1*)
        echo 501
        ;;
    *6.0*)
        echo 600
        ;;
    *6.1*)
        echo 601
        ;;
    *7.0*)
        echo 700
        ;;
    *7.1*)
        echo 701
        ;;
    *8.0*)
        echo 800
        ;;
    *)
        echo 99999999
        ;;
    esac
}


ffbuild_depends() {
    echo base
}

ffbuild_dockerstage() {
    if [[ -n "$SELFCACHE" ]]; then
        to_df "RUN --mount=src=${SELF},dst=/stage.sh --mount=src=${SELFCACHE},dst=/cache.tar.xz run_stage /stage.sh"
    else
        to_df "RUN --mount=src=${SELF},dst=/stage.sh run_stage /stage.sh"
    fi
}

ffbuild_dockerlayer() {
    to_df "COPY --link --from=${SELFLAYER} \$FFBUILD_DESTPREFIX/. \$FFBUILD_PREFIX"
}

ffbuild_dockerfinal() {
    to_df "COPY --link --from=${PREVLAYER} \$FFBUILD_PREFIX/. \$FFBUILD_PREFIX"
}

ffbuild_configure() {
    return 0
}

ffbuild_unconfigure() {
    return 0
}

ffbuild_cflags() {
    return 0
}

ffbuild_uncflags() {
    return 0
}

ffbuild_cxxflags() {
    return 0
}

ffbuild_uncxxflags() {
    return 0
}

ffbuild_ldexeflags() {
    return 0
}

ffbuild_unldexeflags() {
    return 0
}

ffbuild_ldflags() {
    return 0
}

ffbuild_unldflags() {
    return 0
}

ffbuild_libs() {
    return 0
}

ffbuild_unlibs() {
    return 0
}