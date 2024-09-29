WITH non_cheater_users AS (
  SELECT user_id
  FROM game-analysis-01.project_game_v2.user_states
  WHERE user_states.is_cheater_from_client = '0'
)
SELECT 
  cc.reason, 
  cc.change_type, 
  SUM(CAST(cc.currency_change_amount AS FLOAT64)) AS total_gems_earned
FROM game-analysis-01.project_game_v2.currency_changes cc
INNER JOIN non_cheater_users nc ON cast(cc.user_id as int64) = nc.user_id
WHERE cc.currency_type = 'Gem' 
AND CAST(cc.currency_change_amount AS FLOAT64) > 0
AND cc.change_type LIKE '%Gain%' 
GROUP BY cc.reason, cc.change_type
ORDER BY total_gems_earned DESC;