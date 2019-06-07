/* MR coalition dynamics ver. 4: 
INITIALIZATION is stablished through a random order which needs no avoid 
node selection. In this version it is used pointer aritmetic to acces to the arrays. 
It is employed Durstenfeld shuffle algorithm to create a random permutation at array
visited. 

AUDITING THE CODE..*/

#include<stdlib.h> /*To detyerminate RAND_MAX and to use qsort, a native C variant of QuickSort - O(nlogn) */
#include<stdio.h>
#include<math.h> 
#include <time.h>

/* constants : ----------------------------------------*/
#define MAXINT 2147483647              /* for random sampling        */
#define L 90000                       /* number of agents           */
float c1,c2;             /* opinion vector, speed of updating, threshold, squared distances */
int     a[L], v[5], i, aa, b, c, k, l;                  /* loop indices               */
int     visited[L];                  /* iterations number, random number seed */
int      r0(int s);                    /* random number routines     */
float    r01();/* random number routines     */
int as=0,bs=0,cs=0; /* Opinion cardinalities restricted to Von-Newman neighbourhood */
int D=0, Ts=1800; /* ties, stripe threshold time bound */
int visit; /* For random order */

/*-------------------------------------------------------------------*/
/* r01: Returns a random uniform number in [0,1] */
float r01()
{  
  float j;
  j=rand(); /* returns a pseudo-random (uniform distributed) integer number in the range of 0 to RAND_MAX=2147483647 */
  return (j / (float)MAXINT); /*returns j/2147483647 in [0,1] with j in [0,2147483647]*/
}

/*-------------------------------------------------------------------*/ 
/* */       
int r0(int s)
{  
  return (random () % s); /*random genetares an integer pseudo-random uniform number in [0,RAND_MAX]
			    then takes modulo s results a random integer number in [0,s-1]*/
}

//Durstenfeld = Knuth P Shuffle
void Durstenfeld_shuffle(int n)
{
int i,j;
for (i = n-1; i >= 0; --i){
    //generate a random number [0, n-1]
    j = rand() % (i+1); //This generates a random nunber in {0,...,i}

    //swap the last element with element at random index
    int temp = *(visited+i);
    *(visited+i) = *(visited+j);
    *(visited+j) = temp;
}
}

