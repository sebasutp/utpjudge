#include<iostream>
#include<pthread.h>
#include<cstdio>
#include <time.h>
 
void sleep(unsigned int mseconds)
{
    clock_t goal = mseconds + clock();
    while (goal > clock());
}

int main(){
  sleep(20000000);
  printf("ya!\n");
  return 0;
}


