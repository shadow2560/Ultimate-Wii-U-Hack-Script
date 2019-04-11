# Script by Shadow256
import sys
import wupclient
"""Connect to wupserver"""
print("Connecting to wupserver")
w = wupclient.wupclient()
if(w.s == None):
	input("Failed to connect to wupserver!")
	sys.exit(1)
print("Connected!")
wupclient.w = w
w.ls ('/vol/storage_mlc01/usr/title/00050000/')
w.ls ('/vol/storage_usb01/usr/title/00050000/')
w.ls ('/vol/storage_usb02/usr/title/00050000/')
sys.exit(0)