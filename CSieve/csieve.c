#include <stdio.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
  int n;  // Upper limit to check
  int c;  // Number of primes found
  int i;  // Iterator
  int p;  // Current prime

  if (argc != 3) {
    printf("Incorrect number of arguments!\n");
    return 0;
  }

  FILE *f = fopen(argv[2],"w");
  if (f==NULL) {
    printf("Error opening file!\n");
    exit(1);
  }
  
  n = atoi(argv[1]);

  // Prime mask, 0 if not prime, 1 if prime
  char* primeMask = malloc(sizeof(char)*n);
  
  for (i=0;i<n;i++) {
    primeMask[i] = 1;
  }

  primeMask[0] = 0;
  primeMask[1] = 0;

  p=2; // Initial prime
  c=0;


  // Main sieve loop
  while (p<n) {
    if (primeMask[p]==1) {
      fprintf(f,"%d\n",p);
      c++;
      for (i=2*p;i<n;i+=p) {
	primeMask[i] = 0;
      }
    }
    p++;
  }


  free(primeMask);
  printf("Found %d primes less than %d! Wrote to %s!\n",
	 c, n, argv[2] );
  
  return 0;
}


