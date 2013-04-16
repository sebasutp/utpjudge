// Problem   The Bottom of a Graph
// Algorithm Strongly Connected Components, Topological Sort, DFS
// Runtime   O(|V|+|E|)
// Author    Walter Guttmann
// Date      26.04.2003

#include <cassert>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

ifstream in("main.IN");

typedef vector<bool> vb;
typedef vector<int> vi;
typedef vector<vi> vvi;
typedef vi::iterator vit;

void dfs_topsort(vvi &adj, vb &used, vi &topsort, int node)
{
  used[node] = true;
  for (vit it = adj[node].begin() ; it != adj[node].end() ; ++it)
    if (!used[*it])
      dfs_topsort(adj, used, topsort, *it);
  topsort.push_back(node);
}

void dfs_scc(vvi &adj, vb &used, vi &scc, int node)
{
  used[node] = true;
  for (vit it = adj[node].begin() ; it != adj[node].end() ; ++it)
    if (!used[*it])
    {
      scc[*it] = scc[node];
      dfs_scc(adj, used, scc, *it);
    }
}

int main()
{
  while (1)
  {
    int v, e;
    in >> v;
    if (v == 0) break;
    assert(1 <= v && v <= 10000);
    vvi adj(v);
    in >> e;
    assert(0 <= e);
    for (int i=0 ; i<e ; i++)
    {
      int from, to;
      in >> from >> to;
      assert(1 <= from && from <= v);
      assert(1 <= to && to <= v);
      adj[from-1].push_back(to-1);
    }
    // Transpose the graph.
    vvi transpose(v);
    for (int i=0 ; i<v ; i++)
      for (vit it = adj[i].begin() ; it != adj[i].end() ; ++it)
        transpose[*it].push_back(i);
    // Sort the nodes in reverse topological order (not a DAG yet).
    vi topsort;
    {
      vb used(v, false);
      for (int i=0 ; i<v ; i++)
        if (!used[i])
          dfs_topsort(adj, used, topsort, i);
      assert((int)topsort.size() == v);
    }
    // Calculate the SCCs.
    vi scc(v);
    {
      vb used(v, false);
      for (int j=v-1 ; j>=0 ; j--)
      {
        int i = topsort[j];
        if (!used[i])
        {
          scc[i] = i;
          dfs_scc(transpose, used, scc, i);
        }
      }
    }
    // Node i represents a strongly connected component if scc[i] == i.
    // The edges between the SCCs in their DAG are not directly available.
    // If an edge leave the SCC, its source is not a sink.
    vb sink(v, true);
    for (int i=0 ; i<v ; i++)
      for (vit it = adj[i].begin() ; it != adj[i].end() ; ++it)
        if (scc[i] != scc[*it])
          sink[scc[i]] = false;
    bool first = true;
    for (int i=0 ; i<v ; i++)
      if (sink[scc[i]])
        if (first)
          first = false, cout << i+1;
        else
          cout << " " << i+1;
    cout << endl;
  }
  return 0;
}

