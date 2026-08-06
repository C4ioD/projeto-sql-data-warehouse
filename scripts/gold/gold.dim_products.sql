create view gold.dim_products as
SELECT
       ROW_NUMBER() over(order by pn.[prd_start_dt],pn.prd_key) as product_key
       ,[prd_id] as product_id
       ,[prd_key] as product_number
       ,pn.[cat_id] as category_id 
       ,[prd_nm] as product_name
       ,pc.cat as category
       ,pc.subcat as subcategory
       ,[prd_cost] as cost
       ,[prd_line] as product_line
       ,[prd_start_dt] as start_date
  FROM [DataWarehouse].[silver].[crm_prd_info] pn
  LEFT JOIN SILVER.erp_px_cat_g1v2 pc 
    ON pn.cat_id = pc.id
  where prd_end_dt is null
  
