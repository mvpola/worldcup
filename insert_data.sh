#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERS_GOAL OPPONENT_GOAL
do
  if [[ $WINNER != 'winner' ]]
  then  
    # get winner id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    # if not found winner id
    if [[ -z $WINNER_ID ]]
    then
      # insert winner name
      INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # check if inset is valid
      if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams $WINNER
      fi
    # get new winner ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    # id not found opponent id
    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponent name
      INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      # check if insert is valid
      if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
      then
        echo Inserted into teams $OPPONENT
      fi
    # get new opponent ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

  # insert data into games
  GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNERS_GOAL, $OPPONENT_GOAL)")
  if [[ $GAMES == "INSERT 0 1" ]]
  then
    echo Inserted into games
  fi
  fi
done
