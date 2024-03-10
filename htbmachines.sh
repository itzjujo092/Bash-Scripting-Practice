#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
  echo -e "\n\n${redColour} [!] Saliendo....${endColour}\n"
  tput cnorm;exit 1
}
# Ctrl C
trap ctrl_c INT

# Variables Globales
main_url="https://htbmachines.github.io/bundle.js"

function helpPanel(){
  echo -e "\n ${yellowColour}[*] Herramienta para buscar maquinas de HTB${endColour}\n\n${blueColour} ----> Uso ${endColour}" 
  echo -e "\n${purpleColour}[RECOMENDADO] -u Busca actualizaciones nuevas ${endColour}"
  echo -e "\n\t${redColour}      -m Buscar por el nombre de la máquina${endColour}"
  echo -e "\n\t${redColour}      -i Buscar por una direccion IP${endColour}"
  echo -e "\n\t${redColour}      -o Buscar por el Sistema Operativo de la máquina${endColour}"
  echo -e "\n\t${redColour}      -s Buscar por Skill${endColour}"
  echo -e "\n\t${redColour}      -y Buscar el video de la resolución de la máquina${endColour}"
  echo -e "\n\t${redColour}      -d Buscar por la dificultad de la maquina ${grayColour}<< Insane, Media, Difícil, Fácil >>${endColour}${endColour}"
  echo -e "\n\t${greenColour}      -h Mostrar este panel de ayuda${endColour}"
}


function updateFiles(){

  echo -e " \n${yellowColour} [+]${endColour}${grayColour} Comprobando si hay actualizaciones pendientes..."
  sleep 3

 if [ ! -f bundle.js ]; then
   tput civis
   echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios... ${endColour}"
   curl -s $main_url > bundle.js
   js-beautify bundle.js | sponge bundle.js
   echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos han sido descargados ${endColour}"
 tput cnorm 
 else
   curl -s $main_url > bundletemp.js 
   js-beautify bundletemp.js | sponge bundletemp.js
   mdtemp_value=$(md5sum bundletemp.js | awk '{print $1}')
   md5original_value=$(md5sum bundle.js | awk '{print $1}')

   if [ "$mdtemp_value" == "$md5original_value" ];then
     echo -e "\n ${greenColour}[+]${endColour} ${grayColour}No hay actualizaciones pendientes! ${endColour}"
     rm bundletemp.js 
   else 
     rm bundle.js && mv bundletemp.js bundle.js
     echo -e "\n${yellowColour} [*]${endColour} ${grayColour}Se ha actualizado exitosamente! ${endColour} \n"
    
   fi  

   tput cnorm
 fi 
}
function searchMachine(){
  machineName="$1"
   
  machineNamechecker="$(cat bundle.js | awk /"name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/ *//' | sed 's/:/ =/')"
  
  if [ "$machineNamechecker" ]; then
  
  echo -e "\n [+] Listando las propiedades de la maquina $machineName\n"
  cat bundle.js | awk /"name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/ *//' | sed 's/:/ =/'
  else
    echo -e "\n [!] La maquina proporcionada no existe, verifica nuevamente."

  fi 
}

function searchIP(){
  ipAddress="$1"
  echo -e "\n [+] Buscando la máquina...\n"
  sleep 4
  nameip=$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name: " | awk '{print$2}' | tr -d '"' |tr -d ',')
  if [ "$nameip" ]; then
  echo -e "\n [] El nombre de la máquina es $nameip\n"
  searchMachine $nameip
else 
  echo -e "·\n [!]La direccion IP proporcionada no existe, verifica nuevamente"
  fi
}

function getyoutube(){

 machineName="$1"

 ytlink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|resuelta:|sku:" | tr -d '"' | tr -d ',' | sed 's/ *//' | grep youtube | awk 'NF {print $NF}')"
  
 if [ $ytlink ]; then
  echo -e "\n [+] El video de la resolución de esta máquina es -----> $ytlink \n"
 else 
   echo -e "\n[!] La maquina proporcionada no existe, verifica nuevamente! \n"
 fi
}

