from SimPy.Simulation import *
from random import Random,expovariate,uniform

class G:  # globals
    Rnd = Random(12345)
    passResource = Resource(0);
    elevProc = None  # elevator process
    passProc = None  # passenger process

class passClass(Process):
    numPassengers = 1
    def __init__(self):
        Process.__init__(self)
        self.passArrvRate = float(sys.argv[1])
        # self.arrvs will be arrivals waiting for pickup
        self.arrvs = [0.0]
        self.nextArrv = None  # for debugging/code verifying
    def Run(self):
        while True:
            yield hold, self, G.Rnd.expovariate(self.passArrvRate)
            passClass.numPassengers += 1
            if G.elevProc.asleep == True:
                reactivate(G.elevProc)

class elevatorClass(Process):
    numTrips = 0.0
    fullTrips = 0.0
    def __init__(self):
        Process.__init__(self)
        self.elevReturnRate = 1.0 / float(sys.argv[3])
        self.maxPassengers = float(sys.argv[2])
        self.asleep = False
    def Run(self):
        while True:
            if passClass.numPassengers == 0:
                self.asleep = True
                yield passivate,self
            elevatorClass.numTrips += 1
            if passClass.numPassengers > self.maxPassengers:
                elevatorClass.fullTrips += 1
                passClass.numPassengers -= self.maxPassengers
            else:
                passClass.numPassengers = 0
            yield hold, self, G.Rnd.expovariate(self.elevReturnRate)

def main():
    initialize()
    G.elevProc = elevatorClass()
    G.passProc = passClass()
    activate(G.elevProc, G.elevProc.Run())
    activate(G.passProc, G.passProc.Run())
    MaxSimTime = float(sys.argv[4])
    simulate(until=MaxSimTime)
    print 'proportion of times elevator is full:', (elevatorClass.fullTrips / elevatorClass.numTrips)

if __name__ == '__main__':  main()