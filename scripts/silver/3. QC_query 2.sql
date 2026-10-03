CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS (sls_price)
	THEN sls_quantity ABS (sls_price)
	ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE WHEN sls price iS NULL OR sls_price <= 0
		THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price
END AS sls_price

select * from
silver.crm_sales_details
where sls_quantity >1