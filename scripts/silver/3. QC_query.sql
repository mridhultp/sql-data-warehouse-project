
---- Check for Invalid Dates
SELECT
NULLIF (sls_due_dt, 0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101

--- check for invalid orders dates
select * 
from bronze.crm_sales_details
where sls_order_dt > sls_ship_dt or sls_order_dt> sls_due_dt

--- check data consistancy :  between sales, quantity, and price
--- sales = quantity * price 
--- values must not  be null , zero , or negative

select distinct
sls_sales,
sls_quantity,
sls_price
from 
bronze.crm_sales_details
where sls_sales != sls_price*sls_quantity
or sls_sales is null or sls_price is null or sls_quantity is null
or sls_sales <= 0 or sls_price <= 0 or sls_quantity <= 0 
order by sls_sales, sls_quantity,sls_price

