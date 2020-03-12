#!/usr/bin/env python

from SimPy.Simulation import *
from random import Random,expovariate,uniform

class G: #globals 
	Rnd = Random(12345)
	#create the repairperson
	RepairPerson = Resource(1)

class MachineClass(Process):
	TotalUpTime = 0.0
	NRep = 0
	NImmedRep = 0

	UpRate = 1/1.0
	RepairRate = 1/0.5

	NextID = 0
	NUp = 0
	def __init__(self):
		Process.__init__(self) #SimPy's Thread class! Application
		self.StartUpTime = 0.0
		self.ID = MachineClass.NextID
		MachineClass.NextID += 1
		MachineClass.NUp += 1

	def Run(self):
		while 1:
			self.StartUpTime = now()
			yield hold,self,G.Rnd.expovariate(MachineClass.UpRate)
			MachineClass.TotalUpTime += now() - self.StartUpTime
			MachineClass.NRep += 1
			if G.RepairPerson.n == 1:
				MachineClass.NImmedRep += 1

			yield request,self,G.RepairPerson
			yield hold,self,G.Rnd.expovariate(MachineClass.RepairRate)
			yield release,self,G.RepairPerson

def main():
	initialize()
	#set up 2 machine processes
	for I in range(2):
		M = MachineClass()
		activate(M,M.Run()) #used to add a simpy thread to the run list, Run() generators
	MaxSimtime = 10000.0
	simulate(until = MaxSimtime)
	downtime = (2*MaxSimtime) - MachineClass.TotalUpTime
	dtmean = downtime / 2
	print(dtmean)

if __name__ == '__main__': main()