#define ERR 1
#define OK 0
#define BUFF 20

int printStr(char *s)
{
    int i = 0,bytes, flag;
    while(s[i++] != '\0')
    {
        ;
    }
    bytes = i;
    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(flag)
        :"S"(s), "d"(bytes)
    );
    if(flag < 0)
        return ERR;
    else
        return i - 2;
}

int readInt(int *n)
{
    char buff[BUFF] = "",zero = '0';
    int num = 0;
    int i=0,j=0,bytes;
    __asm__ __volatile(
		"movl $0,%%eax \n\t"
		"movq $0, %%rdi \n\t"
		"syscall \n\t"
		:"=a"(bytes)
		:"S"(buff),"d"(BUFF)
		);
    bytes = bytes -  1;
    if(buff[0] == '-')
    {
        j = 1;
        i++;
        if(bytes == 1)
        {
            return ERR;
        }
    }
    while(i < bytes)
    {
        if(buff[i] >= '0' && buff[i] <= '9')
        {
            num = num * 10 + (int)(buff[i] - zero);
            i ++;
        }
        else return ERR;
    }
    if(j == 1)
    {
        num = -num;
    }
    if(bytes < 0)return ERR;
    else
    {
        *n = num;
        return OK;
    }
}

int printInt(int n)
{
    char buff[BUFF], zero = '0';
    int i = 0, j, k, bytes;
    if(n == 0)buff[i++] = zero;
    else
    {
        if(n<0)
        {
            buff[i++] = '-';
            n = -n;
        }
        while(n)
        {
            int dig = n%10;
            buff[i++] = (char)(zero + dig);
            n = n/10;
        }
        if(buff[0] == '-') j = 1;
        else j = 0;
        k = i -1;
        while(j<k)
        {
            char temp = buff[j];
            buff[j++] = buff[k];
            buff[k--] = temp;
        }
    }
    buff[i] = '\n';
    bytes = i + 1;
    int flag;
    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(flag)
        :"S"(buff), "d"(bytes)
    );
    if(flag < 0)
        return ERR;
    else
        return i;
}

int readFlt(float *f)
{
    char buff[BUFF] = "", zero ='0';
    int i = 0,j = 0,k,bytes;
    float num = 0;
    float numF = 0;
    int numI = 0;
    __asm__ __volatile(
		"movl $0,%%eax \n\t"
		"movq $0, %%rdi \n\t"
		"syscall \n\t"
		:"=a"(bytes)
		:"S"(buff),"d"(BUFF)
		);
    bytes = bytes - 1;
    if(buff[0] == '-')
    {
        j = 1;
        i++;
        if(bytes == 1)
        {
            return ERR;
        }
    }
    while(buff[i] != '.' && i < bytes)
    {
        if(buff[i] >= '0' && buff[i] <= '9')
        {
            numI = numI * 10 + (int)(buff[i] - zero);
            i++;
        }
        else return ERR;
    }
    if(buff[i] == '.')
    {
        if(bytes == 1 || (bytes == 2 && j == 1))
        {
            return ERR;
        }
        i++;
        k = 0;
        while(i < bytes)
        {
            if(buff[i] >= '0' && buff[i] <= '9')
            {
                numF = numF * 10 + (int)(buff[i] - zero);
                i++;
                k++;
            }
            else return ERR;
        }
        while(k--)
        {
            numF = numF / 10;
        }
    }
    num = numI + numF;
    if(j == 1)
    {
        num = - num;
    }
    if(bytes < 0)
        return ERR;
    else{
        *f = num;
        return OK;
    }

}

int printFlt(float f)
{
    char buff[BUFF], zero ='0';
    int i = 0,j = 0,k,bytes;
    if(f < 0)
    {
        buff[0] = '-';
        j = 1;
        i ++;
        f = -f;
    }
    int n = (int)f;
    float m = f - n;
    if(n == 0)buff[i++] = zero;
    else
    {
        while(n)
        {
            int dig = n%10;
            buff[i++] = (char)(zero + dig);
            n = n/10;
        }
        k = i -1;
        while(j<k)
        {
            char temp = buff[j];
            buff[j++] = buff[k];
            buff[k--] = temp;
        }
    }
    buff[i++] = '.';
    if(m == 0)
    {
        buff[i++] = '0';
    }
    else
    {
        k = 1;
        while(i < BUFF && k <= 6)
        {
            f = f * 10;
            int n = (int)f;
            int dig = n % 10;
            buff[i++] = (char)(zero + dig);
            if(n == f)break;
            k++;
        }
    }
    buff[i] = '\n';
    bytes = i + 1;
    int flag;
    __asm__ __volatile__(
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :"=a"(flag)
        :"S"(buff), "d"(bytes)
    );
    if(flag < 0)
        return ERR;
    else
        return i;
}