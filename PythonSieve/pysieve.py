import numpy as np
import sys

def primeSieve(n):
    numarray = np.array([1]*n)
    numarray[0]=0
    numarray[1]=0

    p = 2
    while p<n:
        if numarray[p]:
            ps = np.arange(2*p,n,p)
            for i in ps:
                numarray[i] = 0
        p+=1
    
    primes = []
    for n,i in enumerate(numarray):
        if i:
            primes.append(n)
    return primes

if __name__=="__main__":
    args = sys.argv

    n = int(args[1])
    outfile = args[2]

    primes = primeSieve(n)

    with open(outfile,'w') as ofile:
        ofile.write("\n".join((str(line) for line in primes)))
        ofile.write("\n")

    print("Found {:d} primes less than {:d}!".format(len(primes),n))
    
