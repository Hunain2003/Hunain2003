#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # winner
  PLAYER_ONE = $($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
  # opponent
  PLAYER_TWO = $($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
  
  # inserting teams
  if [[ -z $PLAYER_ONE ]]
  then
    if [[ $WINNER != 'winner' ]]
    then
     TEAM_ENTRY=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
    fi
  fi

  if [[ -z $PLAYER_TWO ]]
  then
    if [[ $OPPONENT != 'opponent' ]]
    then
      TEAM_ENTRY=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    fi
  fi

done
# inserting games
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

  GAME_ENTRY=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', '$ID_WINNER', '$ID_OPPONENT', '$WINNER_GOALS', '$OPPONENT_GOALS');")
done