function getdificultad(){
  machineName="$1"

  dificultad="$(cat bundle.js| grep "dificultad: \"$machineName\""  -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ "$machineName" == "Fácil" ]; then 
    echo -e "\n [+] Las maquinas con la dificultad ${greenColour}$machineName${endColour} son: \n"
    cat bundle.js| grep "dificultad: \"$machineName\""  -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column

  elif [ "$machineName" == "Media" ]; then
    echo -e "\n [+] Las maquinas con la dificultad ${yellowColour}$machineName${endColour} son: \n"
    cat bundle.js| grep "dificultad: \"$machineName\""  -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column

  elif [ "$machineName" == "Difícil" ]; then
    echo -e "\n [+] Las maquinas con la dificultad ${redColour}$machineName${endColour} son: \n"
    cat bundle.js| grep "dificultad: \"$machineName\""  -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column

  elif [ "$machineName" == "Insane" ]; then
    echo -e "\n [+] Las maquinas con la dificultad ${purpleColour}$machineName${endColour} son: \n"
    cat bundle.js| grep "dificultad: \"$machineName\""  -B 5 | grep name | awk '{print $NF}' | tr -d '"' | tr -d ',' | column

  else
    echo -e "\n [!] La dificultad proporcionada no existe, verifica nuevamente!"
  
  fi 
  
}

function searchforOS(){
 operativename="$1"

 SO="$(cat bundle.js | grep "so: \"$operativename\"" -B 4 | grep "name" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column)"

 if [ "$operativename" == "Windows" ]; then 
    echo -e "\n [+] Las maquinas con el Sistema Operativo ${blueColour} $operativename ${endColour} son: \n"
    cat bundle.js | grep "so: \"$operativename\"" -B 4 | grep "name" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column
 elif [ "$operativename" == "Linux" ]; then
    echo -e "\n [+] Las maquinas con el Sistema Operativo ${greenColour} $operativename ${endColour} son: \n"
    cat bundle.js | grep "so: \"$operativename\"" -B 4 | grep "name" | awk '{print $NF}' | tr -d '"' | tr -d ',' | column     
 else
  echo -e "\n [!] El sistema operativo proporcionado no existe, verifica nuevamente!"

  
 fi    

}

function getOSDifficultyMachines (){
 dachineName="$1"
 osye="$2"

 verifydifi_and_os="$(cat bundle.js | grep "so: \"$osye\"" -C 4 | grep "dificultad: \"$dachineName\"" -B 5 | grep "name: " | awk '{print $NF}' | tr -d '"'| tr -d ',' | column)"

 if [ "verifydifi_and_os" ]; then
   echo -e "\n [+] Listando máquinas de dificulad $dachineName con sistema operativo $osye"
   sleep 3
   cat bundle.js | grep "so: \"$osye\"" -C 4 | grep "dificultad: \"$dachineName\"" -B 5 | grep "name: " | awk '{print $NF}' | tr -d '"'| tr -d ',' | column
  
 else
   echo -e "\n [!] Se ha indicado una dificultad o un Sistema Operativo incorrecto! "
  
 fi 
}

function getSkill(){
 skills="$1"

 skillcheck="$(cat bundle.js | grep "skills: " -B 6 | grep "$skills" -i -B 6 | grep "name: " | awk '{print $NF}' | tr -d '"' | tr -d '', | column)"

 if [ "$skillcheck" ]; then 
   echo -e "\n [+] Buscando por aquellas máquinas que tengan la skill de $skills\n"
   sleep 2
   cat bundle.js | grep "skills: " -B 6 | grep "$skills" -i -B 6 | grep "name: " | awk '{print $NF}' | tr -d '"' | tr -d '', | column

 else
  echo -e "\n [!] La skill que has buscado no existe! Comprueba nuevamente"
 fi

}

#  Indicadores
declare -i parameter_counter=0 

# Chivato (Esto es para indicar los chivatos, osea los que van a hacer que podamos compactar 2 argumentos en un mismo comando)
declare -i chivato_difficulty=0 
declare -i chivato_os=0 

while getopts "m:i:d:y:o:s:hu" arg ; do 
  case $arg in 
   m) machineName=$OPTARG; let parameter_counter+=1;; 
   u) let parameter_counter+=2;;
   i) ipAddress=$OPTARG; let parameter_counter+=3;;
   y) machineName=$OPTARG; let parameter_counter+=4;;
   d) dachineName=$OPTARG; chivato_difficulty=1; let parameter_counter+=5;;
   o) operativename=$OPTARG; chivato_os=1; let parameter_counter+=6;;
   s) skill=$OPTARG; let parameter_counter+=7;;
   h) ;;
 
 esac   
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName 
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then 
  searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
  getyoutube $machineName
elif [ $parameter_counter -eq 5 ]; then 
  getdificultad $dachineName
elif [ $parameter_counter -eq 6 ]; then 
  searchforOS $operativename
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
  getOSDifficultyMachines $dachineName $operativename
elif [ $parameter_counter -eq 7 ]; then 
  getSkill "$skill"
else
  helpPanel
fi  
