#this function returns a power produced by the central
#the polynomial function for this is 5 degree polynomial in x and 3 degree in y
#x is the flow rate
#y is the reservoir volume
# coefficents is a table of all coefficients of the polynomial function
using JuMP
function EvaluatePolynomial(x::JuMP.NonlinearExpression,y::Variable,c::Array{Float64},model)
    xx=@NLexpression(model,x*x)
    yy=@NLexpression(model,y*y)
       return        @NLexpression(model,c[1]+
                 y*c[2]+
                 x*c[3]+
                yy*c[4]+
               x*y*c[5]+
                xx*c[6]+
              yy*x*c[7]+
             y*xx*c[8]+
              xx*x*c[9]+
             yy*xx*c[10]+
           y*xx*x*c[11]+
            xx*xx*c[12]+
          yy*xx*x*c[13]+
          xx*xx*y*c[14]+
          xx*xx*x*c[15])
end
