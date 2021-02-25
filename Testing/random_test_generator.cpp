/*input
1001
*/
// Input an odd integer denoting length of postfix string
# include <bits/stdc++.h>
using namespace std;
typedef long long ll;
char get(int x){
	if(x<=1) return '*';
	if(x<=5) return '+';
	else return '-';
}

string exec(string command) {
   char buffer[128];
   string result = "";

   // Open pipe to file
   FILE* pipe = popen(command.c_str(), "r");
   if (!pipe) {
      return "popen failed!";
   }

   // read till end of process:
   while (!feof(pipe)) {

      // use buffer to read and add to result
      if (fgets(buffer, 128, pipe) != NULL)
         result += buffer;
   }

   pclose(pipe);
   return result;
}

int main(){
	fstream of;
	of.open("RandomCases.txt", ios::out);
	int case_ct = 0;
	for(int i=0;i<100;i++){
		int n = rand()%500;
		if(n%2==0) n++;
		srand(time(0));
		vector<int> nums(n/2+1);
		vector<int> op_ct(n/2);
		int ct = 0;
		while(ct<n/2){
			int x = rand()%(n/2);
			int sum = 0;
			op_ct[x]++;
			ct++;
			for(int i=0;i<n/2;i++){
				sum += op_ct[i];
				if(sum > i+1){
					op_ct[x]--;
					ct--;
					break;
				}
			}
		}
		for(int i=0;i<n/2+1;i++){
			nums[i] = rand()%10;
		}
		string ans = "";
		ans += (char)(nums[0]+'0');
		ans += (char)(nums[1]+'0');
		for(int i=0;i<op_ct[0];i++) ans += get(rand()%10);
		for(int i=1;i<n/2;i++){
			ans += (char)(nums[i+1]+'0');
			for(int j=0;j<op_ct[i];j++) ans += get(rand()%10);
		}
		stack<int> s;
		int temp = -1;
		int check = 0;
		// ans = "19-";
		for(int i=0;i<ans.size();i++){
			if(ans[i]-'0'<10 and ans[i]-'0'>=0){
				s.push(ans[i]-'0');
			}
			else if(ans[i] == '*'){
				int x = s.top();
				s.pop();
				int y = s.top();
				s.pop();
				if((ll)x*y > pow(2, 31)-1 or (ll)x*y < -pow(2, 31)){
					check = -1;
					break;
				}
				s.push(x*y);
			}
			else if(ans[i] == '+'){
				int x = s.top();
				s.pop();
				int y = s.top();
				s.pop();
				if((ll)x+y > pow(2, 31)-1){
					check = -1;
					break;
				}
				s.push(x+y);
			}
			else{
				int x = s.top();
				s.pop();
				int y = s.top();
				s.pop();
				if((ll)y-x < -pow(2, 31)){
					check = -1;
					break;
				}
				s.push(y-x);
			}
		}
		if(check == -1) continue;
		temp = s.top();
		fstream f("input.txt", ios::out);
		f<<ans;
		f.close();
		string res = exec("spim -file ../evaluator.asm < input.txt");
		size_t found = res.find("Answer: ");
		string mips_result = "";
		for(int i=found+8;i<res.size();i++){
			if((res[i]>='0' and res[i]<='9') or res[i] == '-'){
				mips_result += res[i];
			}
		}
		int final_result = stoi(mips_result);
		if(final_result != temp){
			cout<<"Error in "<<ans<<endl;
			cout<<"MIPS Answer: "<<final_result<<endl;
			cout<<"C++ Answer: "<<temp<<endl<<endl;
			return 0;
		}
		of<<"Test Case #"<<(++case_ct)<<endl;
		of<<"Input: "<<ans<<endl;
		of<<"MIPS Answer: "<<final_result<<endl;
		of<<"C++ Answer: "<<temp<<endl<<endl;
	}
	of.close();
	return 0;
}