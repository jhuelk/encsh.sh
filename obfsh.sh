#!/usr/bin/env bash
set -u

INT="/bin/bash" # default interpreter

if [ "$#" -lt 1 ]; then
	echo "Usage: ${0} script [interpreter=${INT}]"
	exit
fi

if [ "$#" -gt 1 ]; then
	INT=${2}
fi

if [ ! -f "${1}" ]; then
	echo "Cannot open ${1}"
	exit
fi

P=$(dirname "${1}")
O=${P}/$(basename "${1}" ".${1##*.}")_obf.sh

if [ -f "${O}" ]; then
	echo -n "${O} exists. Overwrite? (Y/n) "
	read -r Y
	if [ "${Y}" == "n" ] || [ "${Y}" == "N" ]; then
		exit
	fi
fi

C=$(gzip < "${1}" | base64)

if [ $? -ne 0 ];then
	echo "error"
	exit
fi

H="\
#!/usr/bin/env bash\n\
G=\"SIGINT SIGTERM ERR EXIT\"; set -Eeu; trap c \${G};\n\
S='\n\
${C}\n\
'\n\
N=\"/dev/null\";\
W=\$(which which);\
C=\$(\${W} base64);\
Z=\$(\${W} gunzip);\
D=\$(\${W} dirname);\
M=\$(\${W} mktemp);\
if \${W} shred 1>\${N}; then R=\"\$(\${W} shred) -u\"; else R=\$(\${W} rm); fi;\
P=\$(\${D} \"\${0}\");\
O=\$(\${M} -p \"\${P}\");\
c(){ trap - \${G}; \${R} \"\${O}\" 2>\${N}; };\
echo \"\${S}\" | \${C} -d 2>\${N} | \${Z} > \"\${O}\" 2>\${N}; ${INT} \"\${O}\" \${*}\
"

echo -e "${H}" > "${O}"

echo "${O} created"

