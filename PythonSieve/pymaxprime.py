def primeSieve(n):
    numarray = [1]*n
    numarray[0]=0
    numarray[1]=0

    p = 2
    maxPrime = 0
    
    while p<n:
        if numarray[p]:
            maxPrime = p
            for i in range(2*p,n,p):
                numarray[i] = 0
        p+=1
    
    return maxPrime

