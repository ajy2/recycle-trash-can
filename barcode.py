#!/usr/bin/env python
import pymysql

#DB connection
conn = pymysql.connect(host='ajy.iptime.org', port=3306, user='ajy0714', password='940714a', db='capstone')

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

