#include <iostream>
using namespace std;


#include <cmath>

int nearestPowerOfTwo(int N) {

    if (N <= 0) {
        return 0;
    }
    
    
    if (N > 128) {
        return 128; 
    }
    
    
    int k = floor(log2(N));
    int lowerPower = pow(2, k);
    
   
    int upperPower = pow(2, k+1);
    
    
    if (N - lowerPower < upperPower - N) {
        return lowerPower;
    } else {
        return upperPower;
    }
}




int logmult(int A, int B){

    int sign1, sign2;
    sign1 = 1;
    sign2 = 1;

    if(A<0){

        sign1 = -1;
        A = -A;
    }
    if(B < 0){
        sign2 = -1;
        B = -B;
    }

    int two_p_k1, two_p_k2;
    two_p_k1 = nearestPowerOfTwo(A);
    two_p_k2 = nearestPowerOfTwo(B);

    // cout<<"Debugg step1 printing powers"<<endl;
    // cout<<two_p_k1<<" "<<two_p_k2<<endl;

    int k1, k2;
    if(two_p_k1 && two_p_k2){
        k1 = (int)log2(two_p_k1);
        k2 = (int)log2(two_p_k2);
    }
    else{
        if(two_p_k1 == 0){
            k1 = 0;
            k2 = (int)log2(two_p_k2);
        }
        else{
            k2 = 0;
            k1 = (int)log2(two_p_k1);
        }
    }

    // cout<<"Debugg step 2 priniting K's"<<endl;
    // cout<<k1<<" "<<k2<<endl;

    int q1,q2;
    q1 = A-two_p_k1;
    q2 = B-two_p_k2;

    // cout<<"Debugg step 3 Printing residue"<<endl;
    // cout<<q1<<" "<<q2<<endl;

    int pp1, pp2;
    pp1 = q1*((int)pow(2,k2));
    pp2 = q2*((int)pow(2,k1));

    // cout<<"Debugg step 4 Printing the parial products"<<endl;
    // cout<<pp1<<" "<<pp2<<endl;

    int dec_out;
    dec_out = (int)(pow(2,k1+k2));

    // cout<<"Debugg step 5 Prinitng the decoder output"<<endl;
    // cout<<dec_out<<endl;

    int product;
    product = dec_out + pp1 + pp2;

    product = sign1*sign2*product;

    return product;


}


int main(){

    int A[] = {5,15,-20,9,50,25,129,0,1,255};
    int B[] = {3,5,-4,-8,-3,6,-65,18,1,255};

    int i;
    int out;
    for (i=0;i<10;i++){

        out = logmult(A[i],B[i]);
        cout<<"The output of testcase "<<A[i]<<" and "<<B[i]<<" and "<<" is "<<out<<endl;

    }

    // int A = 9;
    // int B = -8;
    // int prod;
    // prod = logmult(A,B);
    // cout<<prod<<endl;


    return 0;
}
