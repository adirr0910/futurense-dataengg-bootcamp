-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS Contain;
CREATE TABLE Contain(
   prescriptionID BIGINT  NOT NULL
  ,medicineID     INTEGER  NOT NULL
  ,quantity       INTEGER  NOT NULL
  ,PRIMARY KEY(prescriptionID,medicineID)
);

select count(*) from contain;

ALTER TABLE Contain ADD CONSTRAINT FK_Medicine_Contain FOREIGN KEY (medicineID) REFERENCES  Medicine(medicineID);

ALTER TABLE Contain ADD CONSTRAINT FK_Presc_Contain FOREIGN KEY (prescriptionID) REFERENCES  prescription(prescriptionID);

show create table contain;
