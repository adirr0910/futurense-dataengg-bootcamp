-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS Keep;
CREATE TABLE Keep(
   pharmacyID INTEGER 
  ,medicineID INTEGER 
  ,quantity   INTEGER 
  ,discount   INTEGER 
  ,PRIMARY KEY(pharmacyID,medicineID)
);

select count(*) from keep;

ALTER TABLE keep ADD CONSTRAINT FK_pharma_keep FOREIGN KEY (pharmacyID) REFERENCES  pharmacy(pharmacyID);
ALTER TABLE keep ADD CONSTRAINT FK_medicine_keep FOREIGN KEY (medicineID) REFERENCES  Medicine(medicineID);





