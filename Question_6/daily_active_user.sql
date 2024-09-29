SELECT 
    se.event_date, 
    COUNT(DISTINCT se.user_id) AS daily_active_users
FROM 
    game-analysis-01.project_game_v2.stage_events AS se
JOIN 
    game-analysis-01.project_game_v2.user_states AS us ON se.user_id = us.user_id
WHERE 
    us.is_cheater_from_client = '0'
    AND se.event_type IN ('stage_start','tutorial_progress')
GROUP BY 
    se.event_date
ORDER BY 
    se.event_date