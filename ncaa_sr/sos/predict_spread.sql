begin;

set timezone to 'America/Los_Angeles';

select
g.game_date::date as date,
g.home_id as home,
g.visitor_id as opp,
(exp(i.estimate)*y.exp_factor*h.offensive*o.exp_factor*v.defensive-
exp(i.estimate)*y.exp_factor*v.offensive*h.defensive*d.exp_factor)::numeric(4,1) as spread
from ncaa_sr.games g
join ncaa_sr._schedule_factors v
  on (v.year,v.team_id)=(g.year,g.visitor_id)
join ncaa_sr._schedule_factors h
  on (h.year,h.team_id)=(g.year,g.home_id)
join ncaa_sr._factors o
  on (o.parameter,o.level)=('field','offense_home')
join ncaa_sr._factors d
  on (d.parameter,d.level)=('field','defense_home')
join ncaa_sr._factors y
  on (y.parameter,y.level)=('year',g.year::text)
join ncaa_sr._basic_factors i
  on (i.factor)=('(Intercept)')
where g.game_date::date = current_date
order by g.game_date::date,g.home_id asc;

commit;
