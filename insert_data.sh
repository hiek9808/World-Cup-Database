#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

# Insert games.csv into table teams, games
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #if exist team
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER' ")
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT' ")

    if [[ -z $TEAM_WINNER_ID ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $INSERT_TEAM_RESULT
    fi
    if [[ -z $TEAM_OPPONENT_ID ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo $INSERT_TEAM_RESULT
    fi

    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER' ")
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT' ")

    #insert games
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_WINNER_ID, $TEAM_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo $INSERT_GAME_RESULT

  fi
done


