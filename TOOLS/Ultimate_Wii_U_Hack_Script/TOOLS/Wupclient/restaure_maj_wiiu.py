# Script by Shadow256
import wupclient
import sys
"""Connect to wupserver"""
print("Connecting to wupserver")
w = wupclient.wupclient()
if(w.s == None):
	input("Failed to connect to wupserver!")
	sys.exit(1)
print("Connected!")
wupclient.w = w
w.rm('/vol/storage_mlc01/sys/update')
w.mkdir('/vol/storage_mlc01/sys/update', 0x755)
sys.exit(0)