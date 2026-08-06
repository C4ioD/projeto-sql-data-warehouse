
CREATE VIEW gold.fact_sales as
SELECT 
      [sls_ord_num] as order_number
      ,pr.product_key
      ,cu.customer_key
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,[sls_order_dt]
      ,[sls_ship_dt]
      ,[sls_due_dt]
      ,[sls_sales]
      ,[sls_quantity]
      ,[sls_price]
      ,[dwh_create_date]
  FROM [DataWarehouse].[silver].[crm_sales_details] sd
  left join [gold].[dim_products] pr
    on sd.sls_prd_key = pr.product_number
  left join gold.dim_customers cu
    on sd.sls_cust_id = cu.customer_id
