
/*
===============================================================================
Script DDL: Criação das Tabelas da Camada Bronze (Bronze Tables)
===============================================================================
Propósito do Script:
    Este script cria as tabelas no esquema 'bronze', excluindo as tabelas
    existentes caso elas já existam.
    Execute este script para redefinir a estrutura DDL das tabelas 'bronze'.
===============================================================================
*/


DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
    cst_id              INT,
    cst_key             NVARCHAR(50),
    cst_firstname       NVARCHAR(50),
    cst_lastname        NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),
    cst_gndr            NVARCHAR(50),
    cst_create_date     DATE
);
GO



DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info(

	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost NVARCHAR(50),
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_date DATE

);

GO
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details(

	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT

);

GO
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12(

	cid NVARCHAR(50),
	bdate DATE,
	gen NVARCHAR(50)
	
);

GO
DROP TABLE IF EXISTS bronze.erp_loc_ac101;
CREATE TABLE bronze.erp_loc_ac101(

	cid NVARCHAR(50),
	cntry	NVARCHAR(50)

);

GO
DROP TABLE IF EXISTS bronze.erp_cat_g1v2;
CREATE TABLE bronze.erp_cat_g1v2(

	id NVARCHAR(50),
	cat NVARCHAR(50),
	subcat NVARCHAR(50),
	maintenance NVARCHAR(50)

);
