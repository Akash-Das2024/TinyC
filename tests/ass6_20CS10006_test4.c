int printInt(int num);
int printStr(char * str);
int readInt(int *num);
//
int main()
{
    int n1 = 0, n2 = 1, n3, i ,number;

    printStr("Enter a number upto which you want to evaluate Fibonacci number: ");
    readInt(&number);

    for(i = 2; i < number; i = i + 1)
    {
        n3 = n1 + n2;
        n1 = n2;
        n2 = n3;
        printInt(n3);
        printStr("\n");
    }
    return 0;
}