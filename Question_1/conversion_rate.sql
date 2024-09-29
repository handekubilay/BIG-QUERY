WITH active_users AS (
  -- Her gün oyuna giren toplam hilesiz oyuncu sayısı
  SELECT ud.event_date,
         COUNT(DISTINCT CAST(ud.user_id AS INT64))AS total_active_users
  FROM `game-analysis-01.project_game_v2.users_daily` ud
  JOIN `game-analysis-01.project_game_v2.user_states` us ON  CAST(ud.user_id AS INT64) = us.user_id
  WHERE ud.event_date BETWEEN DATE('2023-10-01') AND DATE('2023-11-30')
        AND us.is_cheater_from_client = '0' -- Hile yapmayan oyuncuları
  GROUP BY ud.event_date
),
purchasing_users AS (
  -- Her gün satın alma yapan hilesiz oyuncu sayısı
  SELECT ud.event_date,
         COUNT(DISTINCT CAST(ud.user_id AS INT64)) AS total_purchasing_users
  FROM `game-analysis-01.project_game_v2.users_daily` ud
  JOIN `game-analysis-01.project_game_v2.user_states` us
  ON CAST(ud.user_id AS INT64) = us.user_id 
   WHERE ud.event_date BETWEEN DATE('2023-10-01') AND DATE('2023-11-30')
        AND ud.purchases > 0 -- Satın alma yapan oyuncular
        AND us.is_cheater_from_client = '0' -- Hile yapmayan oyuncular
  GROUP BY ud.event_date
)
-- Conversion rate
SELECT a.event_date,
       a.total_active_users,
       p.total_purchasing_users,
       IFNULL(p.total_purchasing_users / a.total_active_users, 0) AS conversion_rate
FROM active_users a
LEFT JOIN purchasing_users p
ON a.event_date = p.event_date
ORDER BY a.event_date;