import sys

class Matrix(object):
    """
    Represent a matrix and allow for basic matrix operations to be done.
    """
    def __init__(self, X, r, c):
        """
        X - a list of numbers
        r - number of rows
        c - number of columns
        """
        #Creates the matrix object with given dimensions
        i = 0
        self.X = []
        while i<len(X):
        	self.X.append(X[i:i+c])
        	i+= c
        #Checks if the number of elements match given dimensions	
        if (r*c) != len(X):
        	print("Error: Number of elements, do not match matrix dimensions.")
        	sys.exit()
        #Checks if number of rows in matrix match the matrix object
        if len(self.X) != r: 
        	print("Error: Number of Rows in Matrix does not match.")
        	sys.exit()
    
    @property
    def rows(self):
        return len(self.X)
    
    @property
    def cols(self):
        return len(self.X[0])
    

    def __getitem__(self, key):
        return self.X[key]

    def __setitem__(self, key, value):
        assert self.cols == len(value)
        self.X[key] = value

    def __delitem__(self, key):
        """
        Delete a row of the matrix
        """
        del self.X[key]

    def del_column(self, key):
        """
        Delete a specified column
        """
        for i in range(0,self.rows):
            del self.X[i][key]

def tda(imgFile,nr,nc,thresholds):
	#get the counts of numbers over thresholds
	#tabulating order
	# horizontal,vertical, NW-SE diag , NE-SW diag

	f = open(imgFile)
	text = f.readline().split()
	int_list = [int(i) for i in text]

	#Create matrix object 
	mat = Matrix(int_list,nr,nc)
	print(mat.X)

tda('sampleimg',3,4,10)
