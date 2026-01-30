#include <stdio.h>
#include <cblas.h>

int main()
{
    const int p = 2;
    const double alpha = 0.5;
    double x[] = {1.0, 0.0, 3.0, 4.0};

    cblas_dtrmm(CblasColMajor, CblasRight, CblasUpper, CblasTrans,
                CblasNonUnit, p, p, alpha, x, p, x, p);

    for (int i = 0; i < p; i++) {
        if (i > 0)
            printf("\n");
        for (int j = 0; j < p; j++)
            printf("%.5f\t", x[j + i * p]);
    }
    printf("\n");

    return 0;
}
