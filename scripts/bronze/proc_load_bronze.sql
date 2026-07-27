/*
===============================================================================
Stored Procedure: Carga da Camada Bronze (Origem -> Bronze)
===============================================================================
Propósito do Script:
    Esta stored procedure carrega dados no esquema 'bronze' a partir de arquivos
    CSV externos.
    Ela realiza as seguintes ações:
    - Trunca (esvazia) as tabelas bronze antes de carregar os dados.
    - Utiliza o comando `BULK INSERT` para carregar dados dos arquivos CSV
      para as tabelas bronze.

Parâmetros:
    Nenhum.
    Esta stored procedure não aceita parâmetros nem retorna valores.

Exemplo de Uso:
    EXEC bronze.load_bronze;
===============================================================================
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS

BEGIN
DECLARE @start_date DATETIME, @end_date DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE()
		PRINT '================================';
		PRINT 'Loading Bronze Layer';
		PRINT '================================';

		PRINT '--------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------';

		SET @start_date = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Insert Data Into: bronze.crm_cust_info';
		BULK INSERT bronze.crm_cust_info -- TABELA ONDE SERA INSERIDO OS DADOS
		FROM 'C:\Users\Notebook Samsung\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'-- CAMINHO ONDE ESTA OS DADOS
		WITH (
			FIRSTROW = 2, -- DADOS A PARTINHA DA LINHA 2
			FIELDTERMINATOR = ',', -- SEPARADOR DO ARQUIVO
			TABLOCK -- BLOQUEA A TABELA ENQUANTO OS DADOS SÃO INSERIRDOS

		);
		SET @end_date = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second,@start_date,@end_date) AS NVARCHAR) + ' seconds';
		PRINT '--------------';

		SET @start_date = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Insert Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Notebook Samsung\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (

			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_date = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second,@start_date,@end_date) AS NVARCHAR) + ' seconds';
		PRINT '--------------';

		SET @start_date = GETDATE();
		PRINT '>> Truncating Table: [bronze].[crm_sales_details]';
		TRUNCATE TABLE [bronze].[crm_sales_details];

		PRINT '>> Insert Data Into: [bronze].[crm_sales_details]';
		BULK INSERT [bronze].[crm_sales_details]
		FROM 'C:\Users\Notebook Samsung\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (

			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_date = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second,@start_date,@end_date) AS NVARCHAR) + ' seconds';
		PRINT '--------------';

		PRINT '--------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '--------------------------------';

		SET @start_date = GETDATE();
		PRINT '>> Truncating Table: [bronze].[erp_cat_g1v2]';
		TRUNCATE TABLE [bronze].[erp_cat_g1v2];

		PRINT '>> Insert Data Into: [bronze].[erp_cat_g1v2]';
		BULK INSERT [bronze].[erp_cat_g1v2]
		FROM 'C:\Users\Notebook Samsung\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (

			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_date = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second,@start_date,@end_date) AS NVARCHAR) + ' seconds';
		PRINT '--------------';

		SET @start_date = GETDATE();
		PRINT '>> Truncating Table: [bronze].[erp_cust_az12]';
		TRUNCATE TABLE [bronze].[erp_cust_az12];

		PRINT '>> Insert Data Into: [bronze].[erp_cust_az12]';
		BULK INSERT [bronze].[erp_cust_az12]
		FROM 'C:\Users\Notebook Samsung\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (

			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);

		SET @end_date = GETDATE();

		PRINT 'Load Duration: ' + CAST(DATEDIFF(second,@start_date,@end_date) AS NVARCHAR) + ' seconds';
		PRINT '--------------';

		SET @start_date = GETDATE();
		PRINT '>> Truncating Table: [bronze].[erp_loc_ac101]';
		TRUNCATE TABLE [bronze].[erp_loc_ac101];

		PRINT '>> Insert Data Into: [bronze].[erp_loc_ac101]';
		BULK INSERT [bronze].[erp_loc_ac101]
		FROM 'C:\Users\Notebook Samsung\Documents\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (

			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
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
