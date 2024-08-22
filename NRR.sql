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
