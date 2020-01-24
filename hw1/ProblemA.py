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
	int_list = []

	for i in text: 
		if int(i) < 0:
			print("Error: Non-negative number in imgFile.")
			sys.exit()
		int_list.append(int(i))

	overall = []

	#Create matrix object 
	mat = Matrix(int_list,nr,nc)

	#Get overall count vector for given matrix and thresholds
	for threshold in thresholds:
		placehold = []
		#horizontal
		placehold.extend(horizontalcheck(mat,threshold))
		#vertical
		placehold.extend(verticalcheck(mat,threshold))
		#NW-SE diag
		placehold.extend(nwsecheck(mat,threshold))
		#NE-SW diag
		placehold.extend(neswcheck(mat,threshold))
		overall.append(placehold)

	print(overall)


def horizontalcheck(mat,threshold):
	vec = []
	memo = []
	for i in mat:
		count = 0
		for j in i:
			if j < threshold and memo:
				memo = []
				count += 1
			if j >= threshold: 
				memo.append(j)
		if memo: 
			memo = []
			count += 1
		vec.append(count)
	return vec

def verticalcheck(mat,threshold):
	vec = []
	memo = []
	for index, i in enumerate(mat[0]):
		count = 0
		for j in mat:
			if j[index] < threshold and memo:
				memo = []
				count += 1
			if j[index] >= threshold: 
				memo.append(j[index])
		if memo: 
			memo = []
			count += 1
		vec.append(count)
	return vec

#  4   15   16   1
# 17    2   10  18
# 11   12    9  20

# work on nwse
def nwsecheck(mat,threshold):
	rows = mat.rows 
	cols = mat.cols 

	diag = []
	for x in range(rows + cols - 1):
		line = []
		for y in range(x + 1):
			if(x - y) < rows and y < cols:
				line.append(mat[x-y][y])
		diag.append(line)
	print(diag)
	return [1,1]

def neswcheck(mat,threshold):
	rows = mat.rows
	cols = mat.cols

	diag = []
	for x in range(rows + cols - 1):
		line = []
		for y in range(x + 1):
			if(x - y) < rows and y < cols:
				line.append(mat[x-y][y])
		diag.append(line)
	#print(diag)
	return [1,1]

tda('sampleimg',3,4,[10,5])
