#!/user/bin/env python
import pymysql
import RPi.GPIO as gpio
import time

conn = pymysql.connect(host='192.168.0.32', port=3306,user='root',password='ehcl5397',db='capstone')

gpio.setmode(gpio.BCM)
gpio.setwarnings(False)
trig=13
echo=19
led1=23
led2=24

gpio.setup(trig, gpio.OUT)
gpio.setup(echo, gpio.IN)
gpio.setup(led1, gpio.OUT)
gpio.setup(led2, gpio.OUT)

gpio.output(led1, True)
gpio.output(led2, True)
cur=conn.cursor(pymysql.cursors.DictCursor)

sql_mat="select prod_mat, prod_name from recycleBin where barcode=%s"
#sql_name="select prod_name from recycleBin where barcode=%s"
while True:
    barcode =input("Scan barcode: ")
    cur.execute(sql_mat,(barcode))
  #  cur.execute(sql_name, (barcode))

    res_material=cur.fetchall()

    for row in res_material:
        print(row['prod_mat'])
        print(row['prod_name'])

    i = row['prod_mat']
    if i == 'pappar' :
        gpio.output(led1, False)
    if i == 'papper' :
        gpio.output(led2, False)
    while True:

        gpio.output(trig, False)
        time.sleep(0.00001)
    
        gpio.output(trig, True)
        time.sleep(0.00001)
        gpio.output(trig, False)
    
        while gpio.input(echo) == 0:
            pulse_start = time.time()
    
        while gpio.input(echo) == 1:
            pulse_end = time.time()
        pulse_duration = pulse_end - pulse_start
        distance = pulse_duration * 17000
        distance = round(distance, 2)

        if distance < 5 :
            if i == 'pappar' :
#                gpio.output(led1, False)
#                time.sleep(0.1)
                gpio.output(led1, True)
                break
            if i == 'papper' :
                gpio.output(led2, True)
                break
conn.close()




