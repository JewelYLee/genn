
#ifndef TESTPREVARSINSIMCODE_H
#define TESTPREVARSINSIMCODE_H

#define TOTAL_TIME 20.0f
#define REPORT_TIME 1.0f

class EGPInSimCode
{

public:
  EGPInSimCode();
  ~EGPInSimCode();
  void init_neurons();
  void run(int);
};

#endif // SYNDELAYSIM_HPP
