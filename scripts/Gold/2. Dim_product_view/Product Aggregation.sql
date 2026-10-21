
create view gold.dim_products as

SELECT 
       row_number() over(order by pn.prd_start_dt,pn.prd_key) as product_key,
       pn.prd_id as product_id
      ,pn.prd_key as prodcut_number
      ,pn.prd_nm as product_name
      ,pn.cat_id as category_id
      ,pc.cat as category
      ,pc.SUBCAT as sub_category
      ,pc.MAINTENANCE
      ,pn.prd_cost as cost
      ,pn.prd_line as product_line
      ,pn.prd_start_dt
      
      FROM silver.crm_prd_info as pn
  left join silver.erp_PX_CAT_G1V2 as pc
  on pn.cat_id = pc.ID
    where prd_end_dt  is null --- filter out all the historical data
  