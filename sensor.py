import RPi.GPIO as gpio
import time

gpio.setmode(gpio.BCM)

trig=13
echo=19
led1=23
led2=24
print("start")

gpio.setup(trig, gpio.OUT)
gpio.setup(echo, gpio.IN)
gpio.setup(led1, gpio.OUT)
gpio.setup(led2, gpio.OUT)


try :
    while True :
        gpio.output(trig, False)
        time.sleep(0.05)

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
        print("%0.2f"%distance)

        #test for led
        if distance < 3 :
            gpio.output(led1, False)
            gpio.output(led2, False)
            time.sleep(3)
            gpio.output(led1, True)
            gpio.output(led2, True)
            

except :
    gpio.cleanup()
