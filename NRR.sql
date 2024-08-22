WITH MatchStats AS (
  SELECT 
    m.match_id, 
    t1.team_name AS team1, 
    t1.teamid AS team1_id, 
    m.team1_runs / m.team1_overs AS team1_run_rate,
    t2.team_name AS team2, 
    t2.teamid AS team2_id, 
    m.team2_runs / m.team2_overs AS team2_run_rate
  FROM matches m
  JOIN teams t1 ON m.team1_id = t1.teamid
  JOIN teams t2 ON m.team2_id = t2.teamid
),
TeamStats AS (
  SELECT
    teamid,
    team_name,
    AVG(CASE WHEN teamid = team1_id THEN team1_run_rate ELSE team2_run_rate END) AS avg_run_rate,
    AVG(CASE WHEN teamid = team2_id THEN team1_run_rate ELSE team2_run_rate END) AS avg_runs_conceded
  FROM MatchStats
  GROUP BY teamid, team_name
)
SELECT
  team_name,
  avg_run_rate - avg_runs_conceded AS nrr
FROM TeamStats;




Conversation with Gemini

A sample SQL query for Team NRR calculation 


Show drafts

Calculating Net Run Rate (NRR) in SQL
Understanding NRR:
Net Run Rate (NRR) in cricket is a statistical measure that determines a team's overall run rate in a tournament. It is calculated as the difference between a team's average runs per over scored and the average runs per over conceded.

Assumptions:

We have a table named matches with columns: match_id, team1, team2, team1_runs, team1_overs, team2_runs, team2_overs.
team1_overs and team2_overs are formatted as decimals (e.g., 10.2 for 10.2 overs).
SQL Query:

SQL
WITH MatchStats AS (
  SELECT 
    match_id, 
    team1, 
    team1_runs / team1_overs AS team1_run_rate,
    team2, 
    team2_runs / team2_overs AS team2_run_rate
  FROM matches
),
TeamStats AS (
  SELECT
    team,
    AVG(CASE WHEN team = team1 THEN team1_run_rate ELSE team2_run_rate END) AS avg_run_rate,
    AVG(CASE WHEN team = team2 THEN team1_run_rate ELSE team2_run_rate END) AS avg_runs_conceded
  FROM MatchStats
  GROUP BY team
)
SELECT
  team,
  avg_run_rate - avg_runs_conceded AS nrr
FROM TeamStats;
Use code with caution.

Explanation:

Common Table Expression (CTE) MatchStats:

Calculates the run rate for each team in each match.
CTE TeamStats:

Aggregates the data to calculate the average run rate and average runs conceded for each team.
Final SELECT:

Subtracts the average runs conceded from the average run rate to get the NRR.
Customization:

If you have a table for innings, you can adjust the query to calculate NRR based on individual innings.
For more complex scenarios like rain-affected matches or bonus points, additional calculations might be required.
By running this query, you will get a list of teams with their corresponding Net Run Rates.







Team1 and Team2 not different columns but teams are differentiated in matches table with teamid


Show drafts

Revised SQL Query for NRR Calculation with Team IDs
Understanding the Change:
If team1 and team2 are not distinct columns but are differentiated by a teamid column, we'll need to adjust the query to reference the teamid and join the matches table with a teams table (assuming you have one) to get the team names.

Assumptions:

We have a teams table with columns: teamid and team_name.
The matches table still has columns: match_id, team1_id, team2_id, team1_runs, team1_overs, team2_runs, team2_overs.
SQL Query:

SQL
WITH MatchStats AS (
  SELECT 
    m.match_id, 
    t1.team_name AS team1, 
    t1.teamid AS team1_id, 
    m.team1_runs / m.team1_overs AS team1_run_rate,
    t2.team_name AS team2, 
    t2.teamid AS team2_id, 
    m.team2_runs / m.team2_overs AS team2_run_rate
  FROM matches m
  JOIN teams t1 ON m.team1_id = t1.teamid
  JOIN teams t2 ON m.team2_id = t2.teamid
),
TeamStats AS (
  SELECT
    teamid,
    team_name,
    AVG(CASE WHEN teamid = team1_id THEN team1_run_rate ELSE team2_run_rate END) AS avg_run_rate,
    AVG(CASE WHEN teamid = team2_id THEN team1_run_rate ELSE team2_run_rate END) AS avg_runs_conceded
  FROM MatchStats
  GROUP BY teamid, team_name
)
SELECT
  team_name,
  avg_run_rate - avg_runs_conceded AS nrr
FROM TeamStats;
Use code with caution.

Explanation:

Join with teams table: The matches table is joined with the teams table twice to get the team names for team1_id and team2_id.
CTE MatchStats: The team_name is now included in the CTE along with the teamid.
CTE TeamStats: The grouping and aggregation are done based on both teamid and team_name.
Final SELECT: The final result includes the team_name and the calculated NRR.
This revised query will accurately calculate NRR based on the team IDs and provide the team names in the output.







Provide table structures for above solution


Show drafts

Table Structures
matches table:

Column Name	Data Type	Description
match_id	INT	Unique identifier for the match
team1_id	INT	ID of the first team
team2_id	INT	ID of the second team
team1_runs	INT	Total runs scored by team 1
team1_overs	DECIMAL(5,2)	Overs bowled by team 1
team2_runs	INT	Total runs scored by team 2
team2_overs	DECIMAL(5,2)	Overs bowled by team 2

  teams table:

Column Name	Data Type	Description
teamid	INT	Unique identifier for the team
team_name	VARCHAR(50)	Name of the team
