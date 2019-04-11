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
wupclient.mount_slccmpt01()
wupclient.mount_sd()

def rm_folder(path):
    results = w.ls(path, True)
    for result in results:
        if not result['is_file']:
            rm_folder(path + '/' + result['name'])
            w.rmdir(path + '/' + result['name'])
        else:
            w.rm(path + '/' + result['name'])
    w.rmdir(path)

rm_folder('/vol/storage_slccmpt01/title/00000001/' + sys.argv[2])
wupclient.unmount_slccmpt01()
wupclient.unmount_sd()
sys.exit(0)