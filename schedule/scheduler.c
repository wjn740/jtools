#include <stdio.h>
int machines = 3;
unsigned int sum = -1;
unsigned int sum1 = -1;

int i1;
int i2;
int i3;
int i4;
int i5;
int i6;
int i7;
int i8;
int i9;
int i10;
int i11;
int i12;
int i13;
int i14;
int i15;
int i16;
int i17;
int i18;
int i19;
int i20;
int i21;
int i22;
int i23;
int i24;
int i25;
int i26;
int i27;
int i28;
int i29;
int i30;
int i31;
int i32;
int i33;
int i34;
int i35;
int i36;
int i37;
int i38;
int i39;
int i40;
int i41;
int i42;
int i43;
int i44;
int i45;
int i46;
int i47;
int i48;

int oof;
int zto;
int ozff;


int array[][3]={
2231,4048,0,
2473,4391,3415,
2303,4072,3094,
2221,4092,0,
2252,4110,0,
2493,4383,3505,
2293,4082,3263,
2247,4119,0,
4437,4448,4427,
4418,4493,4441,
4417,4431,4421,
4417,4432,4502,
4444,4451,4431,
4418,4421,4420,
4418,4429,4420,
4418,4447,4503,
891,576,999,
205,80,167,
10227,16790,6254,
2415,1394,1395,
2415,2414,1635,
3237,2060,0,
3305,2081,2726,
3190,2064,2555,
3177,2047,0,
3166,5662,0,
2360,2178,9459,
2348,1879,8354,
2452,1886,0,
7046,15648,0,
8294,15606,10562,
8028,15473,10861,
6864,15372,10660,
49,46,78,
2495,5434,1964,
3271,5883,3763,
3141,5563,3763,
2705,5538,3726,
31892,31893,31897,
454,798,3094,
658,809,1972,
647,763,1901,
444,795,2932,
392,327,444,
389,362,442,
379,319,437,
383,316,420,
238,408,271,
};

/* this array store 3 numbers for each machine's worktime*/
int machines_status[3]={0};
int main(int argc,char **argv)
{
    int min=0;
    int _min=0;
    int min_index=0;
    int i,j;
    for (i=0;;i++) {
        if (array[i][0] == 0 && array[i][1] == 0 && array[i][2] == 0) {
            break;
        }
        /*handle each testcase*/
        _min = array[i][min_index]+machines_status[min_index];
        for (j=0;j<3;j++) {
            if (array[i][j] == 0) {
                continue;
            }
            if (_min > array[i][j]+machines_status[j]) {
                _min = array[i][j]+machines_status[j];
                min = array[i][j];
                min_index = j;
            }
        }
        /*store time to corresponding element of array*/
        machines_status[min_index]+=min;

        printf("the line %d's the min is %d\n",i,min_index);
        /*handle each testcase end*/
    }
    printf ("oof:%d, zto:%d, ozff:%d\n", machines_status[0], machines_status[1], machines_status[2]);

    return 0;
}
