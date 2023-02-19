-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS InsuranceCompany;
CREATE TABLE InsuranceCompany(
   companyID   INTEGER  PRIMARY KEY 
  ,companyName VARCHAR(100)
  ,addressID   INTEGER 
);


ALTER TABLE insurancecompany ADD CONSTRAINT FK_ADRESS_INSCOMP FOREIGN KEY (addressID) REFERENCES  address(addressID);

select count(*) from insurancecompany;