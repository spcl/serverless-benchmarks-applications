
#include <chrono>
#include <fstream>
#include <vector>
#include <sys/time.h>
#include <unistd.h>

#include <mpi.h>

#include "mmm.h"

int main(int argc, char ** argv)
{
  MPI_Init(&argc, &argv);

  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  struct timeval tv1, tv2;
  struct timezone tz;
  int size = atol(argv[1]);
  int reps = atol(argv[2]);
  std::string outfile{argv[3]};

  std::vector<double> A, B, C, C_local;
  A.resize(size*size);
  B.resize(size*size);
  C.resize(size*size);
  C_local.resize(size*size);
  for(int i = 0; i < size; i++)
  {
    for(int j = 0; j < size; j++)
    {
        A[i*size + j] = i + 1;
        B[i*size + j] = j + 2;
    }
  }

  std::vector<int> times;
  times.reserve(reps);
  printf("Multiply matrices of size %d and %d times...\n", size, reps);
  gettimeofday(&tv1, &tz);
  for (int i = 0; i < reps; i++)
  {
    memset(C.data(), 0, sizeof(double) * size * size);
    auto b = std::chrono::high_resolution_clock::now();
    // Version with split
    mmm(size, A.data(), B.data(), C.data());
    auto e = std::chrono::high_resolution_clock::now();
    times.emplace_back( std::chrono::duration_cast<std::chrono::nanoseconds>(e - b).count() );
  }
  gettimeofday(&tv2, &tz);
  double elapsed = (double) (tv2.tv_sec-tv1.tv_sec) + (double) (tv2.tv_usec-tv1.tv_usec) * 1.e-6;
  printf("Time = %lf [ms] \n", elapsed/reps*1000);

  std::ofstream out(outfile + "_" + std::to_string(rank));
  out << "repetition\n";
  for(int t : times)
    out << t << '\n';
  out.close();

  MPI_Finalize();
}
