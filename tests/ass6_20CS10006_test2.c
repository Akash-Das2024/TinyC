int printInt(int num);
int printStr(char * str);
int readInt(int *num);

int GCD(int a,int b)
{
    while(a != 0)
    {
        if(a >= b) a = a - b;
        else b = b - a;
    }
    return b;
}
int main()
{
    int a;
    int b;
    printStr("Enter two number\n");
    readInt(&a);
    readInt(&b);
    int gcd = GCD(a,b);
    printStr("GCD: ");
    printInt(gcd);
    return 0;
}