import sys

def primes_sieve2(limit):
    a = [True] * limit                          # Initialize the primality list
    a[0] = a[1] = False
    
    for (i, isprime) in enumerate(a):
        if isprime:
            yield i
            for n in range(i, limit, i):     # Mark factors non-prime
                a[n] = False

if __name__=="__main__":
    args = sys.argv

    if (len(args) != 3):
        print("Incorrect number of arguments!")
        exit(1)

    n = int(args[1])

    with open(args[2],'w') as ofile:
        ofile.write("\n".join([str(i) for i in primes_sieve2(n)]))
        ofile.write("\n")

    print("Finished finding primes!")
    
