
----trying to match p.key with other table and find unmatched keys and clean it.
select replace(cid,'-',''),
cntry
from bronze.erp_LOC_A101
where replace(cid,'-','')  not in 
(select cst_key from silver.crm_cust_info)

---- Data Standardisation and consistancy

select distinct cntry
from bronze.erp_LOC_A101


SELECT
distinct 
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101

select  *
from silver.erp_LOC_A101


