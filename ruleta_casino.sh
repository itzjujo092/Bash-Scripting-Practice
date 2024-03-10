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
  echo -e "\n ${redColour}[!] Saliendo... ${endColour}\n"
  exit 1
}

# Ctrl C 
trap ctrl_c INT
tput cnorm 
#Funciones

function helpPanel(){
  echo -e "\n ${yellowColour} [*] Herramienta para predecir los resultados de una ruleta de casino${endColour}\n\n${blueColour} ----> Uso $0 ${endColour}"
  echo -e "\n\t${greenColour}      -m Asigna el dinero que se va a usar${endColour}"
  echo -e "\n\t${greenColour}      -t Técnica que se va a utilizar (martingala, inverseLabrouchere, fibonacci)${endColour}"

}

function tecmartingala(){
  echo -e "\n ${yellowColour}[+] ${endColour} ${grayColour}Dinero actual: ${endColour}${yellowColour}$money ${endColour}"
  echo -ne "$yellowColour [+]${endColour} ${grayColour}Cuanto dinero tienes pensado apostar? --->${endColour}" && read initial_bet
  echo -ne "$yellowColour [+]${endColour} ${grayColour}A qué deseas apostar continuamente? (par/impar)? ---> $endColour"&& read par_impar

  echo -e "\n ${yellowColour}[+] ${endColour}${grayColour} Vamos a jugar con una cantidad inicial de${endColour}$yellowColour $initial_bet${endColour} ${grayColour}a ${endColour}${yellowColour}$par_impar${endColour}"
 
  backup_bet=$initial_bet
  play_counter=1
  jugadas_malas=""
  maximo_dinero=$money

  tput civis 
  while true; do

    money=$(($money-$initial_bet))
    echo -e "\n ${yellowColour} [+] ${endColour} ${grayColour}Acabas de apostar ${endColour} ${yellowColour}$initial_bet$ ${endColour}${grayColour} y tienes ${endColour} ${yellowColour}$money$ ${endColour}"
    random_number="$(($RANDOM % 37))"
    echo -e "${yellowColour}  [+]${endColour}  Ha salido el número ${endColour}${yellowColour}$random_number${endColour}"
    

    if [ ! "$money" -lt 0 ]; then 
      if [ "$par_impar" == "par" ]; then
        #Definicion de numeros pares
        if [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then 
            echo -e "${redColour}[+] Ha salido el 0, por lo tanto perdemos ${endColour}"
            initial_bet=$(($initial_bet*2))
            jugadas_malas+="$random_number "
           echo -e "${yellowColour}[+] ${endColour} ${grayColour}Ahora mismo te quedas en ${endColour}${yellowColour}$money$ ${endColour}"

          else    
          echo -e "${yellowColour}  [+]${endColour} ${greenColour} El numero que ha salido es par, ¡ganas!$endColour"
            reward=$(($initial_bet*2))
       echo -e "$yellowColour  [+]${endColour} ${grayColour} Ganas un total de ${endColour}${yellowColour}$reward$ ${endColour}"
            money=$(($money+$reward))
              if [ $money -gt $maximo_dinero ]; then 
              maximo_dinero=$money
              fi 

             
             echo -e "${yellowColour}  [+]${endColour} ${grayColour} Tienes${endColour} ${yellowColour}$money$ $endColour" 
            initial_bet=$backup_bet
            jugadas_malas=""
          fi
        else 
         echo -e "${yellowColour}  [+] ${endColour} ${redColour}EL numero que ha salido es impar, ¡pierdes!${endColour}"
        initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
       echo -e "${yellowColour}[+] ${endColour} ${grayColour}Ahora mismo te quedas en ${endColour}${yellowColour}$money$ ${endColour}"
         fi 
    else 
        #LA definicion es numeros impares
        if [ "$(($random_number % 2))" -eq 1 ]; then
         #      echo -e "${yellowColour}  [+]${endColour} ${greenColour} El numero que ha salido es par, ¡ganas!$endColour"
            reward=$(($initial_bet*2))
       echo -e "$yellowColour  [+]${endColour} ${grayColour} Ganas un total de ${endColour}${yellowColour}$reward$ ${endColour}"
            money=$(($money+$reward))

          
             echo -e "${yellowColour}  [+]${endColour} ${grayColour} Tienes${endColour} ${yellowColour}$money$ $endColour" | 
            initial_bet=$backup_bet
            jugadas_malas=""
              if [ $money -gt $maximo_dinero ]; then 
              maximo_dinero=$money
              fi 
          else     
    echo -e "${yellowColour}  [+] ${endColour} ${redColour}EL numero que ha salido es par, ¡pierdes!${endColour}"
            initial_bet=$(($initial_bet*2))
            jugadas_malas+="$random_number "
            
        fi 
      fi 

    else
        # Eso es porque nos quedamos sin dinero 
        echo -e "\n ${redColour}[!] Nos hemos quedado sin dinero!!! ${endColour}\n"
        echo -e "${yellowColour} [+]${endColour} ${grayColour} Han habido un total de${endColour} $yellowColour$(($play_counter-1))${endColour} ${grayColour}jugadas${endColour}"
        echo -e "\n${yellowColour} [+] ${endColour} ${grayColour}A contunuación se van a representar las malas jugadas consecutivas que han salido$endColour"
        echo -e "${blueColour}[ $jugadas_malas]${endColour}"
        echo -e "El maximo dinero obtenido fue $maximo_dinero"
        tput cnorm; exit 0 
    fi

   let play_counter+=1 

   done 
   tput cnorm 
}

function inverseLabrouchere(){
   echo -e "\n${yellowColour}[+] ${endColour} ${grayColour}Dinero actual: ${endColour}${yellowColour}$money ${endColour}"
   echo -ne "$yellowColour[+]${endColour} ${grayColour}A qué deseas apostar continuamente? (par/impar)? ---> $endColour"&& read par_impar

   declare -a my_sequence=(1 2 3 4)
  
   echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia ${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"

   bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

   jugadastotales=0 
   bet_to_renew=$(($money+50)) # DInero el cual una vez alcanzado hará que renovemos nuestra secuencia a [1 2 3 4]
   maximo_dinero=$money
   echo -e "${yellowColour}[+] ${endColour} ${grayColour}El tope a renovar la secuencia está establecido por encima de los${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"

   tput civis 
   while true; do 
     let jugadastotales+=1
     random_number=$(($RANDOM % 37))
     money=$(($money - $bet))

    if [ ! "$money" -lt 0 ]; then 
     echo -e "${yellowColour}[+]${endColour}${grayColour} Invertimos${endColour}${yellowColour} $bet$ ${endColour}"
     echo -e "${yellowColour}[+] ${endColour} $grayColour Tenemos $endColour  ${yellowColour}$money$ ${endColour}"

     echo -e "\n${yellowColour}[+]${endColour} ${grayColour} Ha salido el número${endColour} ${blueColour} $random_number ${endColour}"
     if [ "$par_impar" == "par" ]; then 
       if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then 
         echo -e "${yellowColour}[+]${endColour} ${greenColour} El numero es par, ¡ganas!${endColour}"
         reward=$(($bet*2))
         let money+=$reward
         echo -e "${yellowColour}[+] $endColour ${grayColour}Tienes${endColour}${yellowColour} $money$ ${endColour}"
                if [ $money -gt $maximo_dinero ]; then
                  maximo_dinero=$money
                fi

          if [ $money -gt $bet_to_renew ]; then
            echo -e "${yellowColour}[+] ${endColour} ${grayColour}Se ha superado el tople establecido de ${endColour}${yellowColour} $bet_to_renew$ ${endColour} ${grayColour}para renovar nuestra secuencia${endColour}"
            bet_to_renew=$((${bet_to_renew} + 50))
            echo -e "${yellowColour}[+] ${endColour} ${grayColour}El tope se ha establecido en ${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"
            my_sequence=(1 2 3 4)
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            echo -e "${yellowColour}[+] ${endColour} ${grayColour}La secuencia ha sido restablecida a: ${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
          elif [ $money -lt $(($bet_to_renew-100)) ]; then
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Hemos llegado a un mínimo crítico, se procede a reajustar el tope${endColour}"
            bet_to_renew=$(($bet_to_renew - 50))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"

            my_sequence+=($bet)
            my_sequence=(${my_sequence[@]})

            echo -e "${yellowColour}[+] ${endColour} ${grayColour} Nuestra nueva secuencia es ${endColour} ${greenColour}[${my_sequence[@]}] ${endColour}"
            if [ "${#my_sequence[@]}" -gt 1 ]; then
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[@]}" -eq 1 ]; then
                bet=${my_sequence[0]} 
            fi
          fi 

       elif [ "$random_number" -eq 0 ]; then 
           echo -e "${redColour}[!] Ha salido el cero, ¡pierdes!${endColour}"

           unset my_sequence[0]
           unset my_sequence[-1] 2>/dev/null

           my_sequence=(${my_sequence[@]})

           echo -e "${yellowColour}[+] ${endColour} ${grayColour}La secuencia se nos queda de la siguiente forma: ${endColour}${purpleColour}[${my_sequence[@]}]${endColour}"
             echo -e "${yellowColour}[+] ${endColour} ${grayColour}Nuestra nueva secuencia es ${endColour} ${greenColour}[${my_sequence[@]}] ${endColour}"
           if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -gt 0 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
           elif [ "${#my_sequence[@]}" -eq 1 ]; then
             bet=$((${my_sequence[@]} + 0))
           else
              echo -e "${redColour}[!]  Hemos perdido nuestra secuencia ${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour} ${grayColour} Restablecemos la secuencia a ${endColour} ${greenColour} [${my_sequence[@]}] ${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
           fi
              if [ $money -gt $bet_to_renew ]; then
                echo -e "${yellowColour}[+] ${endColour} ${grayColour}Se ha superado el tople establecido de ${endColour}${yellowColour} $bet_to_renew$ ${endColour} ${grayColour}para renovar nuestra secuencia${endColour}"
                bet_to_renew=$((${bet_to_renew} + 50))
                echo -e "${yellowColour}[+] ${endColour} ${grayColour}El tope se ha establecido en ${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"
                my_sequence=(1 2 3 4)
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                echo -e "${yellowColour}[+] ${endColour} ${grayColour}La secuencia ha sido restablecida a: ${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
              elif [ $money -lt $(($bet_to_renew-100)) ]; then
                echo -e "${yellowColour}[+]${endColour} ${grayColour}Hemos llegado a un mínimo crítico, se procede a reajustar el tope${endColour}"
                bet_to_renew=$(($bet_to_renew - 50))
                echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"

                my_sequence+=($bet)
                my_sequence=(${my_sequence[@]})

                echo -e "${yellowColour}[+] ${endColour} ${grayColour} Nuestra nueva secuencia es ${endColour} ${greenColour}[${my_sequence[@]}] ${endColour}"
                if [ "${#my_sequence[@]}" -gt 1 ]; then
                    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                elif [ "${#my_sequence[@]}" -eq 1 ]; then
                    bet=${my_sequence[0]} 
                fi
                    if [ $money -gt $maximo_dinero ]; then
                      maximo_dinero=$money
                    fi
              fi 
       else 
           echo -e "${redColour}[!] El numero es impar, ¡pierdes!${endColour}"

           unset my_sequence[0]
           unset my_sequence[-1] 2>/dev/null

           my_sequence=(${my_sequence[@]})

           echo -e "${yellowColour}[+] ${endColour} ${grayColour}La secuencia se nos queda de la siguiente forma: ${endColour}${purpleColour}[${my_sequence[@]}]${endColour}"
             echo -e "${yellowColour}[+] ${endColour} ${grayColour}Nuestra nueva secuencia es ${endColour} ${greenColour}[${my_sequence[@]}] ${endColour}"
           if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -gt 0 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
           elif [ "${#my_sequence[@]}" -eq 1 ]; then
             bet=$((${my_sequence[@]} + 0))
           else
              echo -e "${redColour}[!]  Hemos perdido nuestra secuencia ${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour} ${grayColour} Restablecemos la secuencia a ${endColour} ${greenColour} [${my_sequence[@]}] ${endColour}"
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

              if [ $money -gt $bet_to_renew ]; then
                echo -e "${yellowColour}[+] ${endColour} ${grayColour}Se ha superado el tople establecido de ${endColour}${yellowColour} $bet_to_renew$ ${endColour} ${grayColour}para renovar nuestra secuencia${endColour}"
                bet_to_renew=$((${bet_to_renew} + 50))
                echo -e "${yellowColour}[+] ${endColour} ${grayColour}El tope se ha establecido en ${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"
                my_sequence=(1 2 3 4)
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                echo -e "${yellowColour}[+] ${endColour} ${grayColour}La secuencia ha sido restablecida a: ${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
              elif [ $money -lt $(($bet_to_renew-100)) ]; then
                echo -e "${yellowColour}[+]${endColour} ${grayColour}Hemos llegado a un mínimo crítico, se procede a reajustar el tope${endColour}"
                bet_to_renew=$(($bet_to_renew - 50))
                echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"

                my_sequence+=($bet)
                my_sequence=(${my_sequence[@]})

                echo -e "${yellowColour}[+] ${endColour} ${grayColour} Nuestra nueva secuencia es ${endColour} ${greenColour}[${my_sequence[@]}] ${endColour}"
                if [ "${#my_sequence[@]}" -gt 1 ]; then
                    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                elif [ "${#my_sequence[@]}" -eq 1 ]; then
                    bet=${my_sequence[0]} 
                fi
                    if [ $money -gt $maximo_dinero ]; then
                      maximo_dinero=$money
                    fi
              fi 

           fi
       fi 
     elif [ "$par_impar" == "impar" ]; then
        if [ "$(($random_number % 2))" -eq 1 ]; then 
         echo -e "${yellowColour}[+]${endColour} ${greenColour} El numero es impar, ¡ganas!${endColour}"
         reward=$(($bet*2))
         let money+=$reward
         echo -e "${yellowColour}[+] $endColour ${grayColour}Tienes${endColour}${yellowColour} $money$ ${endColour}"

          if [ $money -gt $maximo_dinero ]; then
            maximo_dinero=$money
          fi

          if [ $money -gt $bet_to_renew ]; then
            echo -e "${yellowColour}[+] ${endColour} ${grayColour}Se ha superado el tople establecido de ${endColour}${yellowColour} $bet_to_renew$ ${endColour} ${grayColour}para renovar nuestra secuencia${endColour}"
            bet_to_renew=$((${bet_to_renew} + 50))
            echo -e "${yellowColour}[+] ${endColour} ${grayColour}El tope se ha establecido en ${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"
            my_sequence=(1 2 3 4)
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            echo -e "${yellowColour}[+] ${endColour} ${grayColour}La secuencia ha sido restablecida a: ${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
          elif [ $money -lt $(($bet_to_renew-100)) ]; then
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Hemos llegado a un mínimo crítico, se procede a reajustar el tope${endColour}"
            bet_to_renew=$(($bet_to_renew - 50))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"

            my_sequence+=($bet)
            my_sequence=(${my_sequence[@]})

            echo -e "${yellowColour}[+] ${endColour} ${grayColour}Nuestra nueva secuencia es ${endColour} ${greenColour} [${my_sequence[@]}] ${endColour}"
            if [ "${#my_sequence[@]}" -ne 1 ]; then
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${my_sequence[@]}" -eq 1 ]; then
                bet=${my_sequence[0]}
            fi

          fi 
       else 
           echo -e "${redColour}[!] El numero es par, ¡pierdes!${endColour}"

                 unset my_sequence[0]
                 unset my_sequence[-1] 2>/dev/null

                 my_sequence=(${my_sequence[@]})

                 echo -e "${yellowColour}[+] ${endColour} ${grayColour}La secuencia se nos queda de la siguiente forma: ${endColour}${purpleColour}[${my_sequence[@]}]${endColour}"
                   echo -e "${yellowColour}[+] ${endColour} ${grayColour}Nuestra nueva secuencia es ${endColour} ${greenColour}[${my_sequence[@]}] ${endColour}"
                 if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -gt 0 ]; then
                    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                 elif [ "${#my_sequence[@]}" -eq 1 ]; then
                   bet=$((${my_sequence[@]} + 0))
                 else
                    echo -e "${redColour}[!]  Hemos perdido nuestra secuencia ${endColour}"
                    my_sequence=(1 2 3 4)
                    echo -e "${yellowColour}[+]${endColour} ${grayColour} Restablecemos la secuencia a ${endColour} ${greenColour} [${my_sequence[@]}] ${endColour}"
                  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                 fi                
                  if [ $money -gt $bet_to_renew ]; then
                    echo -e "${yellowColour}[+] ${endColour} ${grayColour}Se ha superado el tople establecido de ${endColour}${yellowColour} $bet_to_renew$ ${endColour} ${grayColour}para renovar nuestra secuencia${endColour}"
                    bet_to_renew=$((${bet_to_renew} + 50))
                    echo -e "${yellowColour}[+] ${endColour} ${grayColour}El tope se ha establecido en ${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"
                    my_sequence=(1 2 3 4)
                    bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                    echo -e "${yellowColour}[+] ${endColour} ${grayColour}La secuencia ha sido restablecida a: ${endColour} ${greenColour}[${my_sequence[@]}]${endColour}"
                  elif [ $money -lt $(($bet_to_renew-100)) ]; then
                    echo -e "${yellowColour}[+]${endColour} ${grayColour}Hemos llegado a un mínimo crítico, se procede a reajustar el tope${endColour}"
                    bet_to_renew=$(($bet_to_renew - 50))
                    echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${yellowColour}$bet_to_renew$ ${endColour}"

                    my_sequence+=($bet)
                    my_sequence=(${my_sequence[@]})

                    echo -e "${yellowColour}[+] ${endColour} ${grayColour} Nuestra nueva secuencia es ${endColour} ${greenColour}[${my_sequence[@]}] ${endColour}"
                    if [ "${#my_sequence[@]}" -gt 1 ]; then
                        bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                    elif [ "${#my_sequence[@]}" -eq 1 ]; then
                        bet=${my_sequence[0]} 
                    fi
                        if [ $money -gt $maximo_dinero ]; then
                          maximo_dinero=$money
                        fi
                  fi 
         
       fi       
     


     fi 
   else 
     echo -e "\n${redColour}[!] Te has quedado sin dinero!"
     echo -e "${yellowColour}[+] ${endColour}${grayColour}En total han habido${endColour} ${yellowColour}$jugadastotales ${yellowColour}${grayColour}jugadas totales${endColour}"
     echo -e "${yellowColour}[+] ${endColour}${grayColour} El maximo dinero que hemos llegado a tener es ${endColour} ${yellowColour}$maximo_dinero$ ${endColour}"
     tput cnorm; exit 1

   fi

   done

   tput cnorm 

}

