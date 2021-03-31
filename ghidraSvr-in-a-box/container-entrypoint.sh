#!/bin/bash

if [ ! -f /mnt/ghidra/server.conf ]; then
  echo "No server.conf found - you must mount '/mnt/ghidra' and this directory must contain a valid 'server.conf' file." 1>&2
  exit 1
fi

if [ ! -x /mnt/ghidra/repositories ]; then
  mkdir /mnt/ghidra/repositories
fi

echo "  ========== ATTENTION ==========  "
echo "Note that you must add at least one user, or connections will fail. Run 'svrAdmin' with the running container to add a user. No restart is necessary."
echo "See https://htmlpreview.github.io/?https://github.com/NationalSecurityAgency/ghidra/blob/Ghidra_$(echo ${GHIDRASRV_IN_A_BOX_VERSION} | cut -d'_' -f1)_build/Ghidra/RuntimeScripts/Common/server/svrREADME.html#serverAdministration for details."
echo "  ===============================  "

cd /ghidra/ghidra/server && ./ghidraSvr console
