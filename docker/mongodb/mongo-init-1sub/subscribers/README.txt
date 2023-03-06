Generate the number of subscribers:
./insert-subscribers.sh <num>

Install mongodb shell (after adding the correct repository):
(e.g., in pcf function)
apt-get install mongodb-mongosh

Run the script with mongsh
mongosh mongodb://mongodb.myopen5gs.svc.k8s2.tnt-lab.local/open5gs addSubscribers.mongosh 

(note: the command fail if some records are already present. A better script should use the
 updateMany function, as the script provided by open5gs, but it didn't worked in my case
 and I didn't investigate the reason).

