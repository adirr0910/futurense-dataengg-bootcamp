-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS Medicine;
CREATE TABLE Medicine(
   medicineID         INTEGER  PRIMARY KEY 
  ,companyName        VARCHAR(101)
  ,productName        VARCHAR(174)
  ,description        VARCHAR(161)
  ,substanceName      VARCHAR(255)
  ,productType        INTEGER 
  ,taxCriteria        VARCHAR(3)
  ,hospitalExclusive  VARCHAR(1)
  ,governmentDiscount VARCHAR(1)
  ,taxImunity         VARCHAR(1)
  ,maxPrice           NUMERIC(9,2)
);

select count(*) from medicine;