select prd_key ,count(*) as counta

from 
(

SELECT  prd_id
      ,cat_id
      ,prd_key
      ,prd_nm
      ,prd_cost
      ,prd_line
      ,prd_start_dt
      ,pc.cat
      ,pc.SUBCAT
      ,pc.MAINTENANCE
      
  FROM silver.crm_prd_info as pn
  left join silver.erp_PX_CAT_G1V2 as pc
  on pn.cat_id = pc.ID
    where prd_end_dt  is null --- filter out all the historical data
  ) S
  group by prd_key
  having count(*)>1
