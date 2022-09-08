#include <iostream>
#include <math.h>

// Kernel function to add the elements of two arrays
__global__
void add(int n, float *x, float *y)
{
    for (int i = 0; i < n; i++)
        y[i] = x[i] + y[i];
}

int main(int argc, char* argv[])
{
    if(argc < 2) 
    {
        std::cerr << "Insert the size\n";
        return 1;
    }

    int N = std::stoi(argv[1]);
    float *h_x, *h_y;

    h_x = new float[N];
    h_y = new float[N];

    // initialize x and y arrays on the host
    for (int i = 0; i < N; i++) {
        h_x[i] = 1.0f;
        h_y[i] = 2.0f;
    }

    float *x, *y; 
    cudaMalloc(&x, N*sizeof(float));
    cudaMalloc(&y, N*sizeof(float));

    cudaMemcpy(x, h_x, N*sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(y, h_y, N*sizeof(float), cudaMemcpyHostToDevice);

    // Allocate Unified Memory – accessible from CPU or GPU
    // cudaMallocManaged(&x, N*sizeof(float));
    // cudaMallocManaged(&y, N*sizeof(float));

    // // Run kernel on 1M elements on the GPU
    add<<<1, 1>>>(N, x, y);

    // // Wait for GPU to finish before accessing on host
    cudaDeviceSynchronize();

    cudaMemcpy(x, h_x, N*sizeof(float), cudaMemcpyDeviceToHost);
    cudaMemcpy(y, h_y, N*sizeof(float), cudaMemcpyDeviceToHost);

    // Check for errors (all values should be 3.0f)
    float maxError = 0.0f;
    for (int i = 0; i < N; i++)
        maxError = fmax(maxError, fabs(h_y[i]-3.0f));
    std::cout << "Max error: " << maxError << std::endl;

    // Free memory
    delete[] h_x;
    delete[] h_y;
    cudaFree(x);
    cudaFree(y);

    return 0;
}