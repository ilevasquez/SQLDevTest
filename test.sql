insert into ivasquez.agg_dash_prediction_1_mv
(HOUR_24,SALES_PREDICTION,MARGIN_PREDICTION,
DASH_CATEGORY,DASH_NAME,IS_PARTNER,
IS_FLASH,PARENT_NAME,BUSINESS_MODEL)

select hour_24, 
sales + (sales * growth) as sales_prediction, 
0 as margin_prediction,
'Website' as dash_category, 
site as dash_name, 
case
 when partner <> -1 then 1
 else 0
end as is_partner,
case
 when business_model = 'odat' then 1
 else 0
end as is_flash,
'' as parent_name,
business_model
from
(select cast(sa.hour_24 as double precision ) + 1 as hour_24,
  round(sum(case
    when sa.line_type = 'item'
    then (1 - nvl(sa.demand_promo_pct , 0)) * sa.total_price
    else 0
  end ),0) as sales,
  avg_growth.growth as growth,
  avg_growth.site,
  ws.partner_id as partner,
  ws.business_model
from edw.site_actual sa,
edw.dim_website_storefront ws,

(select avg(diff) as growth, site from
(select round(((case when lag(sales) over (partition by site order by site) = 0 then 0
else sales/lag(sales) over (partition by site order by site) end )-1),1) as diff, 
site, date_id, sales
from
(
select round(sum(case
    when sa.line_type = 'item'
    then (1 - nvl(sa.demand_promo_pct , 0)) * sa.total_price
    else 0
  end ),0) as sales,
  sa.website_nm as site,
  sa.date_id
  from edw.site_actual sa
where (sa.date_id = to_char(trunc(sysdate)-364,'YYYYMMDD') 
or sa.date_id = to_char(trunc(sysdate),'YYYYMMDD'))
group by sa.website_nm, sa.date_id
order by sa.website_nm, sa.date_id)) group by site) avg_growth
where (sa.date_id = to_char(trunc(sysdate)-364,'YYYYMMDD')
and sa.hour_24 >= to_number(to_char(sysdate, 'HH24'))-1
and sa.website_nm = avg_growth.site
and ws.active = 1
and sa.website_storefront_id = ws.website_storefront_id)
group by cast(sa.hour_24 as double precision ) + 1, avg_growth.site, avg_growth.growth, sa.date_id, ws.partner_id, ws.business_model, ws.active);

commit;
