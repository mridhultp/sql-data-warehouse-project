

select 
      [cst_gndr]
      ,GEN as erp_Customer_gender
      , CASE
            WHEN ci.cst_gndr = 'NA'
                THEN COALESCE(ec.GEN, 'NA')
            ELSE ci.cst_gndr
        end as new_gen
     
from silver.crm_cust_info ci
left join silver.erp_cust_info ec 
on ci.cst_key = ec.CID
left join silver.erp_LOC_A101 ea
on ci.cst_key = ea.CID








select distinct
      [cst_gndr]
      ,GEN as erp_Customer_gender
      , CASE
            WHEN ci.cst_gndr = 'NA'
                THEN COALESCE(ec.GEN, 'NA')
            ELSE ci.cst_gndr
        end as new_gen
     
from silver.crm_cust_info ci
left join silver.erp_cust_info ec 
on ci.cst_key = ec.CID
left join silver.erp_LOC_A101 ea
on ci.cst_key = ea.CID










select * from
(

select 
      [cst_gndr]
      ,GEN as erp_Customer_gender
      , CASE
            WHEN ci.cst_gndr = 'NA'
                THEN COALESCE(ec.GEN, 'NA')
            ELSE ci.cst_gndr
        end as new_gen
     
from silver.crm_cust_info ci
left join silver.erp_cust_info ec 
on ci.cst_key = ec.CID
left join silver.erp_LOC_A101 ea
on ci.cst_key = ea.CID
)t
where new_gen is null

  