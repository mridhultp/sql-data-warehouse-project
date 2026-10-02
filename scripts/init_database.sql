/*
------ Create Database and Schemas

Script Purpose:

This script creates a new database named 'DataWarehouse' after checking if it already exists.
If the database exists, it is dropped and recreated.
Additionally, the script sets up three schemas within the database: 'bronze', 'silver', and 'gold'.


WARNING:

Running this script will drop the entire 'DataWarehouse' database if it exists.
All data in the database will be permanently deleted.
Proceed with caution and ensure you have proper backups before running this script.


*/

Use master;
GO

--Drop and recreate the 'Datawarehouse' databse

IF EXISTS (SELECT 1 FROM sys.databases WHERE name ='DataWarehouse')
BEGIN
ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE DataWarehouse;
END;

GO

--- create new database

create database DataWarehouse;
GO


Use DataWarehouse;
GO


create schema bronze;
GO
create schema silver;
GO
create schema gold;
GO
