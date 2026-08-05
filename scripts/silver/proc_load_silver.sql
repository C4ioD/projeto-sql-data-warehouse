/*
===============================================================================
Procedure Armazenada: Carregar Camada Silver (Bronze -> Silver)
===============================================================================
Propósito do Script:
    Esta procedure armazenada realiza o processo ETL (Extrair, Transformar, Carregar) 
    para povoar as tabelas do esquema 'silver' a partir do esquema 'bronze'.
	Ações Realizadas:
		- Trunca (esvazia) as tabelas Silver.
		- Insere dados transformados e limpos da camada Bronze nas tabelas Silver.
		
Parâmetros:
    Nenhum. 
	  Esta procedure armazenada não aceita parâmetros nem retorna valores.

Exemplo de Uso:
    EXEC silver.load_silver;
===============================================================================
*/


CREATE  OR ALTER  PROCEDURE silver.load_silver as   
  
BEGIN  
 DECLARE @start_date DATETIME, @end_date DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;  
 BEGIN TRY  
    
  SET @batch_start_time = GETDATE()  
  
  PRINT '================================';  
  PRINT 'Loading Silver Layer';  
  PRINT '================================';  
  
  PRINT '--------------------------------';  
  PRINT 'Loading CRM Tables';  
  PRINT '--------------------------------';  
  
  
  
  
  PRINT '>> Trucating Table: silver.crm_cust_info';  
  TRUNCATE TABLE [silver].[crm_cust_info];  
  PRINT '>> Insert Data Into: silver.crm_cust_info';  
  INSERT INTO [silver].[crm_cust_info](  
   cst_id,  
   cst_key,  
   cst_firstname,  
   cst_lastname,  
   cst_marital_status,  
   cst_gndr,  
   cst_create_date  
  )  
  SELECT  
   cst_id,  
   cst_key,  
   TRIM(cst_firstname) AS cst_firstname,  
   TRIM(cst_lastname) AS cst_lastname ,  
   CASE   
    WHEN UPPER(TRIM(cst_marital_status)) = 'M' then 'Married'  
    WHEN UPPER(TRIM(cst_marital_status)) = 'S' then 'Single'  
    ELSE 'n/a'   
   END AS cst_marital_statu,  
  
   CASE   
    WHEN UPPER(TRIM(cst_gndr)) = 'M' then 'Male'  
    WHEN UPPER(TRIM(cst_gndr)) = 'F' then 'Female'  
    ELSE 'n/a'   
   END AS cst_gndr,  
   cst_create_date  
  FROM (  
  SELECT  
   *,  
   ROW_NUMBER() OVER(PARTITION BY cst_id order by cst_create_date DESC)rn  
  FROM [bronze].[crm_cust_info]  
  where cst_id is not null  
  ) X  
  WHERE  X.RN=1;  
  
  
  PRINT '>> Trucating Table: silver.crm_prd_info';  
  TRUNCATE TABLE [silver].[crm_prd_info];  
  PRINT '>> Insert Data Into: silver.crm_prd_info';  
  INSERT INTO [silver].[crm_prd_info] (  
   prd_id ,  
   cat_id ,  
   prd_key ,  
   prd_nm  ,  
   prd_cost,  
   prd_line,  
   prd_start_dt,  
   prd_end_dt  
  )  
  SELECT   
      [prd_id]  
     ,REPLACE(SUBSTRING(prd_key,1,5),'-','_')cat_id  
     ,SUBSTRING(prd_key,7,len(prd_key)) prd_key  
     ,[prd_nm]  
     ,isnull([prd_cost],0)prd_cost  
     ,case UPPER(TRIM(prd_line))  
       when  'M' THEN 'Mountain'    
       when  'R' THEN 'Road'    
       when  'S' THEN 'Other Sales'  
       when  'M' THEN 'Touring'  
       else 'n/a'  
      END prd_line  
     ,[prd_start_dt]  
     ,DATEADD(day, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) as prd_end_date  
    FROM [DataWarehouse].[bronze].[crm_prd_info];  
  
  
  PRINT '>> Trucating Table: silver.crm_sales_details';  
  TRUNCATE TABLE silver.crm_sales_details;  
  PRINT '>> Insert Data Into: silver.crm_sales_details';  
  INSERT INTO silver.crm_sales_details (  
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
    SELECT   
     sls_ord_num,  
     sls_prd_key,  
     sls_cust_id,  
     CASE   
      WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL  
      ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)  
     END AS sls_order_dt,  
     CASE   
      WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL  
      ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)  
     END AS sls_ship_dt,  
     CASE   
      WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL  
      ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)  
     END AS sls_due_dt,  
     CASE   
      WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)   
       THEN sls_quantity * ABS(sls_price)  
      ELSE sls_sales  
     END AS sls_sales, 
     sls_quantity,  
     CASE   
      WHEN sls_price IS NULL OR sls_price <= 0   
       THEN sls_sales / NULLIF(sls_quantity, 0)  
      ELSE sls_price  
     END AS sls_price  
    FROM bronze.crm_sales_details;  
  
   PRINT '--------------------------------';  
   PRINT 'Loading ERP Tables';  
   PRINT '--------------------------------';  
  
  
  
    PRINT '>> Trucating Table: silver.erp_cust_az12';  
    TRUNCATE TABLE silver.erp_cust_az12;  
    PRINT '>> Insert Data Into: silver.erp_cust_az12';  
    INSERT INTO [silver].[erp_cust_az12] (  
    
       cid ,  
       bdate,  
       gen  
    
    )  
    SELECT  
    CASE   
     WHEN cid like 'NAS%' THEN SUBSTRING(cid,4,len(cid))  
     ELSE cid   
    END cid  
  
     , CASE   
     WHEN bdate > GETDATE() THEN NULL   
     ELSE bdate   
    END bdate  
  
     ,CASE  
     WHEN UPPER(TRIM(gen)) in ('F','FEMALE') THEN 'Female'  
     WHEN UPPER(TRIM(gen)) in ('M','MALE') THEN 'Male'  
     ELSE 'n/a'  
    END gen  
    FROM [DataWarehouse].[bronze].[erp_cust_az12];  
    
  
     
      PRINT '>> Trucating Table: silver.erp_loc_a101';  
      TRUNCATE TABLE silver.erp_loc_a101;  
      PRINT '>> Insert Data Into: silver.erp_loc_a101';  
   INSERT INTO [silver].[erp_loc_a101] (  
   
    cid  
      ,cntry  
   
   )  
   SELECT  
     REPLACE(cid, '-', '') AS cid,   
     CASE  
      WHEN TRIM(cntry) = 'DE' THEN 'Germany'  
      WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'  
      WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'  
      ELSE TRIM(cntry)  
     END AS cntry   
   FROM [bronze].[erp_loc_ac101];  
  
    
  SET @start_date = GETDATE();  
  PRINT '>> Trucating Table: silver.erp_px_cat_g1v2';  
  TRUNCATE TABLE silver.erp_px_cat_g1v2;  
  PRINT '>> Insert Data Into: silver.erp_px_cat_g1v2';  
  INSERT INTO [silver].[erp_px_cat_g1v2] (  
  
   id,  
   cat,  
   subcat,  
   maintenance  
  
  )  
  SELECT  
    [id]  
   ,[cat]  
   ,[subcat]  
   ,[maintenance]  
  FROM [bronze].[erp_cat_g1v2];  
  
    
  SET @end_date = GETDATE();  
  PRINT 'Load Duration: ' + CAST(DATEDIFF(second,@start_date,@end_date) AS NVARCHAR) + ' seconds';  
  PRINT '--------------';  
  
  SET @batch_end_time = GETDATE();  
  PRINT '==========================================';  
  PRINT 'Loading Bronze  Layer  is Completed';  
  PRINT '    - Total Load Duration: ' +  CAST(DATEDIFF(second,@batch_start_time,@batch_end_time) AS NVARCHAR) + ' seconds';  
  
 END TRY   
 BEGIN CATCH  
    
  PRINT'===============================================';  
  PRINT 'ERROR OCCURED DURING  LOADIN BROZING  LAYER';  
  PRINT 'Error Message' + ERROR_MESSAGE();  
  PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);   
  PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);   
  PRINT'===============================================';  
  
 END CATCH  
END  
  
