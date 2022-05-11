//#include <stdlib.h>
#include <osbind.h>

int main(int argc, char** argv)
{
        int dummy= Cconws("Hello world!\0");
        dummy = Cconin();
        return 0;
}
