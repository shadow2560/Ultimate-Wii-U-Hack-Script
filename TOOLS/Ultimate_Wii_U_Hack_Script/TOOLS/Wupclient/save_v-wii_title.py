# Script by Shadow256
import wupclient
import sys
import os
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

def dl_folder(path, local_path):
    results = w.ls(path, True)
    path=path + '/'
    for result in results:
        if not result['is_file']:
            os.makedirs('save_v-wii/titles' + path + result['name'])
            dl_folder(path + result['name'], local_path)
        else:
            w.dl(path + result['name'], local_path + path)

dl_folder('/vol/storage_slccmpt01/title/00000001/' + sys.argv[2], '../../save_v-wii/titles')
wupclient.unmount_slccmpt01()
wupclient.unmount_sd()
sys.exit(0)