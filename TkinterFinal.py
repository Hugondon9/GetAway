from tkinter import *
from PIL import ImageTk, Image
from pygame import mixer
import subprocess,serial
# Variables globales
num_imgs = 20
img_count = 0
image_list = []
num = 0
primeraVez = True
def receiveData():
    global num_imgs, img_count, image_list, num, primeraVez, i, lb
    if(BT.inWaiting() > 0):
        try:
            num = int(BT.readline())
            if primeraVez == True and num >= 0:
                mixer.music.play()
                primeraVez = False
                print("AUDIO ENCENDIDO")
            if num  > 100 :
                if i < (num_imgs - 1):
                    lb.grid_forget()
                    lb = Label(image = image_list[i])
                    lb.place(x = 0,y = 0)
                    i += 1
                else:
                    i = i
                mixer.music.unpause()
                print("ACELERADO.\n\tFrecuencia Cardiaca: {} BMP".format(num))
            elif num <= 100:
                if i > 0 :
                    lb.grid_forget()
                    lb = Label(image = image_list[i])                  
                    lb.place(x = 0,y = 0)
                    i -= 1
                else:
                    i = i
                # mixer.music.pause()
                print("NORMAL.\n\tFrecuencia Cardiaca: {} BMP".format(num));
            root.update()            
        except ValueError:
            print("Ese no es un número!")
    root.after(1,receiveData)
# Inicialización Puerto
subprocess.call("sudo rfcomm release 0", shell = True)
subprocess.call("sudo rfcomm bind hci0 98:D3:B1:FD:47:D1", shell = True)
# Comunicación Bluetooth
port_str,baudrate = '/dev/rfcomm0',9600
BT = serial.Serial(port_str,baudrate)
# Inicialización mixer
mixer.init()
#mixer.music.load("Alone.mp3")
mixer.music.load("TFS.mp3")
# Interfaz
root=Tk()
root.title("Get-Away")
root.configure(background = 'white')
root.geometry("640x480")
root.resizable(False,False)
for i in range(num_imgs + 1):
    image_list.append(ImageTk.PhotoImage(Image.open("D{}.jpg".format(i))))
lb = Label(image = image_list[0])
lb.place(x = 0,y = 0)
i = 0
root.after(1,receiveData)
root.mainloop()