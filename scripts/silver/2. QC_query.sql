
select *
from silver.crm_prd_info

select prd_id,count(*) as c_count
from silver.crm_prd_info
group by prd_id
having count(*) > 1 or prd_id is null

-- check for unwanted spaces
-- expectation : No result or zero line items

select prd_nm
from  silver.crm_prd_info
where prd_nm != trim(prd_nm)


-- check for NULL and Negatice valuse
-- expectation : No result or zero line items

select prd_cost
from  silver.crm_prd_info
where prd_cost <0 or prd_cost is null


--------------


select distinct(prd_line)
from  silver.crm_prd_info
where prd_nm != trim(prd_nm)

-----------------------
--check the invalid date order


select count(*)
from
(
select *
from  silver.crm_prd_info
where prd_start_dt > prd_end_dt)Y
