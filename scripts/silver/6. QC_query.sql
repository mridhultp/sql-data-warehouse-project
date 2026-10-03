select *
from 
bronze.erp_PX_CAT_G1V2


--- checking unwanted spaces

select *
from 
bronze.erp_PX_CAT_G1V2
where cat != trim(cat) or subcat != trim(subcat) or maintenance != trim(maintenance)


--- Data standardisation

select distinct cat
from 
bronze.erp_PX_CAT_G1V2


select distinct subcat
from 
bronze.erp_PX_CAT_G1V2

select distinct maintenance
from 
bronze.erp_PX_CAT_G1V2

--- check data

select *
from 
silver.erp_PX_CAT_G1V2



