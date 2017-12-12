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
sql_mat="select name, material, type, count, point from product where barcode=%s"
sql_account="select userid, point from user"

while True:
    userid=input("Scan your membership barcode : ")
    cur.execute(sql_account)
    res_account=cur.fetchall()

    for rows in res_account:
        if(userid in rows['userid']):
            user_point = int(rows['point']);

            barcode =input("Scan barcode: ")
            cur.execute(sql_mat,(barcode))
            res_material=cur.fetchall()

            for row in res_material:
                print(row['material'])
                print(row['name'])

            prod_type = row['type']
            material = row['material']
            name = row['name']
            point = int(row['point'])
            count = int(row['count'])

            if material == 'paper' :
                gpio.output(led0, True)
            elif material == 'plastic' :
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

                print("%.2f it's right" % distance1)

                renew_point=point+user_point;


                curs=conn.cursor()
                if distance < 8 :
                    if material == 'paper' :
                        gpio.output(led0, False)
                        curs.execute("""insert into log(userid, type, material, name, date, point) values ('%s', '%s', '%s', '%s', now(), %s)"""
                                        % (userid, prod_type, material, name, point))
                        curs.execute("""update user set point = %s where userid='%s'""" % (renew_point, userid))
                        count=count+1
                        curs.execute("""update product set count = %s where barcode='%s'""" % (count, barcode))
                        conn.commit()
                        break
                if distance1 < 8 :
                    if material == 'plastic' :
                        gpio.output(led1, False)
                        curs.execute("""insert into log(userid, type, material, name, date, point) values ('%s', '%s', '%s', '%s', now(), %s)"""
                                        % (userid, prod_type, material, name, point))
                        curs.execute("""update user set point = %s where userid='%s'""" % (renew_point, userid))
                        count=count+1
                        curs.execute("""update product set count = %s where barcode='%s'""" % (count, barcode))
                        conn.commit()
                        break



conn.close()
gpio.clear()
