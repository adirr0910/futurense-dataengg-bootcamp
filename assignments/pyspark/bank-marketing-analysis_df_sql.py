from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("bank-market-analysis") \
    .getOrCreate()
    
df = spark.read.options(delimiter=';',header=True,inferSchema=True).csv('/home/aditi/futurense_hadoop-pyspark/labs/dataset/bankmarket/bankmarketdata.csv')

df.createOrReplaceTempView("BankMarket")

df1 = spark.sql("SELECT count(*),CASE WHEN age<=12 THEN 'kids' WHEN age<=19 and age>12 THEN 'Teenager' WHEN age>=20 and age<=30  THEN 'Youngsters' WHEN age>=31 and age<50 THEN 'MiddleAge' ELSE 'Seniors'  END AS category FROM BankMarket WHERE y='yes' GROUP BY category ORDER BY count(*) DESC");

df1.write.format("parquet").mode("overwrite").save("/home/aditi/BankMarket.parquet")

df2 = spark.read.parquet("/home/aditi/BankMarket.parquet")
print(df2.show())


df3 = spark.sql("SELECT sub_count,category FROM ( SELECT count(*) as sub_count,CASE WHEN age<=12 THEN 'kids' WHEN age<=19 and age>12 THEN 'Teenager' WHEN age>=20 and age<=30  THEN 'Youngsters' WHEN age>=31 and age<50 THEN 'MiddleAge' ELSE 'Seniors'  END AS category FROM BankMarket WHERE y='yes' GROUP BY category ORDER BY count(*) DESC) WHERE sub_count>2000");

df3.write.format("avro").mode("overwrite").save("/home/aditi/BankMarket.avro")

df4 = spark.read.avro("/home/aditi/BankMarket.avro")
print(df4.show())

spark.stop()


