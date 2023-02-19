-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS Pharmacy;
CREATE TABLE Pharmacy(
   pharmacyID   INTEGER  NOT NULL PRIMARY KEY 
  ,pharmacyName VARCHAR(33) NOT NULL
  ,phone        BIGINT  NOT NULL
  ,addressID    INTEGER  NOT NULL
);

ALTER TABLE Pharmacy ADD CONSTRAINT FK_ADRESS_PHARMA FOREIGN KEY (addressID) REFERENCES  address(addressID);


DESC Pharmacy;

select count(*) from pharmacy;
