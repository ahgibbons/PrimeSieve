#include <stdio.h>
#include <stdlib.h>


int main(int argc, char *argv[]) {
  int n;
  int c;
  int i;
  int p;

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
  int primeMask[n];
  
  for (i=0;i<n;i++) {
    primeMask[i] = 1;
  }

  primeMask[0] = 0;
  primeMask[1] = 0;

  p=2;
  c=0;
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

  printf("Wrote to file, found %d primes! Finished!\n", c);

  return 0;
}


