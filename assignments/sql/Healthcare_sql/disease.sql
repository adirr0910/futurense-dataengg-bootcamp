-- Active: 1670398793949@@127.0.0.1@3308@healthcare
DROP TABLE IF EXISTS Disease;
CREATE TABLE Disease(
   diseaseID   INTEGER  NOT NULL PRIMARY KEY 
  ,diseaseName VARCHAR(100) NOT NULL
  ,description VARCHAR(1000) NOT NULL
);

select count(*) from disease;