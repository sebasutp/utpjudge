// Author: Christoph Schwirzer
// Algorithm: Kruskal
// Complexity: O(n log n)

#include <cstdio>
#include <vector>
#include <algorithm>
#include <cassert>
#include <climits>
using namespace std;
class union_find
{
	private:
		vector<int> p, r;
	public:
		void init(int n)
		{
			p.resize(n);
			r.assign(n, 0);
			for (int i=0; i<n; i++)
				p[i] = i;
		}
		int find(int k)
		{
			return k == p[k] ? k : (p[k] = find(p[k]));
		}
		int unite(int a, int b)
		{
			a = find(a);
			b = find(b);
			if (a == b)
				return 0;
			if (r[a] > r[b])
				p[b] = a;
			else
			{
				p[a] = b;
				if (r[a] == r[b])
					r[b]++;
			}
			return 1;
		}
};
struct Edge
{
	int x, y, w;
	void read()
	{
		scanf("%d%d%d", &x, &y, &w);
	}
	bool operator<(const Edge &e) const
	{
		return w < e.w;
	}
};
int main()
{
	freopen("main.IN", "r", stdin);
	while (1)
	{
		int n, m;
		scanf("%d%d", &n, &m);
		if (!n && !m)
			break;
		assert(n > 0);
		assert(m >= n-1);
		assert(m <= 200000);
		int res = 0;
		vector<Edge> e(m);
		for (int i=0; i<m; i++)
		{
			e[i].read();
			assert(e[i].x != e[i].y);
			assert(e[i].x >= 0);
			assert(e[i].y >= 0);
			assert(e[i].x < n);
			assert(e[i].y < n);
			assert(e[i].w >= 0);
			assert(INT_MAX - e[i].w >= res);
			res += e[i].w;
		}
		sort(e.begin(), e.end());
		union_find uf;
		uf.init(n);
		int cnt = 0, mst = 0;
		for (int i=0; cnt<n-1 && i<m; i++)
		{
			if (uf.unite(e[i].x, e[i].y))
			{
				res -= e[i].w;
				cnt++;
				mst += e[i].w;
			}
		}
		assert(cnt == n-1);
		printf("%d\n", res);
	}
	return 0;
}
