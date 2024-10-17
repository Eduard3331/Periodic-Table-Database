PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN_MENU(){
  #in case of no argument
  if [[ -z $1 ]]
  then
    EXIT "Please provide an element as an argument."
  else
case $1 in

#in case of an atomic number
  [0-9]*)
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  #if it doesn't exist
  if [[ -z $ATOMIC_NUMBER ]]
  then
    EXIT "I could not find that element in the database."
  else
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
  fi
  ;;

#in case of a symbol
 [A-Za-z] | [A-Za-z][A-Za-z])
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
  #if it doesn't exist
  if [[ -z $SYMBOL ]]
    then
    EXIT "I could not find that element in the database."
  else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$1'")
  fi
  ;;

#in case of a name
  *)
    NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
  #if it doesn't exist
  if [[ -z $NAME ]]
    then
    EXIT "I could not find that element in the database."
  else
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$1'")
  fi
  ;;

esac
    #the program runs normally
  if [[ $ATOMIC_NUMBER && $NAME && %SYMBOL ]]
  then
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")

    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
fi
}

EXIT(){
  echo -e "$1"
}

MAIN_MENU $1