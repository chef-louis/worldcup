#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
TEAMS=()

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPP_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    if [[ ! " ${TEAMS[*]} " =~ " ${WINNER} " ]]
    then
      echo $($PSQL "INSERT INTO teams (name) VALUES ('$WINNER')")
      TEAMS+=($WINNER)
    fi

    if [[ ! " ${TEAMS[*]} " =~ " ${OPPONENT} " ]]
    then
      echo $($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT')")
      TEAMS+=($OPPONENT)
    fi
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    echo $($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPP_GOALS)")
  fi
done
