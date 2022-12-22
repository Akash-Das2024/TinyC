int printInt(int num);
int printStr(char * str);
int readInt(int *num);
// sum of first n positive numbers
int main()
{
    int i = 0;
    int sum = 0;
    while(i < 11)
    {
        sum = sum + i;
        i++;
    }
    printInt(sum);
    return 0;
}