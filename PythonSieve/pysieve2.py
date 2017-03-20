import sys
import numpy as np

def primeSieve(n):
    numarray = np.ones(n,dtype=np.bool)
    numarray[0]=0
    numarray[1]=0

    p = 2
    primes=[]
    while p<n:
        if numarray[p]:
            primes.append(p)
            numarray[2*p:n:p] = False
            #for i in range(2*p,n,p):
             #   numarray[i] = 0
        p+=1
    
    return primes

def main1(args):    
    n = int(args[1])
    outfile = args[2]

    primes = primeSieve(n)

    with open(outfile,'w') as ofile:
        ofile.write("\n".join((str(line) for line in primes)))
        ofile.write("\n")

    print("Found {:d} primes less than {:d}!".format(len(primes),n))

if __name__=="__main__":
    args = sys.argv
    main1(args)
