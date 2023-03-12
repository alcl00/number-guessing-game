#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

NUMBER=$(( ($RANDOM % 1000)+1 ))

echo -e "Enter your username:"
read USERNAME

GET_USERNAME_RESULT=$($PSQL "SELECT * FROM user_info WHERE username='$USERNAME'")

if [[ -z $GET_USERNAME_RESULT ]]
then
{
  ADD_USER_RESULT=$($PSQL "INSERT INTO user_info(username) VALUES('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
}
else
{
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM user_info WHERE username='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM user_info WHERE username='$USERNAME'")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
}
fi

GUESSES=0
echo $GUESSES
echo "Guess the secret number between 1 and 1000:"
while [[ $GUESS -ne NUMBER ]]
do
  read GUESS
  if [[ $GUESS =~ ^[^0-9]+$ ]]
  then
  {
    echo "That is not an integer, guess again:"
  }
  elif [[ $GUESS -lt $NUMBER ]]
  then
  {
    echo "It's higher than that, guess again:"
    GUESSES=$(( GUESSES + 1 ))
  }
  elif [[ $GUESS -gt $NUMBER ]]
  then
  {
    echo "It's lower than that, guess again:"
    GUESSES=$(( GUESSES + 1 ))
  }
  elif [[ $GUESS -eq $NUMBER ]]
  then
  {
    GUESSES=$(( GUESSES + 1 ))
    echo "You guessed it in $GUESSES tries. The secret number was $NUMBER. Nice job!"
  }
  fi
done

INCREMENT_GAMES_PLAYED_RESULT=$($PSQL "UPDATE user_info SET games_played = games_played + 1 WHERE username='$USERNAME'")

BEST_GAME=$($PSQL "SELECT best_game FROM user_info WHERE username='$USERNAME'")

if [[ -z $BEST_GAME ]]
then
  UPDATE_BEST_GAME_RESULT=$($PSQL "UPDATE user_info SET best_game=$GUESSES;")
else
{
  if [[ $GUESSES -lt $BEST_GAME ]]
  then
  {
    UPDATE_BEST_GAME_RESULT=$($PSQL "UPDATE user_info SET best_game=$GUESSES;")
  }
  fi
}
fi
