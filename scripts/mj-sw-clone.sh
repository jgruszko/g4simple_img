#!/bin/bash -e

svn co http://radware.phy.ornl.gov/MJ/mjd_siggen "$SIGGENDIR"

git clone git@github.com:mppmu/MGDO.git "$MGDODIR"
git clone git@github.com:mppmu/GAT.git "$GATDIR"
git clone git@github.com:mppmu/MJOR.git "$MJORDIR"
git clone git@github.com:mppmu/MaGe.git "$MAGEDIR"
