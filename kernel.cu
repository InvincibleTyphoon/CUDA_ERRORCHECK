#include <cstdio>
#include <cuda_runtime.h>

#define SIZE 5

#if defined(NDEBUG) // release mode
#define CUDA_CHECK(x)(x)
#else              //debug mode
#define CUDA_CHECK(X) do{\
    (X);\
    cudaError_t e = cudaGetLastError();\
    if(cudaSuccess != e){\
        printf("cuda failure %s at %s : %d", cudaGetErrorString(e), __FILE__, __LINE__);\
        exit(1);\
    }\
}while(0)
#endif

int main()
{
    int* dev_a;
    int* dev_b;
	const int a[SIZE] = { 1,2,3,4,5 };
	int b[SIZE] = { 1,2,3,4,5 };
    
    //allocate device memory
    CUDA_CHECK(cudaMalloc((void**)&dev_a, SIZE * sizeof(int)));
    CUDA_CHECK(cudaMalloc((void**)&dev_b, SIZE * sizeof(int)));

    //copy from host to device
    //gonna cause error
	CUDA_CHECK(cudaMemcpy(dev_a, a, SIZE * sizeof(int), cudaMemcpyDeviceToDevice));

    //copy from device to host
	CUDA_CHECK(cudaMemcpy(b, dev_b, SIZE * sizeof(int), cudaMemcpyDeviceToHost));

    CUDA_CHECK(cudaFree(dev_a));
    CUDA_CHECK(cudaFree(dev_b));
    return 0;
}	