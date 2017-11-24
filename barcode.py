#!/usr/bin/env python
import pymysql

#DB connection
conn = pymysql.connect(host='192.168.0.32', port=3306, user='root', password='ehcl5397', db='capstone')

#Download DB from server to RaspberryPi
cur=conn.cursor(pymysql.cursors.DictCursor)

#SQL query that will be executed
sql_mat="select prod_mat from recycleBin where barcode=%s"

#Get data from barcode scanner and determine the 
while True:
    barcode = input("Scan barcode: ")
    cur.execute(sql_mat, (barcode))
    res_material=cur.fetchall()

    #get data in dictionary type from list(named res_material)
    for row in res_material:
	    print(row['prod_mat'])


#Close DB connection
conn.close()

