with t1 as (
    SELECT
    user_id,
    max(tutorial_id) as tutorial_id
    FROM game-analysis-01.project_game_v2.stage_events
    where event_type ='tutorial_progress'
    and tutorial_id is not null
    group by 1
),
t2 as (
    select 
    tutorial_id,
    COUNT(*) as cnt_tut_id,
    SUM(COUNT(*)) over (order by tutorial_id desc) as total_users
    from t1 
    group by tutorial_id
    order by tutorial_id
)
select *,
    cnt_tut_id / total_users as churn_rate,
    max(total_users) over () as total_users_max,
    total_users/max(total_users) over () as survival_rate
from t2
order by tutorial_id;