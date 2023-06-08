#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# clean table
$PSQL "TRUNCATE TABLE games, teams"

# inser data
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # query winner is in the table
    W_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    if [[ -z $W_TEAM_ID ]]
    then
      # inser team
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      W_TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi

    # query opponent is in the table
    O_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    if [[ -z $O_TEAM_ID ]]
    then
      # inser team
      INSERT_TEAM_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT')")
      O_TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    fi

    # insert to game
    INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $W_TEAM_ID, $O_TEAM_ID,$WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done