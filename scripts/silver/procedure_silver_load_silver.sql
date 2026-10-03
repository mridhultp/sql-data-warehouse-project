/*

Stored Procedure:

Load Silver Layer (Bronze Silver)

Script Purpose:

This stored procedure performs the ETL (Extract, Transform, Load) process to populate the 'silver schema tables from the 'bronze schema.

Actions Performed:

-----Truncates Silver tables.
-----Inserts transformed and cleansed data from Bronze into Silver tables.

Parameters:

None.
This stored procedure does not accept any parameters or return any values.

Usage Example:

	EXEC Silver.load_silver;

*/



create or alter procedure silver.load_silver as
begin
	declare @start_time datetime,@end_time datetime,@batch_start_time datetime, @batch_end_time datetime
	
	begin try
		set @batch_start_time = GETDATE()

		print '-------------------------------------------------------------'
		print 'Loading silver Layer'
		Print '-------------------------------------------------------------'

		print '-------------------------------------------------------------'
		print 'Loading CRM table'
		Print '-------------------------------------------------------------'

		
		---- Loading silver.crm_cust_info-----------------------------------

		set @start_time = GETDATE();

		Print '>>> truncating table silver.crm_cust_info';

		truncate table silver.crm_cust_info;

		insert into silver.crm_cust_info (
			cst_id,
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date)

		select
		cst_id,
		cst_key, 
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) as cst_lastname,
		case when cst_marital_status = 'S' then 'Single'
			 when cst_marital_status = 'M' then 'Married'
			 else 'NA'
		end cst_marital_status,
		case when cst_gndr = 'F' then 'Female'
			 when cst_gndr = 'M' then 'Male'
			 else 'NA'
		end cst_gndr,
		cst_create_date

		from (
		select
		*,
		row_number() over(partition by cst_id order by cst_create_date desc) as rn
		from bronze.crm_cust_info)t
		where rn =1

		set @end_time = getdate()
		print '>>> Load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'second'

		print'>>=================='


		---- Loading silver.crm_prd_info----------------------------------------------------------------

		set @start_time = GETDATE();

		Print '>>> truncating table silver.crm_prd_info';

		truncate table silver.crm_prd_info

		insert into silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt

		)
		select 
			prd_id,
			replace(substring(prd_key,1,5),'-','_') as cat_id,
			substring(prd_key,7,len(prd_key)) as prd_key,
			prd_nm,
			isnull(prd_cost,0) as prd_cost,
			case when upper(trim(prd_line)) = 'M' then 'Mountain'
				 when upper(trim(prd_line)) = 'M' then 'Road'
				 when upper(trim(prd_line)) = 'R' then 'Other Sales'
				 when upper(trim(prd_line)) = 'S' then 'Mountain'
				 when upper(trim(prd_line)) = 'T' then 'Touring'
				 else 'NA'
			end as prd_line,
			cast(prd_start_dt as date) as prd_start_dt,
			cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt)-1 as date) as prd_end_dt 
		from bronze.crm_prd_info

		set @end_time = getdate()
		print '>>> Load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'second'

		print'>>=================='


		---- Loading silver.crm_sales_details-----------------------------------------------------------

		set @start_time = GETDATE();

		Print '>>> truncating table silver.crm_sales_details';

		truncate table silver.crm_sales_details

		insert into silver.crm_sales_details (	
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,
			sls_price
		)

		select 
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,

			case when sls_order_dt = 0 or len(sls_order_dt) !=8 then Null
				 else cast(cast(sls_order_dt as varchar)as date)
			end as sls_order_dt,

			case when sls_ship_dt  = 0 or len(sls_ship_dt) !=8 then Null
				 else cast(cast(sls_ship_dt as varchar)as date)
			end as sls_ship_dt,

				case when sls_due_dt  = 0 or len(sls_due_dt) !=8 then Null
				 else cast(cast(sls_due_dt as varchar)as date)
			end as sls_due_dt,

			CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
				THEN sls_quantity*ABS(sls_price)
				ELSE sls_sales
			END AS sls_sales,
				sls_quantity,
			CASE WHEN sls_price iS NULL OR sls_price <= 0
					THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price
			END AS sls_price
		from

		bronze.crm_sales_details

		set @end_time = getdate()
		print '>>> Load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'second'

		print'>>=================='


		---- Loading silver.silver.erp_cust_info--------------------------------------------------------

		set @start_time = GETDATE();

		Print '>>> truncating table silver.erp_cust_info';

		truncate table silver.erp_cust_info

		insert into silver.erp_cust_info (
				cid,
				bdate,
				gen
			)
			select 
		case when cid like 'NAS%' then substring(cid,4,len(cid))
			else cid
		end cid,

		case when bdate > getdate() then null
			else bdate
		end as bdate,

		case when upper(trim(gen)) in ('F','Female') then 'Female'
			 when upper(trim(gen)) in ('M','Male') then 'Male'
			 else 'Na'
		end as gen

		from
		bronze.erp_cust_info

		set @end_time = getdate()
		print '>>> Load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'second'

		print'>>=================='


		---- Loading silver.silver.erp_LOC_A101---------------------------------------------------------

		set @start_time = GETDATE();

		Print '>>> truncating table silver.erp_LOC_A101';

		truncate table silver.erp_LOC_A101

		insert into silver.erp_LOC_A101 (
		cid,
		cntry )

		SELECT
		REPLACE (cid, '', '') cid,
		CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
		END AS cntry
		FROM bronze.erp_loc_a101

		set @end_time = getdate()
		print '>>> Load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'second'

		print'>>=================='


		---- Loading silver.erp_PX_CAT_G1V2------------------------------------------------------------

		set @start_time = GETDATE();

		Print '>>> truncating table silver.erp_PX_CAT_G1V2';

		truncate table silver.erp_PX_CAT_G1V2

		insert into silver.erp_PX_CAT_G1V2
		(
		id,
		cat,
		subcat,
		maintenance)

		select
		id,
		cat,
		subcat,
		maintenance
		from 
		bronze.erp_PX_CAT_G1V2

		set @end_time = getdate()
		print '>>> Load duration: ' + cast(datediff(second,@start_time,@end_time) as nvarchar) + 'second'

		print'>>=================='

		set @batch_end_time = GETDATE()

		print'>>------------------------------------------------------------------------------------'

		Print 'Loading..... Silver layer completed'

		print '>>> Total duration: ' + cast(datediff(second,@batch_start_time,@batch_end_time)as nvarchar) +'second'

		print'>>------------------------------------------------------------------------------------'
		
	end try
	begin catch
		print '------------------------------------------------'
		print 'Error ocured during laoding silver layer'
		print 'error message' + error_message();
		print 'error message' + cast(error_number() as nvarchar)
		print 'error message' + cast(error_state() as nvarchar)
		print '------------------------------------------------'
	end catch
End



