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

def rm_folder(path):
    results = w.ls(path, True)
    for result in results:
        if not result['is_file']:
            rm_folder(path + '/' + result['name'])
            w.rmdir(path + '/' + result['name'])
        else:
            w.rm(path + '/' + result['name'])
    w.rmdir(path)

rm_folder('/vol/storage_mlc01/sys/update')
w.up('update', '/vol/storage_mlc01/sys/')
sys.exit(0)