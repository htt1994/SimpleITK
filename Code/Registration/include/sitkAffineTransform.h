#ifndef __sitkAffineTransform_h
#define __sitkAffineTransform_h

#include "sitkMacro.h"
#include "sitkDetail.h"
#include "sitkTransform.h"

namespace itk
{
namespace simple
{
class AffineTransform
  : public Transform
  {
  public:
    AffineTransform();
    virtual itk::TransformBase* GetITKBase ( );
    virtual std::vector<double> GetOptimizerScales ( int dimension );
  protected:
    virtual Transform* Clone();
  };
}
}

#endif