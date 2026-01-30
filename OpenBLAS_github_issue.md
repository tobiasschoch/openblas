# `cblas_dtrmm`: Incorrect result

Dear Maintainers,

I encountered an error of `cblas_dtrmm()`  for openBLAS version 0.3.25-150500.4.5.2. I know that this is an old version. However, I observe the same behavior also on newer versions (e.g., Debian; amd64 0.3.30+ds-3+b1). My attempt to build the current openBLAS version (0.3.31) on x86_64 linux failed with a seg fault.

I give an example below where `cblas_dtrmm()` produces the incorrect result.

Best, Tobias



## Minimal example

Consider the upper triangular matrix

$$
X = \left[\begin{matrix}
	1 & 3\\
	0 & 4
\end{matrix}\right].
$$

We call `cblas_dtrmm()` with $B \leftarrow X$ and $A \leftarrow X$ to compute

$$
B = \alpha \cdot B * \mathrm{op}(A) = \alpha \cdot XX^T
$$

for different values of $\alpha$. We **expect** to see the result:

$$
B = \alpha \cdot \left[\begin{matrix}
	1 & 3\\
	0 & 4
\end{matrix}\right]
\left[\begin{matrix}
	1 & 0\\
	3 & 4
\end{matrix}\right] = \alpha \cdot
\left[\begin{matrix}
	10 & 12\\
	12 & 16
\end{matrix}\right]
$$

However, the call of `cblas_dtrmm()` with $\alpha = 0.5$ gives

$$
\left[\begin{matrix}
	2.5 & 3\\
	3 & 4
\end{matrix}\right] \quad =\text{seems to be} = \quad \alpha^2 \cdot
\left[\begin{matrix}
	10 & 12\\
	12 & 16
\end{matrix}\right],

$$

although it should be
$$
\left[\begin{matrix}
	5 & 6\\
	6 & 8
\end{matrix}\right]= 0.5 \cdot
\left[\begin{matrix}
	10 & 12\\
	12 & 16
\end{matrix}\right].
$$

My hypothesis is that $\alpha$ is pre-multiplied **twice**. The evidence for my hypothesis is only anecdotal (I checked it for a couple of different values of $\alpha$).


## Minimal code example

Compiler: gcc (15.2.0); the compiled object is linked to (either) `/usr/lib64/openblas-pthreads/libopenblas.so` or `/usr/lib64/openblas-default/libopenblas.so`  on openSUSE; see also https://github.com/tobiasschoch/openblas.

```c
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
```

