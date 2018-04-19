#include <iostream>
#include <string>
#include <fstream>
#include <cstdlib>
#include <iomanip>

using namespace std;

void setplace(int,int);


int _and, _or, add, sub, slt, andcount, orcount, addcount;
int subcount, sltcount, total_time, total_count;
double orave, addave, subave, sltave, total_ave;


int main(){

   _and = 0;
   _or = 0;
   add = 0;
   sub = 0;
   slt = 0;
   andcount = 0;
   orcount = 0;
   addcount = 0;
   subcount = 0;
   sltcount = 0;
   total_time = 0;
   total_count = 0;
   total_ave = 0;
   double andave;
   const char* const FileName = "random_data.txt";
   ifstream in(FileName);

   if(!in){
      cerr << "Could not open file." << endl;
      return 0;
 } else {
      cout << "random_data.txt has been opened" << endl;
   }

   string line;
   getline(in,line);

   int i, num, test, op, max;
   i = 0;
   test = 0;

   while(!in.eof()){

      if(i==0){

         in >> num; //take in number
//         cout << "Number is: " << num << endl;
         if(num%200 != 0){// if it is not a time reset
            max = num%200;    // time is set
//            cout << max << endl;

       } else {

            if(test){
               setplace(max, op);
//               cout << "max: " <<  max << endl;  
               max = 0;
	    }
         }
      }

      test = 1;   // we have passed the first line

      if(i==1){
         in >> line;
      }
      if(i==2){
         in >> op;
//         cout << op << endl;
      }

      i++;

      if(i==3){
         getline(in,line);
         i=0;
      }
   }

   andave = (double)_and/andcount;
   orave = (double)_or/orcount;
   addave = (double)add/addcount;
   subave = (double)sub/subcount;
   sltave = (double)slt/sltcount;
   total_ave = (double)total_time/total_count;
   cout << setprecision(4) << fixed;
   cout << "_and/andcount = " << _and << "/" << andcount << " = " << andave << endl;
   cout << "_or/orcount = " << _or << "/" << orcount << " = " << orave << endl;;
   cout << "add/addcount = " << add << "/" << addcount << " = " << addave << endl;
   cout << "sub/subcount = " << sub << "/" << subcount << " = " << subave << endl;
   cout << "slt/sltcount = " << slt << "/" << sltcount << " = " << sltave << endl;
   cout << "Total Ave: " << total_ave << endl;

   in.close();
   return 0;
}//end

void setplace(int max, int op){

   switch(op){

   case 0: {
      if(max != 0)
         andcount++;
      _and = _and + max;
      break;
   }
   case 1: {
      if(max != 0)
         orcount++;
      _or = _or + max;
      break;
   }
   case 2: {
      if(max != 0)
         addcount++;
      add = add + max;
      break;
   }
   case 3: {
      if(max != 0)
         sltcount++;
      slt = slt + max;
      break;
   }
   case 6: {
      if(max != 0)
         subcount++;
      sub = sub + max;
      break;
   }
   }
   total_time = total_time + max;
   if(max != 0)
      total_count++;
}
