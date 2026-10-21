
select * from
gold.fact_sales f
left join gold.dim_customer c
on c.customer_key = f.customer_key
where c.customer_key is null

select * from
gold.fact_sales f
left join gold.dim_products c
on c.product_key = f.product_key
where c.product_key is null