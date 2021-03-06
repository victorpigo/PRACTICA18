#!/bin/bash

readonly ARCHIVE_DIR='/archive'

usage() {

  echo >&2
  echo "Utilització: ${0} [-dra] USER [USERN]..." >&2
  echo 'Desactivar usuario local Linux.' >&2
  echo '  -d  Suprimeix els comptes en lloc de desactivar-los.' >&2
  echo '  -r  Elimina el directori personal associat al compte.' >&2
  echo '  -a  Crea una còpia de seguretat de la carpeta de l usuari existent.' >&2
  exit 1
}
#Comprovem que l'usuari es root
if [[ $EUID -ne 0 ]]
then
echo -e "L'usuari NO es root, no es permet executar el script"
exit 1
fi

#Declarem les opcions
while getopts dra OPTION
do
  case ${OPTION} in
    d) DELETE_USER='true' ;;
    r) REMOVE_OPTION='true' ;;
    a) ARCHIVE='true' ;;
    ?) usage ;;
  esac
done

shift "$(( OPTIND - 1 ))"

if [[ "${#}" < 1 ]]
then
  usage
fi

for USERNAME in "${@}"
do
  echo "Processant usuari: ${USERNAME}"

#Comprovem que el UID del user es almenys 1000
  USERID=$(id -u ${USERNAME})
  if [[ "${USERID}" -lt 1000 ]]
  then
    echo "Rebuig de retirar el fitxer ${USERNAME} usuari amb UID ${USERID}." >&2
    exit 1
  fi

#Opcio d'arxivar l'user
  if [[ "${ARCHIVE}" = 'true' ]]
  then

    if [[ ! -d "${ARCHIVE_DIR}" ]]
    then
      echo "Creant directori ${ARCHIVE_DIR} ."
      mkdir -p ${ARCHIVE_DIR}

      if [[ "${?}" != 0 ]]
      then
        echo "L’arxiu de directori ${ARCHIVE_DIR} no es pot crear." >&2
        exit 1
      fi
    fi

    HOME_DIR="/home/${USERNAME}"
    ARCHIVE_FILE="${ARCHIVE_DIR}-${USERNAME}.tgz"
    if [[ -d "${HOME_DIR}" ]]
    then
      echo "Arxivant ${HOME_DIR} a ${ARCHIVE_FILE}"
      tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
      if [[ "${?}" != 0 ]]
      then
        echo "No es pot crear ${ARCHIVE_FILE}." >&2
        exit 1
      fi
    else
       echo "${HOME_DIR} no existeix." >&2
       exit 1
    fi
  fi

#Opcio borrar directori   
	if [[ "${REMOVE_OPTION}" = 'true' ]]
  then
	rm -r /home/${USERNAME}
	echo "Directori borrat. "
	fi

#Opcio borrar usuari
  if [[ "${DELETE_USER}" = 'true' ]]
  then

    userdel ${USERNAME}

    if [[ "${?}" != 0 ]]
    then
      echo "L’usuari ${USERNAME} no s'ha suprimit." >&2
      exit 1
    fi
    echo "L’usuari ${USERNAME} s’ha suprimit."
  else

    chage -E 0 ${USERNAME}


    if [[ "${?}" != 0 ]]
    then
      echo "L’usuari ${USERNAME} no s’ha desactivat." >&2
      exit 1
    fi
    echo "L’usuari ${USERNAME} s’ha desactivat."
  fi
done

exit 0
