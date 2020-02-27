from SimPy.Simulation import *
from random import Random,expovariate

class G:  # globals
    Rnd = Random(12345)
    elevProc = None  # elevator process
    passProc = None  # passenger process

class passClass(Process):
    def __init__(self):
        Process.__init__(self)
        self.passArrvRate = float(sys.argv[1])
        # self.arrvs will be arrivals waiting for pickup
        self.arrvs = [0.0]
    def Run(self):
        while True:
            yield hold, self, G.Rnd.expovariate(self.passArrvRate)
            self.arrvs.append(now())
            if G.elevProc.asleep == True:
                reactivate(G.elevProc)

class elevatorClass(Process):
    def __init__(self):
        Process.__init__(self)
        self.elevReturnRate = 1.0 / float(sys.argv[3])
        self.maxPassengers = int(sys.argv[2])
        self.asleep = False
        self.waitTimes = []
        self.numTrips = 0.0
        self.fullTrips = 0.0
    def Run(self):
        while True:
            #Get the first X people in the list, go to sleep if nobody there
            passengers = G.passProc.arrvs[:self.maxPassengers]
            if len(G.passProc.arrvs) == 0:
                self.asleep = True
                yield passivate,self
                self.asleep = False
                passengers = G.passProc.arrvs[:self.maxPassengers]
            
            #Remove the first X people from the list
            G.passProc.arrvs = G.passProc.arrvs[self.maxPassengers:]

            self.numTrips += 1
            #If there are passengers left over
            if len(G.passProc.arrvs) > 0:
                self.fullTrips += 1
            
            passengers = map(lambda u: now() - u, passengers)
            self.waitTimes.extend(passengers)

            #Wait for the elevator to arrive again
            yield hold, self, G.Rnd.expovariate(self.elevReturnRate)

def main():
    initialize()
    G.elevProc = elevatorClass()
    G.passProc = passClass()
    activate(G.elevProc, G.elevProc.Run())
    activate(G.passProc, G.passProc.Run())
    MaxSimTime = float(sys.argv[4])
    simulate(until=MaxSimTime)
    print 'mean passenger wait: ', sum(G.elevProc.waitTimes) / len(G.elevProc.waitTimes)
    print 'prop. of visits that leave passengers behind: ', (G.elevProc.fullTrips / G.elevProc.numTrips)


if __name__ == '__main__':  main()