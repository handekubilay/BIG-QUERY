WITH day5_players AS (
    SELECT users.user_id
    FROM game-analysis-01.project_game_v2.users
    JOIN game-analysis-01.project_game_v2.users_daily ON users.user_id = CAST(users_daily.user_id AS INT64)
    WHERE DATE_DIFF(users_daily.event_date, users.install_date, DAY) = 5
)

SELECT se.stage_index, COUNT(DISTINCT se.user_id) AS player_count
FROM game-analysis-01.project_game_v2.stage_events AS se
JOIN day5_players ON CAST(se.user_id AS INT64) = day5_players.user_id
JOIN game-analysis-01.project_game_v2.user_states AS us ON se.user_id = us.user_id
WHERE us.is_cheater_from_client = '0'
GROUP BY se.stage_index
ORDER BY player_count DESC;