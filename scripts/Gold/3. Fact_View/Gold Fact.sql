
create view gold.fact_sales as 

SELECT sd.sls_ord_num as order_number,
  --- ,sd.sls_prd_key,
      gp.product_key,
---   ,sd.sls_cust_id,
      gc.customer_key
      ,sd.sls_order_dt as order_date
      ,sd.sls_ship_dt as shipping_date
      ,sd.sls_due_dt as due_date
      ,sd.sls_price as unit_price
      ,sd.sls_quantity as quantity
      ,sd.sls_sales as sales_amount
  FROM silver.crm_sales_details as sd
  left join gold.dim_products as gp
  on sd.sls_prd_key = gp.prodcut_number

  left join gold.dim_customer as gc
  on sd.sls_cust_id = gc.customer_id

