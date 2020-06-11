#!/bin/bash

CIPHER="aes-128-cbc"
FLAGS="-salt -pbkdf2"
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

P="`dirname ${0}`"
O="${P}/`basename ${1} .${1##*.}`_enc.sh"

if [ -f "${O}" ]; then
	echo -n "${O} exists. Overwrite? (Y/n) "
	read Y
	if [ "${Y}" == "n" ] || [ "${Y}" == "N" ]; then
		exit
	fi
fi

C="`gzip < ${1} | openssl ${CIPHER} -a ${FLAGS}`"

if [ $? -ne 0 ];then
	echo "openssl error"
	exit
fi

H="\
#!/bin/bash\n\
P=\"\`dirname \${0}\`\"\n\
O=\"\`mktemp -p \${P}\`\"\n\
S='\n\
${C}\n\
'\n\
echo \"\${S}\" | openssl ${CIPHER} -d -a ${FLAGS} | gunzip > \${O} 2>/dev/null\n\
if [ \$? -ne 0 ]; then\n\
	echo \"Invalid password\"\n\
else\n\
	${INT} \${O} \${*}\n\
fi\n\
rm \${O} 2>/dev/null\
"

echo -e "${H}" > ${O}

echo "${O} created"

