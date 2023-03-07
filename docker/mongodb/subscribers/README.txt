Generate the number of subscribers:
% ./insert-subscribers.sh <num>

Install mongodb shell (after adding the correct repository):
(e.g., in pcf function)
% apt-get install mongodb-mongosh

Run the script with mongsh
%mongosh mongodb://mongodb.myopen5gs.svc.k8s2.tnt-lab.local/open5gs addSubscribers.mongosh 

(note: the command fail if some records are already present. A better script should use the
 updateMany function, as the script provided by open5gs, but it didn't worked in my case
 and I didn't investigate the reason).

Look for all items in collection "subscribers", db "open5gs"

% mongosh mongodb://mongodb.myopen5gs.svc.k8s2.tnt-lab.local/open5gs
open5gs> use open5gs
open5gs> db.subscribers.find()

[Only returns 20 elements]
To see additional elements, type "it" in the shell:
open5gs> it

To see all elements:
open5gs> db.subscribers.find().toArray();

Better way:
open5gs> DBQuery.shellBatchSize = 300
db.subscribers.find( {}, { imsi: 1, _id: 0 }, { limit: 0 } )
Unfortunately, it is deprecated. Use this instead:
open5gs> config.set("displayBatchSize", 300)
(which is persistent across multiple invocations of the shell)

A more refined search, where only "imsi" is printed (4 elements only)
open5gs> db.subscribers.find( {}, { imsi: 1, _id: 0 }, { limit: 4 } )

Dump the database once it has been updated with the subscribers:
# mongodump --db open5gs --out mongo-init mongodb://mongodb.myopen5gs.svc.k8s2.tnt-lab.local/open5gs

The database can be copied inside the docker image, where it is automatically restored.
