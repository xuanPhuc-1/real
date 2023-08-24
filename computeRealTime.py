import numpy as np
import csv
import pandas as pd
import time
time_interval = 1


with open('ARP_data/ARP_Reply_flowentries.csv', newline='') as f:
    reader = csv.reader(f)
    ARP_Reply = list(reader)
#count the number of ARP_Reply
ARP_Reply = len(ARP_Reply)
with open('ARP_data/ARP_Request_flowentries.csv', newline='') as f1:
    reader = csv.reader(f1)
    ARP_Request = list(reader)

with open('mismatch.txt', 'r') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    reader = list(reader)
    
if int(reader[-1][-1]) > 0:
    miss_match = 1
else:
    miss_match = 0


#count the number of ARP_Request
ARP_Request = len(ARP_Request)
ARP = ARP_Reply + ARP_Request
f.close()
f1.close()


aps = ARP / time_interval              
subARP = ARP_Reply - ARP_Request         
#time stamp with minute:second format
time_stamp = time.strftime("%M:%S", time.localtime())
headers = ["APS", "SUBARP","MISS_MAC"]

features = [aps, subARP, miss_match, 0]

# print(dict(zip(headers, features)))
# print(features)

# with open('features-file.csv', 'a') as f:      #comment de test model
#     cursor = csv.writer(f, delimiter=",")
#     cursor.writerow(features)

# with open('evaluation.csv', 'a') as f:      #comment de test model
#     cursor = csv.writer(f, delimiter=",")
#     cursor.writerow(features)

# with open('realtime.csv', 'w') as f:
#     cursor = csv.writer(f, delimiter=",")
#     cursor.writerow(headers)
#     cursor.writerow(features)
#     f.close()
    
# with open('dataset.csv', 'a') as f:            #comment de test model
#     cursor = csv.writer(f, delimiter=",")
#     cursor.writerow(headers)
#     cursor.writerow(features)
#     f.close()

with open('normal.csv', 'a') as f:      #comment de test model
    cursor = csv.writer(f, delimiter=",")
    cursor.writerow(features)