function Fibonacci {
    echo -e "\n${yellowColour}[+] ${endColour} ${grayColour}Dinero actual: ${endColour}${yellowColour}$money ${endColour}"
    echo -ne "${yellowColour}[+]${endColour} ${grayColour}A qué deseas apostar continuamente? (par/impar)? ---> $endColour" && read par_impar

    declare -a fibonacci=(0 1)
    bet=${fibonacci[1]}
    total_apuestas=0
    maximo_dinero=$money
    tput civis

    while true; do
        let total_apuestas+=1
        random_number=$(($RANDOM % 37))
        money=$((money - bet))

        if [ "$money" -ge 0 ]; then
        echo -e "${yellowColour}[+]${endColour} ${grayColour}Apuesta actual: ${endColour}${yellowColour} $bet ${endColour}"
        echo -e "${yellowColour}[+]${endColour} ${grayColour}Dinero restante: ${endColour}${yellowColour} $money ${endColour}"

        echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Ha salido el número: ${endColour}${yellowColour} $random_number ${endColour}"

        if [ "$par_impar" == "par" ]; then
            if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
                echo -e "${yellowColour}[+]${endColour} ${greenColour}El número es par, ¡ganaste!${endColour}"
                if [ ${#fibonacci[@]} -ge 2 ]; then 
                fibonacci=("${fibonacci[@]:0:${#fibonacci[@]}-2}")
                fi
                  if [ ${#fibonacci[@]} -eq 0 ]; then 
                    bet=1
                  else 
                    bet=${fibonacci[-1]}
                    if [ $bet -lt 1 ]; then 
                      bet=1
                    fi 
                  fi
                        if [ $money -gt $maximo_dinero ]; then
                          maximo_dinero=$money
                        fi

            else
                echo -e "${yellowColour}[+]${endColour} ${redColour}El número es impar, perdiste.${endColour}"
                if [ ${#fibonacci[@]} -ge 2 ]; then
                  fibonacci+=($((${fibonacci[-1]} + ${fibonacci[-2]})))
                else
                  echo -e "${redColour}[!]  Hemos perdido nuestra secuencia ${endColour}"
                  echo -e "${yellowColour}[+]${endColour} ${grayColour} Restablecemos la secuencia a ${endColour} ${greenColour} [${fibonacci[@]}] ${endColour}"
                  fibonacci=(0 1)
                  bet=${fibonacci[0]}
                  fibonacci+=($((${fibonacci[-1]} + ${fibonacci[-2]})))
                  bet=${fibonacci[0]}
                fi
                bet=${fibonacci[-1]}
            fi
          else
              if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
                  echo -e "${yellowColour}[+]${endColour} ${redColour}El número es par, perdiste.${endColour}"
                  
                  if [ ${#fibonacci[@]} -ge 2 ]; then
                    fibonacci+=($((${fibonacci[-1]} + ${fibonacci[-2]})))
                  else
                      echo -e "${redColour}[!]  Hemos perdido nuestra secuencia ${endColour}"
                      echo -e "${yellowColour}[+]${endColour} ${grayColour} Restablecemos la secuencia a ${endColour} ${greenColour} [${fibonacci[@]}] ${endColour}"
                      fibonacci=(0 1)
                      bet=${fibonacci[0]}
                      fibonacci+=($((${fibonacci[-1]} + ${fibonacci[-2]})))
                      bet=${fibonacci[0]}
                  fi
                      bet=${fibonacci[-1]}
                    
              else
                echo -e "${yellowColour}[+]${endColour} ${greenColour}El número es impar, ¡ganaste!${endColour}"
                if [ ${#fibonacci[@]} -ge 2 ]; then 
                fibonacci=("${fibonacci[@]:0:${#fibonacci[@]}-2}")
                fi
                  if [ ${#fibonacci[@]} -eq 0 ]; then 
                    bet=1
                  else 
                    bet=${fibonacci[-1]}
                    if [ $bet -lt 1 ]; then 
                      bet=1
                    fi 
                  fi 
                    if [ $money -gt $maximo_dinero ]; then
                          maximo_dinero=$money
                    fi
              fi
          fi
        else
          
          echo -e "\n${redColour}[!] Te has quedado sin dinero!"
          echo -e "${yellowColour}[+] ${endColour}${grayColour}En total han habido${endColour} ${yellowColour}$total_apuestas ${yellowColour}${grayColour}jugadas totales${endColour}"
          echo -e "${yellowColour}[+] ${endColour}${grayColour} El maximo dinero que hemos llegado a tener es ${endColour} ${yellowColour}$maximo_dinero$ ${endColour}"
          tput cnorm; exit 1

        fi
    done
    tput cnorm 
}
   function pruebafibo(){

     echo -e "\n${yellowColour}[+] ${endColour} ${grayColour}Dinero actual: ${endColour}${yellowColour}$money ${endColour}"
     echo -ne "$yellowColour[+]${endColour} ${grayColour}A qué deseas apostar continuamente? (par/impar)? ---> $endColour"&& read par_impar

declare -a my_fibonacci=(1 1)

echo "Como ya tenemos 2 valores en el array, empezamos a partir de ahí:"

for i in $(seq 2 10); do
    numElementos=${#my_fibonacci[@]}

    ultimoValor=${my_fibonacci[$numElementos-1]}
    penultimoValor=${my_fibonacci[$numElementos-2]}
    
    nuevoValor=$((${ultimoValor}+${penultimoValor}))
    
    # Actualizamos el array
    my_fibonacci=(${my_fibonacci[@]} ${nuevoValor})
    echo "La secuencia vale: ${my_fibonacci[@]}"
done

   bet=${my_fibonacci[0]}

   echo "La apuesta sera $bet"

   if [ "$par_impar" == "par" ]; then 
     bet=$((${my_fibonacci[1]} + ${my_fibonacci[2]}))
     echo "Nuestra nueva apuesta es $bet" 

for i in $(seq 2 10); do
    numElementos=${#my_fibonacci[@]}

    ultimoValor=${my_fibonacci[$numElementos-1]}
    penultimoValor=${my_fibonacci[$numElementos-2]}
    
    nuevoValor=$((${ultimoValor}+${penultimoValor}))
    
    # Actualizamos el array
    my_fibonacci=(${my_fibonacci[@]} ${nuevoValor})
    echo "La secuencia vale: ${my_fibonacci[@]}"

    bet=$(($ultimoValor + ${nuevoValor}))
    echo "Has ganado! LA nueva apuesta es $bet"
done


   fi 




   }   
# Indicadores
declare -i parameter_counter=0

while getopts "m:t:h" arg ; do 
  case $arg in 
  m) money=$OPTARG; let parameter_counter+=1;;
  t) tecnica=$OPTARG; let parameter_counter+=2;;
  h) helpPanel=$OPTARG; let parameter_counter+=3;;

  esac
done

if [ $money ] && [ $tecnica ]; then 
  if [ "$tecnica" == "martingala" ]; then 
    tecmartingala
  elif [ "$tecnica" == "inverseLabrouchere" ]; then 
    inverseLabrouchere
  elif [ "$tecnica" == "fibonacci" ]; then
    Fibonacci
  elif [ "$tecnica" == "pruebafibonacci" ]; then 
    pruebafibo 
  else 
    echo -e "\n ${redColour} [!] La técnica introducida no existe! Verifica nuevamente $endColour"
    helpPanel
  fi 
else
  helpPanel
fi 
