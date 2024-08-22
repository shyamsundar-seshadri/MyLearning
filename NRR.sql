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
