# Script by Shadow256
import sys
import wupclient
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
w.mkdir('/vol/storage_slccmpt01/title', 0x755)
w.mkdir('/vol/storage_slccmpt01/title/00000001', 0x755)

def up_folder(path, server_path):
    path=path + '/'
    server_path=server_path + '/'
    for f in os.listdir(path):
        if os.path.isfile(path + f):
            w.up(path + f, server_path + f)
        else:
            w.mkdir(server_path + f, 0x755)
            up_folder(path + f, server_path + f)

up_folder('save_v-wii/vol/storage_slccmpt01/title/00000001', '/vol/storage_slccmpt01/title/00000001')

def do_folder(path):
    results = w.ls(path, return_data = True)
    for result in results:
        w.chmod(path + '/' + result['name'], 0x755)
        if not result['is_file']:
            do_folder(path + '/' + result['name'])

do_folder('/vol/storage_slccmpt01/title/00000001/00000002')
do_folder('/vol/storage_slccmpt01/title/00000001/00000050')
wupclient.unmount_slccmpt01()
wupclient.unmount_sd()
sys.exit(0)