#!/user/bin/env python
import pymysql
import RPi.GPIO as gpio
import time

gpio.setmode(gpio.BCM)
gpio.setwarnings(False)

trig0=5
echo0=6
trig1=13
echo1=19
led0=23
led1=24

gpio.setup(trig0, gpio.OUT)
gpio.setup(echo0, gpio.IN)
gpio.setup(trig1, gpio.OUT)
gpio.setup(echo1, gpio.IN)
gpio.setup(led0, gpio.OUT)
gpio.setup(led1, gpio.OUT)

gpio.output(led0, False)
gpio.output(led1, False)

conn = pymysql.connect(host='ajy.iptime.org', port=3306 ,user='ajy0714',password='940714a', db= 'capstone')
cur=conn.cursor(pymysql.cursors.DictCursor)
sql_mat="select prod_mat, prod_name from recycleBin where barcode=%s"

while True:
    barcode =input("Scan barcode: ")
    cur.execute(sql_mat,(barcode))

    res_material=cur.fetchall()

    for row in res_material:
        print(row['prod_mat'])
        print(row['prod_name'])

    i = row['prod_mat']
    if i == 'paper' :
        gpio.output(led0, True)
    elif i == 'plastic' :
        gpio.output(led1, True)
    
    while True:
        gpio.output(trig0, False)
        time.sleep(0.05)        
        gpio.output(trig0, True)
        time.sleep(0.00001)
        gpio.output(trig0, False)

        while gpio.input(echo0) == 0:
            pulse_start = time.time()
        
        while gpio.input(echo0) == 1:
            pulse_end = time.time()

        pulse_duration = pulse_end - pulse_start
        distance = round(pulse_duration * 17000, 2)

        print("%.2f it's left" % distance) 
    
        gpio.output(trig1, False)
        time.sleep(0.05)
        gpio.output(trig1, True)
        time.sleep(0.0001)
        gpio.output(trig1, False)

        while gpio.input(echo1) == 0:
            pulse_start1 = time.time()
     
        while gpio.input(echo1) == 1:
            pulse_end1 = time.time()

        pulse_duration1 = pulse_end1 - pulse_start1
        distance1 = round(pulse_duration1 * 17000, 2)

        print("%.2f it's right"%distance1)

        if distance < 8 :
            if i == 'paper' :
                gpio.output(led0, False)
                break
        if distance1 < 8 :
            if i == 'plastic' :
                gpio.output(led1, False)
                break
conn.close()
gpio.clear()
