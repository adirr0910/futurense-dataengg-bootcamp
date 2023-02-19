-- Active: 1670398793949@@127.0.0.1@3308@healthcare

-- create database healthcare;

-- address table

DROP TABLE IF EXISTS Address;
CREATE TABLE Address(
   addressID INTEGER  PRIMARY KEY 
  ,address1  VARCHAR(200)
  ,city      VARCHAR(100)
  ,state     VARCHAR(20)
  ,zip       INTEGER 
);


select count(*) from address;



