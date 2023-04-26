-- drop tables
DROP TABLE IF EXISTS bikestore_sales.order_items;
DROP TABLE IF EXISTS bikestore_sales.orders;
DROP TABLE IF EXISTS bikestore_production.stocks;
DROP TABLE IF EXISTS bikestore_production.products;
DROP TABLE IF EXISTS bikestore_production.categories;
DROP TABLE IF EXISTS bikestore_production.brands;
DROP TABLE IF EXISTS bikestore_sales.customers;
DROP TABLE IF EXISTS bikestore_sales.staffs;
DROP TABLE IF EXISTS bikestore_sales.stores;

-- drop the schemas

DROP SCHEMA IF EXISTS bikestore_sales;
DROP SCHEMA IF EXISTS bikestore_production;
