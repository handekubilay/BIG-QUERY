WITH quit_counts AS (
  SELECT 
    CAST(stage_index AS INT64) AS stage_index,
    CAST(stage_progress AS INT64) AS stage_progress,
    COUNT(*) AS quit_count
  FROM game-analysis-01.project_game_v2.stage_events
  WHERE 
    result = 'quit'
    AND event_date BETWEEN '2023-10-01' AND '2023-11-30'
  GROUP BY 
    stage_index, stage_progress
),
max_quit_per_stage AS (
  SELECT
    stage_index,
    MAX(quit_count) AS max_quit_count
  FROM 
    quit_counts
  GROUP BY 
    stage_index
)
SELECT 
  qc.stage_index,
  qc.stage_progress,
  mq.max_quit_count
FROM 
  quit_counts qc
JOIN 
  max_quit_per_stage mq
ON 
  qc.stage_index = mq.stage_index
  AND qc.quit_count = mq.max_quit_count
ORDER BY 
  qc.stage_index ASC, qc.stage_progress ASC;