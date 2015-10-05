with t as (select 'AGG_MERCH_ASAP_REPORT' table_name from dual union all
           select 'AGG_SHIP_BY_SKU_FW' from dual union all
           select 'AGG_VISIT_BY_SITE_MV' from dual union all
           select 'AGG_VISIT_BY_STYLE_MV' from dual union all
           select 'AGG_DEMAND_BY_CHANNEL_MV' from dual union all
           select 'AGG_DEMAND_BY_ORDERLINE_MV' from dual union all
           select 'AGG_DEMAND_BY_SITE_MV' from dual union all
           select 'AGG_DEMAND_MV' from dual union all
           select 'AGG_DIM_BRAND_MV' from dual union all
           select 'AGG_DIM_BRAND_TYPE_MV' from dual union all
           select 'AGG_DIM_FISCAL_WK' from dual union all
           select 'AGG_DIM_MD_MV' from dual union all
           select 'AGG_DIM_MG' from dual union all
           select 'AGG_DIM_MG_MV' from dual union all
           select 'AGG_DIM_PO_CATEGORY' from dual union all
           select 'AGG_DIM_SHIPPER' from dual union all
           select 'AGG_INV_ASAP_BOP_MV' from dual union all
           select 'AGG_INV_CANADA_BOP_MV' from dual union all
           select 'AGG_INV_ONHAND_BOP_MV' from dual union all
           select 'AGG_INV_ONHAND_BY_PO_SKU_MV' from dual union all
           select 'AGG_INV_PRESEASON_BOP_MV' from dual union all
           select 'AGG_INV_UTAH_BOP_MV' from dual union all
           select 'AGG_INV_VIRGINIA_BOP_MV' from dual union all
           select 'AGG_MARKETING_COST_MV' from dual union all
           select 'AGG_NETSALES_BY_SITE_MV' from dual union all
           select 'AGG_NETSALES_BY_SKU_MV' from dual union all
           select 'AGG_SHIP_BY_ID_MV' from dual union all
           select 'AGG_SHIP_BY_ID_MV_TEST' from dual union all
           select 'AGG_SHIP_BY_ORDERLINE_MV' from dual union all
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
