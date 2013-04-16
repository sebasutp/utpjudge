using namespace std;
#include<algorithm>
#include<iostream>
#include<sstream>
#include<string>
#include<vector>
#include<queue>
#include<stack>
#include<map>
#include<set>
#include<bitset>

#include<climits>
#include<cstring>
#include<cstdio>
#include<cmath>

template <class T> string toStr(const T &x)
{ stringstream s; s << x; return s.str(); }

template <class T> int toInt(const T &x)
{ stringstream s; s << x; int r; s >> r; return r; }

#define MPI acos(-1)
#define fr(i,j,n) for(int i=j;i<n;++i)
#define FR(i,n) fr(i,0,n)
#define foreach(x,v) for(typeof (v).begin() x = (v).begin(); x!= (v).end(); x++)
#define all(x) x.begin(),x.end()
#define rall(x) x.rbegin(),x.rend()
#define RI(x) scanf("%d",&x)
#define DRI(x) int x;RI(x)
#define RII(x,y) scanf("%d%d",&x,&y)
#define DRII(x,y) int x,y;RII(x,y)
#define PI(x) printf("%d ",x)
#define PIS(x) printf("%d\n",x)
#define D(x) cout<< #x " = "<<(x)<<endl
#define Dd(x) printf("#x = %lf\n", x)
#define Dbg if(1)
#define PB push_back
#define MK make_pair
#define F first
#define S second

typedef long long ll;
typedef vector<ll> vl;
typedef vector<int> vi;
typedef vector<int,int> vii;
typedef vector<vi> vvi;
typedef pair <int,int> pii;
typedef pair <double,double> pdd;
typedef vector<string> vs;

vs pals;

bool check(string s){
  for(int i=0,j=s.size()-1;i<s.size()/2;i++,j--){
    if(s[i]!=s[j]) return false;
  }
  return true;
}

void gen(){
  FR(i,24){
    FR(j,60){
      string t1 = i < 10 ? "0" : "";
      string t2 = j < 10 ? "0" : "";
      string t = t1 + toStr(i) + ":" + t2 + toStr(j);
      if(check(t)) pals.PB(t);
    }
  }
}

int main(){
  gen();
  
  string line;
  while(cin >> line){

  if(line > "23:32") cout << "00:00" << endl;
  else {
    vs::iterator it = upper_bound(all(pals),line);
    cout << pals[ (it - pals.begin()) ] << endl;
  }
  }
  return 0;
}