/*-------------------------------------------------------------------*/ 
/* Von-Newman Neighbourhood of a[k] */
int VN(int k){
 int r,d, bound=0;
 int N = L;
 r = (int)sqrt(N); 
 d = N/r;
 v[5]=k; //Center node in VN

 if (k > r-1){	
    v[1]=k-r; // Case 1: upper node is in the upper path
    if(k <= L-1-r) // Case 2: bottom node is in the bottom path
	v[3]=k+r;
    if(k > N-1-r && k < N) // Case 3: bottom node is in the upper path
	v[3]=(k+r)%N;
    }

 if (k <= r-1){
	v[1]=(N-r)+k; // Case 4: upper node is in the bottom path
	v[3]=k+r; // Case 5: bottom node is below
 	}

 while(d>0){
 if(k>0 && k==d*r-1){ // rigth  boundary path
	v[2]=k-(r-1); // Case 6: rigth node at left path 
	v[4]=k-1; // Case 7: left node at left 
	bound = 1;
    }
 	d--;
	}

 d = N/r;

 while(d>0){
 if(k==0 || k==d*r){ //left boundary path
	v[2]=k+1;  // Case 8: right node at rigth
	v[4]=k+(r-1); // Case 9: left node at rigth path
	bound = 1;
	}
 d--;
	}

 if(k!=0 && bound == 0) //Excluding left and right path boundaries, internal nodes
	   {
		v[4]=k-1; // Case 10: left at left side
 		v[2]=k+1; // Case 11: rigth node at right side 
 	   } 

// Counting opinions at the Von-Newman Neighbourhood of k...
as=0;bs=0;cs=0;
switch(a[v[1]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}
switch(a[v[2]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}
switch(a[v[3]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}
switch(a[v[4]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}
switch(a[v[5]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}

}

void CVN(void){
// Counting opinions at the Von-Newman Neighbourhood of k...
as=0;bs=0;cs=0;
switch(a[v[1]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}
switch(a[v[2]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}
switch(a[v[3]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}
switch(a[v[4]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}
switch(a[v[5]]){
 	  case -1: as=as+1;break;
	  case 1: bs=bs+1;break;
          case 0: cs=cs+1;break;
	}

}

// Show matrix
void imprime(int *m)
{
 int count=1,k, N=L;
 for(k = 0; k < N; k++)
    { 
     printf("%d ",*(m+k));
     if(count++ == (int)sqrt(N))
	{count = 1; printf("\n");}
    } 
 printf("\n");
}

/*------------------------------------------------------------------*/
/* MAIN */ 
int main (int argc, char *argv[])
{
 c1; /* proportion of small coalition opinion A*/
 int cycle, N, tmp, s, simulation; /* number of cycles */
 int aa=0,b=0,c=0; /* Global opinion cardinalities */
 srandom(time(NULL)); /*The srandom() function sets its argument as the seed for a new sequence of pseudo-random integers to be returned by random().  These sequences are repeatable by calling srandom() with the same seed value.  If no seed value is provided, the random() function is automatically seeded with a value of 1.*/
 clock_t tiempo_inicio, tiempo_final;
 double segundos;

printf("RAND_MAX=%d \n", RAND_MAX);

FILE * fp; 
//FILE * fq;
//fq = fopen ("/home/usuario/Documents/det.txt","w");
fp = fopen ("/home/usuario/Documents/res.txt","w");
N=L; //network order as a int


//Exist if there is no two arguments
if(argc < 2){
  printf("Faltan argumentos!!\n");
	exit(0);
	}

//Convert string to integer main parameters
simulation = strtol(argv[1], NULL, 10);
c1 = strtol(argv[2], NULL, 10);
c1 = c1/100;

 while(simulation > 0){
  tiempo_inicio = clock();

 /**** INITIALIZATION for a RANDOM ORDER ****/ 
 //Reinitizalation for a new simulation
 visit=0,as=0,bs=0,cs=0,aa=0,b=0,c=0,D=0;
 
 //Initially all opinions are C opinions, and the random order is 0,...,N-1
 for (k = 0; k < L; k++) 
    {
 *(a+k)=0;
 *(visited + k)=k;
 }
 // RANDOM ORDER 
 // a -> -1, b -> 1
 // PREVIOUS
 //imprime(visited); //Secuential order 
 //imprime(a); // 0 opinions
 Durstenfeld_shuffle(N); //Shuffle 
 
 // a -> -1
 for (i=0;i< (int)(c1*L);i++)  
  { 
    *(a+visited[i])=-1; //Fills first opinions c1*L random nodes to -1 
  }

  // b -> 1
 for (i=(int)(c1*L);i<(int)((0.5)*L);i++)  
  { 
   *(a+visited[i])=1; //Fills first opinions (0.5-c1)*L random nodes to 1
  }

  // AFTER SHUFFLE
  //imprime(visited); //Random order
  //imprime(a); //Random opinions

  // Counting distributed opinions
  for (k = 0; k < L; k++) 
    {
	if(*(a+k) == -1)
	   aa++;
	if(*(a+k) == 1)
	   b++;
	if(*(a+k) == 0)
	  c++;
    }

  if(simulation == strtol(argv[1], NULL, 10))
 printf("Nodes visited: %d \t Initial Opinion Cardinalities : A = %d B = %d C = %d\n",visit,aa, b, c);
 //imprime(visited);

 cycle = 1;
 // Outputs headers, output file res.txt
 
 if(simulation == strtol(argv[1], NULL, 10)) {
	fprintf(fp,"N \t Ai \t Bi \t Ci \n");
 fprintf(fp,"%d \t %d \t %d \t %d \n",N,aa,b,c);
 fprintf(fp,"Sim. \t c1 \t Af \t Bf \t Cf \t Cyles \t D \t Tiempo(segs)\n");
}
  
 while(cycle <= Ts && aa + b != L && c != L) //while no consensus or stripe states
 {
  for (k = 0; k < L; k++) //10000 iterations of the model, applications of the rules*/
   {
    l=(int)(r01()*(N--)); /* sampling an index 0,...,N - 1, it could be repeated but
    sampled index at visited[l] is interchanged with index at visited[N], after this 
    visited cannot be touched */
    
    if(aa + b + c != L){
	printf("As: %d\t Bs: %d \t %d  desiguales INI\n",aa,b,c);
	exit(0);
	}
 	
    VN(*(visited+l)); //computing opinions and update group cardinalities

    //printf("Sample %d \t Cycle %d \n",k, cycle); 
    //printf("Visited node: %d, upper: %d, right: %d, bottom: %d, left: %d\n",visited[l], v[1],v[2],v[3],v[4]);
    //printf("Cards: As: %d, Bs: %d, Cs: %d\n",as,bs,cs);
    //printf("Opinions: %d, upper: %d, right: %d, bottom: %d, left: %d\n",a[visited[l]],a[v[1]],a[v[2]],a[v[3]],a[v[4]]);

   if(cs > 0 && (as > 0 || bs > 0)){ //Avoid one single opinion 
    //CASE UPDATE 1: Majority for AB & Coalition affinity -> the presence of two coalition opinions and not ties
    if(as+bs > cs && as > 0 && bs > 0 && as != bs) 
	{
	//Coalition Rule + Un tie rule
   	s=r0(2); //random uniform number 0/1
	if(s==1) // B
	{ *(a+v[1])=1;*(a+v[2])=1;*(a+v[3])=1;*(a+v[4])=1;*(a+v[5])=1; //update VN neighbourhood
	//Update cardinalities
	 aa = aa - as;
	 b = b + (as+cs);
	 c = c - cs;
	}
	else {	// A
	*(a+v[1])=-1;*(a+v[2])=-1;*(a+v[3])=-1;*(a+v[4])=-1;*(a+v[5])=-1;
	//Update cardinalities
	 aa = aa + (cs+bs);
	 b = b - bs;
	 c = c - cs;
	}
	} //
	//Count majority coalition ties
      if(as+bs > cs && as > 0 && bs > 0 && as == bs){
		D=D+1; //MCTs	
	} // End coalition affinity
	
    if(as+bs > cs && as == 0 && cs > 0) //Majority for B
	{
        *(a+v[1])=1;*(a+v[2])=1;*(a+v[3])=1;*(a+v[4])=1;*(a+v[5])=1; //update VN neighbourhood
	//Update cardinalities
	 aa = aa - as;
	 b = b + (as+cs);
	 c = c - cs;
	}
 
    if(as+bs > cs && bs == 0 && cs > 0) //Majority for A
	{
	 *(a+v[1])=-1;*(a+v[2])=-1;*(a+v[3])=-1;*(a+v[4])=-1;*(a+v[5])=-1; //update VN neighbourhood
	//Update cardinalities
	 aa = aa + (bs+cs);
	 b = b - bs;
	 c = c - cs;
	}
    //CHECKING
    if(aa + b + c != L){
	printf("As: %d\t Bs: %d \t %d  desiguales despues AB\n",aa,b,c);
	exit(0);
	}
 	
    //CASE UPDATE 2: Majority for C - the presence of two coalition opinions
    if(as+bs < cs) //Majority for C & with 1 or 2  competing opinions
 	{//Majority for C
   	*(a+v[1])=0;*(a+v[2])=0;*(a+v[3])=0;*(a+v[4])=0;*(a+v[5])=0; //update VN neighbourhood
	 //Update cardinalities
	 aa = aa - as;
	 b = b - bs;
	 c = c + (as+bs);
	}
    } //END avoid one single opinion
    
    //printf("Updated Opinions: %d, upper: %d, right: %d, bottom: %d, left: %d\n",a[visited[l]],a[v[1]],a[v[2]],a[v[3]],a[v[4]]);
	//CVN();
    //printf("Updated Cards: As: %d, Bs: %d, Cs: %d\n",as,bs,cs);

     //swap block visited[N]<->visited[l]
     tmp=*(visited+N);
     *(visited+N)=*(visited+l);
     *(visited+l)=tmp;

     //Check if the update has N opinions
     if(aa + b + c != L){
       printf("As %d \t Bs: %d \t %d  desiguales despues C\n",aa,b,c);
	exit(0);
	}
    } // End for k
   N=L;
   //fprintf(fq,"%d \t %0.2f \t %d \t %d \t %d \t %d \t %d \n",simulation,c1,aa,b,c,cycle,D);  	
   cycle = cycle + 1;
 } //End while for Consensus or Stripe states
  tiempo_final=clock();
  segundos = (double)(tiempo_final - tiempo_inicio) / CLOCKS_PER_SEC;
  fprintf(fp,"%d \t %0.2f \t %d \t %d \t %d \t %d \t %d \t %f\n",simulation,c1,aa,b,c,cycle,D, segundos);

  //printf("N \t Ai \t Bi \t Ci \n");
  //printf("%d \t %d \t %d \t %d -> \n",N,aa,b,c);
  if(simulation == strtol(argv[1], NULL, 10))
  	printf("Sim. \t c1 \t Af \t Bf \t Cf \t Cyles \t D \t Tiempo(segs)\n");
  printf("%d \t %0.2f \t %d \t %d \t %d \t %d \t %d \t %f\n",simulation,c1,aa,b,c,cycle,D,segundos);   
  simulation = simulation - 1;
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																												
} //End while number of simulation

//fclose(fq); 																																																																	fclose(fp);//Review adding entries no creating a new file
  return 0;
} //End main
