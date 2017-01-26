#include <functional>
#include <numeric>

// Google test includes
#include "gtest/gtest.h"

// Autogenerated simulation code includess
#include "post_vars_in_post_learn_CODE/definitions.h"

// **NOTE** base-class for simulation tests must be
// included after auto-generated globals are includes
#include "../../utils/simulation_test.h"

//----------------------------------------------------------------------------
// PostVarsInPostLearnSparseTest
//----------------------------------------------------------------------------
// **TODO** most of this fixture could be moved into
// a base class for use by all feature tests
class PostVarsInPostLearnSparseTest : public SimulationTest
{
protected:
  //--------------------------------------------------------------------------
  // SimulationTest virtuals
  //--------------------------------------------------------------------------
  virtual void Init()
  {
    // Initialise neuron parameters
    for (int i = 0; i < 10; i++)
    {
      shiftpre[i] = i * 10.0f;
      shiftpost[i] = i * 10.0f;
    }

    m_TheW[0] = wsyn0;
    m_TheW[1] = wsyn1;
    m_TheW[2] = wsyn2;
    m_TheW[3] = wsyn3;
    m_TheW[4] = wsyn4;
    m_TheW[5] = wsyn5;
    m_TheW[6] = wsyn6;
    m_TheW[7] = wsyn7;
    m_TheW[8] = wsyn8;
    m_TheW[9] = wsyn9;
  }

  //--------------------------------------------------------------------------
  // Protected methods
  //--------------------------------------------------------------------------
  float *GetTheW(unsigned int delay) const
  {
    return m_TheW[delay];
  }


private:
  //--------------------------------------------------------------------------
  // Members
  //--------------------------------------------------------------------------
  float *m_TheW[10];
};

TEST_P(PostVarsInPostLearnSparseTest, AcceptableError)
{
  float err = 0.0f;
  float x[10][100];
  for (int i = 0; i < (int)(20.0f / DT); i++)
  {
    t = i * DT;

    // for each delay
    for (int d = 0; d < 10; d++)
    {
        // for all pre-synaptic neurons
        for (int j = 0; j < 10; j++)
        {
            // for all post-syn neurons
            for (int k = 0; k < 10; k++)
            {
                if ((t > 2.1001) && (fmod(t - 2*DT+5e-5, 2.0f) < 1e-4))
                {
                    x[d][(j * 10) + k] = t-2*DT+10*k;
                }
                else if(i == 0)
                {
                    x[d][(j * 10) + k] = 0.0f;
                }
            }
        }

        // Add error for this time step to total
        err += std::inner_product(&x[d][0], &x[d][100],
                                  GetTheW(d),
                                  0.0,
                                  std::plus<float>(),
                                  [](double a, double b){ return abs(a - b); });
    }

    // Step simulation
    Step();
  }

  // Check total error is less than some tolerance
  EXPECT_LT(err, 2e-2);
}

#ifndef CPU_ONLY
auto simulatorBackends = ::testing::Values(true, false);
#else
auto simulatorBackends = ::testing::Values(false);
#endif

INSTANTIATE_TEST_CASE_P(Backends,
                        PostVarsInPostLearnSparseTest,
                        simulatorBackends);