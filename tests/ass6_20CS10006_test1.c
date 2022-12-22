//
// sum of two numbers
// and printing the sum using printInt
//
//

int printInt(int num);
int printStr(char * str);
int readInt(int *num);

int a;
int b;
int main()
{
    int sum;
    a = 5;
    b = 10;
    sum = a + b;
    printStr("The Sum of a = ");
    printInt(a);
    printStr("and b = ");
    printInt(b);
    printStr("is equal to: ");
    printInt(sum);
    return 0;
}