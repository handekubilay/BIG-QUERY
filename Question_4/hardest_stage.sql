with t1 as (
select cast(stage_index as INT64) as stage_index,
countif(event_type='stage_start') as starts,
countif(event_type='stage_end') as ends,
count(distinct user_id) as users,
count(distinct if(event_type = 'stage_start', user_id, null)) as start_users,
count(distinct if(event_type = 'stage_end', user_id, null)) as end_users,
count(distinct if(event_type = 'stage_end'and result = 'win', user_id, null)) as wins,
from game-analysis-01.project_game_v2.stage_events
where event_type like 'stage%'
group by 1
)
select *,
1-end_users/start_users as nonfinishing_rate,
end_users/start_users as end_rate_users,
wins/users as win_rate,
1- lead(users) over (order by cast(stage_index as INT64))/users as churn_rate
from t1 
order by 1