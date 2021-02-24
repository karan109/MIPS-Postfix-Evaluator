/*input
1001
*/

// Input an odd integer denoting length of postfix string
#include <iostream>
#include <vector>
#include <stack>
#include <fstream>

using namespace std;
typedef long long ll;
char get(int x)
{
	if (x == 0)
		return '*';
	if (x == 1)
		return '+';
	else
		return '-';
}

string getInfix(string exp)
{
	stack<string> s;
	//cout << exp;

	for (int i = 0; i < exp.length(); i++)
	{
		//	cout << exp[i];
		if (exp[i] != '+' && exp[i] != '-' && exp[i] != '*')
		{
			string op(1, exp[i]);
			s.push(op);
		}
		else
		{
			string op1 = s.top();
			s.pop();
			string op2 = s.top();
			s.pop();
			s.push("(" + op2 + exp[i] + op1 + ")");
		}
	}
	return s.top();
}

int main()
{
	cout << "Enter odd number" << endl;
	int n;
	cin >> n;
	if (n % 2 == 0)
	{
		cout << "Enter odd number" << endl;
		return 0;
	}
	srand(0);
	vector<int> nums(n / 2 + 1);
	vector<int> op_ct(n / 2);
	int ct = 0;
	while (ct < n / 2)
	{
		int x = rand() % (n / 2);
		int sum = 0;
		op_ct[x]++;
		ct++;
		for (int i = 0; i < n / 2; i++)
		{
			sum += op_ct[i];
			if (sum > i + 1)
			{
				op_ct[x]--;
				ct--;
				break;
			}
		}
	}
	for (int i = 0; i < n / 2 + 1; i++)
	{
		nums[i] = rand() % 10;
	}
	string ans = "";
	ans += (char)(nums[0] + '0');
	ans += (char)(nums[1] + '0');
	for (int i = 0; i < op_ct[0]; i++)
		ans += get(rand() % 3);
	for (int i = 1; i < n / 2; i++)
	{
		ans += (char)(nums[i + 1] + '0');
		for (int j = 0; j < op_ct[i]; j++)
			ans += get(rand() % 3);
	}
	string infix = getInfix(ans);
	string postfix = ans;

	cout << "Random Infix: " << infix << endl;
	cout << "Random Postfix: " << postfix << endl;

	stack<int> s;
	int temp = -1;
	for (int i = 0; i < n; i++)
	{
		if (ans[i] - '0' < 10 and ans[i] - '0' >= 0)
		{
			s.push(ans[i] - '0');
		}
		else if (ans[i] == '*')
		{
			int x = s.top();
			s.pop();
			int y = s.top();
			s.pop();
			if ((ll)x * y > pow(2, 31) - 1 or (ll) x * y < -pow(2, 31))
			{
				cout << temp << endl;
				return 0;
			}
			s.push(x * y);
		}
		else if (ans[i] == '+')
		{
			int x = s.top();
			s.pop();
			int y = s.top();
			s.pop();
			if ((ll)x + y > pow(2, 31) - 1)
			{
				cout << temp << endl;
				return 0;
			}
			s.push(x + y);
		}
		else
		{
			int x = s.top();
			s.pop();
			int y = s.top();
			s.pop();
			if ((ll)y - x < -pow(2, 31))
			{
				cout << temp << endl;
				return 0;
			}
			s.push(y - x);
		}
	}
	temp = s.top();
	cout << "Answer: " << temp << endl;

	ofstream myfile;
	myfile.open("cases/case_" + to_string(n) + ".txt");
	myfile << "Infix: " << infix << endl
		   << endl;
	myfile << "Postfix: " << postfix << endl
		   << endl;
	myfile << "Answer: " << temp << endl;
	myfile.close();

	return 0;
}