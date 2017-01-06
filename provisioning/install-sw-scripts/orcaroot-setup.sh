# This software is licensed under the MIT "Expat" License.
#
# Copyright (c) 2016: Oliver Schulz.


DEFAULT_BUILD_OPTS="-DCMAKE_CXX_STANDARD=11"


pkg_installed_check() {
    test -f "${INSTALL_PREFIX}/buildTools/config.mk"
}


pkg_install() {
    if [ "${PACKAGE_VERSION}" != "trunk" ] ; then
        echo "ERROR: Only version \"trunk\" supported for ORCARoot" >&2
        return 1
    fi

    SVN_URL="svn://orca.physics.unc.edu/OrcaRoot"
    echo "INFO: Subversion URL: \"${SVN_URL}\"." >&2

    svn co "${SVN_URL}" "${INSTALL_PREFIX}"
    cd "${INSTALL_PREFIX}"
    ./configure
    time make -j`nprocs`
}


pkg_env_vars() {
cat <<-EOF
ORDIR="${INSTALL_PREFIX}"
EOF
}
