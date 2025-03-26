#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ -z "$1" ]; then
  echo "Please provide an element as an argument."
elif [ $# -eq 1 ]; then
  if [[ "$1" =~ ^[0-9]+$ ]]; then # input is a number
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name from elements where atomic_number="$1";")
  else # input is a string
    ELEMENT=$($PSQL "SELECT atomic_number, symbol, name from elements where name='$1' or symbol='$1';")
  fi

  if [ -z "$ELEMENT" ]; then
    echo "I could not find that element in the database."

  else
    IFS="|" read -r atomic_number symbol name <<< "$ELEMENT"
    PROPERTY=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type_id from properties where atomic_number='$atomic_number';")
    if [ -z "$PROPERTY" ]; then
      echo "I could not find the property for Element $atomic_number in the database."
    else
      IFS="|" read -r atomic_mass melting_point_celsius boiling_point_celsius type_id <<< "$PROPERTY"
      TYPE=$($PSQL "SELECT type from types where type_id='$type_id';")
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $TYPE, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    fi
  fi
fi
