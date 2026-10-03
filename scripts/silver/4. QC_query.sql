
--- Check  if primary key matches with other table
select 
cid,
case when cid like 'NAS%' then substring(cid,4,len(cid))
	else cid
end cid,
bdate,
gen
from
bronze.erp_cust_info
where case when cid like 'NAS%' then substring(cid,4,len(cid))
	else cid
end not in (select distinct cst_key from silver.crm_cust_info)


--- DOB checking

select distinct
bdate
from bronze.erp_cust_info
where bdate < '1926-01-01' or bdate> getdate()


--- data standardization & consistancy
select distinct
gen
from bronze.erp_cust_info

---- Data quelity 

select distinct
*
from bronze.erp_cust_info