#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "CREATE TABLE IF NOT EXISTS GTMP (year int,round varchar(100),winner varchar(100),opponent varchar(100),winner_goals int,opponent_goals int);"
$PSQL "TRUNCATE TABLE gtmp, games, teams"
#$PSQL "COPY gtmp(year,round,winner,opponent,winner_goals,opponent_goals) FROM '/home/codeally/project/games.csv' DELIMETER ',' CSV HEADER;"
$PSQL "\COPY gtmp FROM '/home/codeally/project/games.csv' DELIMITER ',' CSV HEADER"
$PSQL "insert into teams(name)  select distinct winner from gtmp union select distinct opponent from gtmp;"
$PSQL "insert into games(year,round,winner_id, opponent_id, winner_goals, opponent_goals) select year, round,  w.team_id as winner_id, o.team_id as opponent_id,winner_goals, opponent_goals  from gtmp t left join teams w on t.winner=w.name left join teams o on t.opponent=o.name; "
