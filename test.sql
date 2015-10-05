with t as (select 'AGG_MERCH_ASAP_REPORT' table_name from dual union all
           select 'AGG_SHIP_BY_SKU_FW' from dual union all
           select 'AGG_SHIP_BY_SITE_MV' from dual union all
           select 'AGG_SHIP_BY_SKU_MV' from dual union all
           select 'AGG_VISIT_PDP2_MV' from dual union all
           select 'AGG_DIM_STYLE' from dual)
select t.table_name, 
round(100*(sum(snq.time_sec)/(select sum(snq.time_sec) 
    from obiprod_biplatform.s_nq_db_acct snq where trunc(snq.start_dt) > trunc(sysdate)-30)),2) as use_percentage,
count(snq.id) as times_used
from t join obiprod_biplatform.s_nq_db_acct snq
on instr(snq.query_blob, t.table_name) <> 0 
where trunc(snq.start_dt) > trunc(sysdate)-30
group by t.table_name
order by t.table_name;
