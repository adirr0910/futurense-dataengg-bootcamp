-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS InsurancePlan;
CREATE TABLE InsurancePlan(
   uin       VARCHAR(25) PRIMARY KEY
  ,planName  VARCHAR(100)
  ,companyID INTEGER 
);

ALTER TABLE InsurancePlan ADD CONSTRAINT FK_InsComp_InsPlan FOREIGN KEY (companyID) REFERENCES  InsuranceCompany(companyID);


select count(*) from insuranceplan;

DESC InsurancePlan;
