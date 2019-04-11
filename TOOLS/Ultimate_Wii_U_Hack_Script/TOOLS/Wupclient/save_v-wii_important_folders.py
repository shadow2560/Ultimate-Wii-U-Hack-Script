# Script by Shadow256
import sys
import os
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
w.dl('/vol/storage_slccmpt01/title/00000001/00000002/content/00000022.app', '../../save_v-wii/vol/storage_slccmpt01/title/00000001/00000002/content')
w.dl('/vol/storage_slccmpt01/title/00000001/00000002/content/00000023.app', '../../save_v-wii/vol/storage_slccmpt01/title/00000001/00000002/content')

def dl_folder(path, local_path):
    results = w.ls(path, True)
    path=path + '/'
    for result in results:
        if not result['is_file']:
            os.makedirs('save_v-wii' + path + result['name'])
            dl_folder(path + result['name'], local_path)
        else:
            w.dl(path + result['name'], local_path + path)

dl_folder('/vol/storage_slccmpt01/title/00000001/00000050', '../../save_v-wii')
wupclient.unmount_slccmpt01()
wupclient.unmount_sd()
sys.exit(0)