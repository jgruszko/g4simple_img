FROM centos:7


# User and workdir settings:

USER root
WORKDIR /root


# Install yum/RPM packages:

RUN true \
    && sed -i '/tsflags=nodocs/d' /etc/yum.conf \
    && yum install -y \
        epel-release \
    && yum groupinstall -y "Development Tools" \
    && yum install -y \
        deltarpm \
        \
        wget \
        cmake \
        p7zip \
        nano vim \
        git git-gui gitk svn \
    && dbus-uuidgen > /etc/machine-id


# Copy provisioning script(s):

COPY provisioning/install-sw.sh /root/provisioning/


# Install CMake:

COPY provisioning/install-sw-scripts/cmake-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/cmake/bin:$PATH" \
    MANPATH="/opt/cmake/share/man:$MANPATH"

RUN provisioning/install-sw.sh cmake 3.5.1 /opt/cmake


# Install CLHep and Geant4:

COPY provisioning/install-sw-scripts/clhep-* provisioning/install-sw-scripts/geant4-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/geant4/bin:/opt/clhep/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/geant4/lib64:/opt/clhep/lib:$LD_LIBRARY_PATH" \
    G4ABLADATA="/opt/geant4/share/Geant4-10.4.0/data/G4ABLA3.1" \
    G4ENSDFSTATEDATA="/opt/geant4/share/Geant4-10.4.0/data/G4ENSDFSTATE2.2" \
    G4LEDATA="/opt/geant4/share/Geant4-10.4.0/data/G4EMLOW7.3" \
    G4LEVELGAMMADATA="/opt/geant4/share/Geant4-10.4.0/data/PhotonEvaporation5.2" \
    G4NEUTRONHPDATA="/opt/geant4/share/Geant4-10.4.0/data/G4NDL4.5" \
    G4NEUTRONXSDATA="/opt/geant4/share/Geant4-10.4.0/data/G4NEUTRONXS1.4" \
    G4PIIDATA="/opt/geant4/share/Geant4-10.4.0/data/G4PII1.3" \
    G4RADIOACTIVEDATA="/opt/geant4/share/Geant4-10.4.0/data/RadioactiveDecay5.2" \
    G4REALSURFACEDATA="/opt/geant4/share/Geant4-10.4.0/data/RealSurface2.1" \
    G4SAIDXSDATA="/opt/geant4/share/Geant4-10.4.0/data/G4SAIDDATA1.1" \
    AllowForHeavyElements=1

RUN true \
    && yum install -y \
        expat-devel xerces-c-devel zlib-devel \
        libXmu-devel libXi-devel \
        mesa-libGLU-devel motif-devel mesa-libGLw qt-devel \
    && provisioning/install-sw.sh clhep 2.4.0.0 /opt/clhep \
    && provisioning/install-sw.sh geant4 10.4.0 /opt/geant4


# Install CERN ROOT:

COPY provisioning/install-sw-scripts/root-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/root/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/root/lib:$LD_LIBRARY_PATH" \
    MANPATH="/opt/root/man:$MANPATH" \
    PYTHONPATH="/opt/root/lib:$PYTHONPATH" \
    CMAKE_PREFIX_PATH="/opt/root;$CMAKE_PREFIX_PATH" \
    JUPYTER_PATH="/opt/root/etc/notebook:$JUPYTER_PATH" \
    \
    ROOTSYS="/opt/root"

RUN true \
    && yum install -y \
        libSM-devel \
        libX11-devel libXext-devel libXft-devel libXpm-devel \
        libjpeg-devel libpng-devel \
        mesa-libGLU-devel \
    && provisioning/install-sw.sh root 6.12.04 /opt/root


# Install ORCARoot:

COPY provisioning/install-sw-scripts/orcaroot-* provisioning/install-sw-scripts/

ENV \
    LD_LIBRARY_PATH="/opt/orcaroot/lib:$LD_LIBRARY_PATH" \
    ORDIR="/opt/orcaroot"

RUN true \
    && provisioning/install-sw.sh orcaroot trunk /opt/orcaroot


# Install requirements for MAJORANA Software:

RUN true \
    && yum install -y \
        readline-devel fftw-devel \
        libcurl-devel


# Install additional packages and clean up:

RUN yum install -y \
        numactl \
        \
        xorg-x11-server-utils mesa-dri-drivers glx-utils \
        xdg-utils \
        \
        http://linuxsoft.cern.ch/cern/centos/7/cern/x86_64/Packages/parallel-20150522-1.el7.cern.noarch.rpm \
    && yum clean all


# Environment variables for MGDO (to be installed in /user):

ENV \
    MGDODIR="/user/mjsw/MGDO" \
    PATH="/user/mjsw/MGDO/install/bin:$PATH" \
    LD_LIBRARY_PATH="/user/mjsw/MGDO/install/lib:$LD_LIBRARY_PATH" \
    TAMDIR="/user/mjsw/MGDO/tam"

# Environment variables for mjd_siggen (to be installed in /user):

ENV \
    SIGGENDIR="/user/mjsw/mjd_siggen"

# Environment variables for GAT (to be installed in /user):

ENV \
    GATDIR=/user/mjsw/GAT \
    PATH="/user/mjsw/GAT/Apps:/user/mjsw/GAT/Scripts:${PATH}" \
    LD_LIBRARY_PATH="/user/mjsw/GAT/lib:${LD_LIBRARY_PATH}"


# Environment variables for MJOR (to be installed in /user):

ENV \
    MJORDIR=/user/mjsw/MJOR \
    LD_LIBRARY_PATH="/user/mjsw/MJOR/lib:${LD_LIBRARY_PATH}" \
    PATH="/user/mjsw/MJOR:${PATH}"


# Environment variables for MaGe (to be installed in /user):

ENV \
    MAGEDIR="/user/mjsw/MaGe" \
    PATH="/user/mjsw/MaGe/install/bin:$PATH" \
    LD_LIBRARY_PATH="/user/mjsw/MaGe/install/lib:$LD_LIBRARY_PATH" \
    MGGERDAGEOMETRY="/user/mjsw/MaGe/gerdageometry"


# Copy MAJORANA software install scripts:

COPY scripts/mj-sw-*.sh /usr/local/bin/


# Set container-specific SWMOD_HOSTSPEC:

ENV SWMOD_HOSTSPEC="linux-centos-7-x86_64-aec2b2b4"


# Final steps

CMD /bin/bash
