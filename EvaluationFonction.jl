
#this function returns a power produced by the central
#the polynomial function for this is 5 degree polynomial in x and 3 degree in y
#x is the maximal flow rate
#y is the reservoir volume
# coefficents is a table of all coefficients of the polynomial function
function EvaluatePolynomial(x::Float64,y::Float64,c::Array{Float64})
    xx=x*x
    yy=y*y
       return        coefficients[1]+
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
          xx*xx*x*c[15];
end

function evalf(u::Float64 , h::Float64, c::Array{Float64})
        uu = u*u;
        hh = h*h;
        return        c[1]+
                  h*c[2]+
                  u*c[3]+
                 hh*c[4]+
                u*h*c[5]+
                 uu*c[6]+
               hh*u*c[7]+
              h*uu*c[8]+
               uu*u*c[9]+
              hh*uu*c[10]+
            h*uu*u*c[11]+
             uu*uu*c[12]+
           hh*uu*u*c[13]+
           uu*uu*h*c[14]+
           uu*uu*u*c[15];
end

#Coorrdonnees X = 9.864019393921e+00 3.291804122925e+01 5.676037216187e+01 8.132427215576e+01 1.068826217651e+02 1.334395294189e+02 1.606902313232e+02 1.883694152832e+02 2.166454162598e+02 2.462163696289e+02 2.783308105469e+02 3.146967468262e+02 3.566638793945e+02 4.033453674316e+02 4.526469421387e+02
#Coorrdonnees Y = 7.304953613281e+02 7.402666015625e+02 7.499108276367e+02 7.594323120117e+02 7.687830810547e+02 7.777864379883e+02 7.860333862305e+02 7.941123046875e+02 8.020615844727e+02 8.083847656250e+02 8.143433837891e+02 8.203445434570e+02 8.248853759766e+02 8.288340454102e+02 8.326074218750e+02
coefficients=Float64[parse(Float64,"-2.972856691127e+01"),
parse(Float64,"-3.700460658954e-02"),
parse(Float64,"6.259416475446e-01"),
parse(Float64,"2.352939211576e-05"),
parse(Float64,"6.568380606813e-04"),
parse(Float64,"-1.967452112523e-03"),
parse(Float64,"-4.190789055944e-07"),
parse(Float64,"-1.214814187716e-06"),
parse(Float64,"4.248811149257e-06"),
parse(Float64,"7.256088853231e-10"),
parse(Float64,"1.395232167266e-09"),
parse(Float64,"-4.159255812171e-09"),
parse(Float64,"-6.285625690146e-13"),
parse(Float64,"-4.391776902022e-13"),
parse(Float64,"1.420865148004e-12") ]
println(EvaluatePolynomial(7.402666015625e+02, 3.291804122925e+01, coefficients ))
