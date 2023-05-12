#!/bin/bash

# Entrega de: 318112 - Mateo Cabrera | 257620 - Joaquin Hernandez | 305968 - Alfonso Saizar 

actualDate=$( date +%x) >/dev/null
actualHour=`date +"%H:%M"` >/dev/null
opcionLetra=a >/dev/null
echo "" >> usuarios.txt
bienvenida(){
    echo -e "\nBienvenido! \n1)Registrar Usuario. \n2)Ingresar al sistema. \n3)Salir del sistema"
    read opcion
    case $opcion in
        1)
        op1
        ;;

        2)
        op2
        ;;

        3)
        exit
        ;;

        *)
        echo -e "No es una opcion valida\n"
        bienvenida
        ;;
    esac
}

op1 () {
    newUserRequest=0
    while [[ $newUserRequest -ne 1 ]];
    do
        echo -e "Registro de usuario: \nIngrese nombre de usuario:"
        read nUsuario
        checkNewUser=$(grep $nUsuario usuarios.txt | cut -d ',' -f1)
        if  [ "$checkNewUser" == "$nUsuario" ];then
            echo -e "\nUsuario ya registrado.\n"
            bienvenida
        else
            newUserRequest=1
        fi
    done
    echo "Ingrese contraseña"
    read nContrasena
    echo $nUsuario,$nContrasena,$actualDate >> usuarios.txt
    bienvenida
}

op2 () {
    userRequest=0
    while [ $userRequest -ne 1 ];
    do
        echo "Ingrese su usuario o '.' para salir:"
        read lUsuario
        checkUser=$(grep $lUsuario usuarios.txt | cut -d ',' -f1)
        if  [ "$checkUser" == "$lUsuario" ]; then
            userRequest=1
            lastLogin=$(grep $lUsuario usuarios.txt | cut -d ',' -f3)
            passRequest=0
            while [ $passRequest -ne 1 ];
            do
                echo "Ingrese contraseña o '.' para salir:"
                read lContrasena
                checkPass=$(grep $lUsuario usuarios.txt | cut -d ',' -f2)
                if [ "$checkPass" == "$lContrasena" ];
                then
                    passRequest=1
                elif [ "$lContrasena" == "." ]; then
                    bienvenida
                else
                    echo -e "Contraseña incorrecta.\n"
                fi
            done
        elif [ "$lUsuario" == "." ]; then
            bienvenida
        else
            echo -e "Usuario no encontrado.\n"
        fi
    done
    echo -e "\n----------------------------------------------\nBienvenido $lUsuario"
    echo -e "Usted ingresó por última vez el $lastLogin \n----------------------------------------------\n" 

    lastLogin=$(grep $lUsuario usuarios.txt | cut -d ',' -f3)
    lugar=$(grep -n $lUsuario usuarios.txt | cut -d ':' -f1)
    sed -i "${lugar}s|$lastLogin|$actualDate|" usuarios.txt
    
    menu2
}

menu2(){
    echo -e "1) Cambiar Contraseña. \n2) Escoger una letra (actualmente $opcionLetra) \n3) Buscar palabras en el diccionario que comiencen con la letra escogida. \n4) Contar las palabras de la Opcion 3. \n5) Guardar las palabras en un archivo.txt, en conjunto con la fecha y hora de realizado el informe. \n6) Volver al menu principal."
    read opcionMenu2
        case $opcionMenu2 in
        1)
        cambiarContrasena
        menu2
        ;;

        2)
        echo "Escriba la letra que quiere utilizar"
        read opcionLetra
        menu2
        ;;
        #utilizamos la primer letra de cada palabra como parámetro de búsqueda
        3)
        buscarDiccionario
        menu2
        ;;

        4)
        contarPalabras
        menu2
        ;;

        5)
        guardarPalabras
        menu2
        ;;

        6)
        echo ""
        bienvenida
        ;;

        *)
        echo -e "No es una opcion valida\n"
        menu2
        ;;
    esac
}

cambiarContrasena(){
    cActual=$(grep $lUsuario usuarios.txt | cut -d ',' -f2)
    lugar=$(grep -n $lUsuario usuarios.txt | cut -d ':' -f1)
    echo "$lUsuario, ingrese su nueva contraseña: "
    op=1
    while [ $op -eq 1 ]; do
        read cNueva
        if [ "$cNueva" == "$cActual" ]; then
            echo "Ingrese la contraseña nuevamente:"
        else 
            op=0
        fi
    done
    sed -i "${lugar}s/$cActual/$cNueva/" usuarios.txt 
    #find ./ -type f -exec sed -i '' -e "${lugar}s/$cActual/$cNueva/" usuarios.txt \; #opcion mac
    echo -e "Se ha actualizado la contraseña con éxito.\n"
}

buscarDiccionario () {
    echo $(grep "^$opcionLetra" diccionario.txt)
    echo -e "\nListo!\n"
}

contarPalabras () {
    echo -e "\nHay $(grep -c "^$opcionLetra" diccionario.txt) palabras con $opcionLetra"
    echo -e "Listo!\n"
}

guardarPalabras () {
    echo $actualDate,$actualHour > palabrasGuardadas.txt
    grep "^$opcionLetra" diccionario.txt >> palabrasGuardadas.txt
    echo -e "\nListo!\n"
    menu2
}
bienvenida

# Entrega de: 318112 - Mateo Cabrera | 257620 - Joaquin Hernandez | 305968 - Alfonso Saizar 