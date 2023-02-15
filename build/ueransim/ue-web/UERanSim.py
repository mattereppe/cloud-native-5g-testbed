# UERANSIM manager

import yaml
import json
import uuid
import subprocess

class UERanSim():

    def __init__(self, template=""):
        #f='/usr/src/UERANSIM/config/open5gs-ue0.conf'
        if len(template) == 0:
            self.conf = {}
        else:
            with open(template,'r') as file:
                self.conf = yaml.load(file, Loader=yaml.FullLoader)
        id=str(uuid.uuid4())
        self.filename="ue-" + id + ".yaml"
        self.logfile="ue-" + id + ".log"

    def set_conf(self, newconf):
        self.conf=newconf
        return self.conf

    def update_conf(self, newconf):
        self.conf.update(newconf)
        return self.conf

    def get_conf(self):
       return self.conf

    def to_json(self):
        return json.dumps(self.conf, indent=2)

    def apply_conf(self):
        with open(self.filename,'w') as file:
            c=yaml.dump(self.conf, file)

    def run(self):
        self.apply_conf()
        self.log = open(self.logfile,'w')
        self.proc = subprocess.Popen(['/usr/local/bin/nr-ue','-c',self.filename], stdout=self.log, stderr=subprocess.STDOUT)

    def stop(self):
        self.proc.kill()
        self.log.close()
        self.proc.pid=-1
        return self.proc.returncode

    def status(self):
        try:
            if self.proc.pid > 0:
                return "Running"
            else:
                return "Stopped"
        except:
            return "Unknown"

    def get_pid(self):
        try:
            return self.proc.pid
        except:
            return -1

    def poll(self):
        try:
            with open(self.logfile,'r') as f:
                log=f.read()
            return log
        except:
            return "No info available. Maybe not running?"
