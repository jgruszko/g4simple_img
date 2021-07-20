FROM centos:7


# User and workdir settings:

USER root
WORKDIR /root
RUN pwd; ls

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
	openssl-devel \
	scons \
        fdupes \
        libXdmcp \
        texlive-collection-latexrecommended texlive-dvipng texlive-adjustbox texlive-upquote \
        texlive-ulem texlive-xetex inkscape \
    && dbus-uuidgen > /etc/machine-id


# Copy provisioning script(s):
COPY provisioning/install-sw.sh /root/provisioning/

# Install CMake:

COPY provisioning/install-sw-scripts/cmake-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/cmake/bin:$PATH" \
    MANPATH="/opt/cmake/share/man:$MANPATH"

RUN provisioning/install-sw.sh cmake 3.5.1 /opt/cmake

COPY provisioning/install-sw-scripts/clhep-* provisioning/install-sw-scripts/geant4-* provisioning/install-sw-scripts/

ENV \
    PATH="/opt/geant4/bin:/opt/clhep/bin:$PATH" \
    LD_LIBRARY_PATH="/opt/geant4/lib64:/opt/clhep/lib:$LD_LIBRARY_PATH" \
    G4ABLADATA="/opt/geant4/share/Geant4-10.5.0/data/G4ABLA3.1" \
    G4ENSDFSTATEDATA="/opt/geant4/share/Geant4-10.5.0/data/G4ENSDFSTATE2.2" \
    G4LEDATA="/opt/geant4/share/Geant4-10.5.0/data/G4EMLOW7.7" \
    G4LEVELGAMMADATA="/opt/geant4/share/Geant4-10.5.0/data/PhotonEvaporation5.3" \
    G4NEUTRONHPDATA="/opt/geant4/share/Geant4-10.5.0/data/G4NDL4.5" \
    G4PARTICLEXSDATA="/opt/geant4/share/Geant4-10.5.0/data/G4PARTICLEXS1.1" \
    G4NEUTRONXSDATA="/opt/geant4/share/Geant4-10.5.0/data/G4NEUTRONXS1.4" \
    G4PIIDATA="/opt/geant4/share/Geant4-10.5.0/data/G4PII1.3" \
    G4RADIOACTIVEDATA="/opt/geant4/share/Geant4-10.5.0/data/RadioactiveDecay5.3" \
    G4REALSURFACEDATA="/opt/geant4/share/Geant4-10.5.0/data/RealSurface2.1.1" \
    G4SAIDXSDATA="/opt/geant4/share/Geant4-10.5.0/data/G4SAIDDATA2.0" \
    AllowForHeavyElements=1

RUN true \
    && yum install -y \
        expat-devel xerces-c-devel zlib-devel \
        libXmu-devel libXi-devel \
        mesa-libGLU-devel motif-devel mesa-libGLw qt-devel \
    && provisioning/install-sw.sh clhep 2.3.3.0 /opt/clhep \
    && provisioning/install-sw.sh geant4 10.05.p01 /opt/geant4


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
    && provisioning/install-sw.sh root 5.34.36 /opt/root



# Install requirements for NUDOT Software:

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


# Environment variables for other software: 
# ENV \
#    MGDODIR="/user/mjsw/MGDO" \
#    PATH="/user/mjsw/MGDO/install/bin:$PATH" \
#    LD_LIBRARY_PATH="/user/mjsw/MGDO/install/lib:$LD_LIBRARY_PATH" \
#    TAMDIR="/user/mjsw/MGDO/tam"


# Copy MAJORANA software install scripts:

# COPY scripts/mj-sw-*.sh /usr/local/bin/


# Set container-specific SWMOD_HOSTSPEC:

ENV SWMOD_HOSTSPEC="linux-centos-7-x86_64-aec2b2b4"


# Final steps

CMD /bin/bash
