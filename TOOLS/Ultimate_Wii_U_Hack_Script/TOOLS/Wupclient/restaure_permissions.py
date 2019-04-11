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
wupclient.mount_slccmpt01()
wupclient.mount_sd()

def do_folder(path):
    results = w.ls(path, return_data = True)
    for result in results:
        w.chmod(path + '/' + result['name'], 0x755)
        if not result['is_file']:
            do_folder(path + '/' + result['name'])

do_folder('/vol/storage_slccmpt01')
wupclient.unmount_slccmpt01()
wupclient.unmount_sd()
sys.exit(0)