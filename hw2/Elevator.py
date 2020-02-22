from SimPy.Simulation import *
from random import Random,expovariate,uniform

class G:  # globals
   Rnd = Random(12345)
   passResource = Resource(0);
   elevProc = None  # elevator process
   passProc = None  # passenger process

class passClass(Process):
   def __init__(self):
      Process.__init__(self)
      self.passArrvRate = float(sys.argv[1])
      # self.arrvs will be arrivals waiting for pickup
      self.arrvs = [0.0]
      self.nextArrv = None  # for debugging/code verifying
   def Run(self):
      while True:
         # sim next arrival