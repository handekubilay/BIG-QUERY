SELECT
    CAST(se.stage_index AS INT64) AS stage_index,
    COUNTIF(se.event_type = 'stage_start') AS starts,
    COUNTIF(se.event_type = 'stage_end') AS ends,
    COUNT(DISTINCT se.user_id) AS users,
    COUNT(DISTINCT IF(se.event_type = 'stage_start', se.user_id, NULL)) AS start_users,
    COUNT(DISTINCT IF(se.event_type = 'stage_end', se.user_id, NULL)) AS end_users,
    COUNT(DISTINCT IF(se.event_type = 'stage_end' AND se.result = 'win', se.user_id, NULL)) AS wins,
    AVG(COALESCE(CAST(sh.health_at_start AS FLOAT64) - CAST(sh.health_at_end AS FLOAT64), 0)) AS avg_health_lost
FROM game-analysis-01.project_game_v2.stage_events AS se
LEFT JOIN (
    SELECT
        se.user_id,
        CAST(se.stage_index AS INT64) AS stage_index,
        CAST(se.character_health AS FLOAT64) AS health_at_start,
        LEAD(CAST(se.character_health AS FLOAT64)) OVER (PARTITION BY se.user_id ORDER BY se.stage_index, se.event_date) AS health_at_end
    FROM game-analysis-01.project_game_v2.stage_events AS se
    WHERE se.event_type = 'stage_start'
) AS sh ON se.user_id = sh.user_id AND CAST(se.stage_index AS INT64) = CAST(sh.stage_index AS INT64)
JOIN game-analysis-01.project_game_v2.user_states AS us ON se.user_id = us.user_id
WHERE se.event_type LIKE 'stage%'
  AND us.is_cheater_from_client = '0'
GROUP BY se.stage_index
ORDER BY se.stage_index;