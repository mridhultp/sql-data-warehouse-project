select *
from bronze.crm_cust_info

--- checking the cst_id with duplicates

select cst_id, count(cst_id) countC
from silver.crm_cust_info
group by cst_id
having count(*) > 1 or cst_id is null

--- check unwanted spaces
--- expectation : 0 - No results

select cst_firstname
from silver.crm_cust_info
where cst_firstname != trim(cst_firstname)


--- data standardisation and consitancy

select distinct(cst_gndr)
from silver.crm_cust_info

select distinct(cst_marital_status)
from silver.crm_cust_info


select *
from
silver.crm_cust_info


