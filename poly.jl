function poly(x::Float64,y::Float64,c::Array{Float64})
    xx=x*x
    yy=y*y
       return        (c[1]+
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
println(poly(7.402666015625e+02, 3.291804122925e+01, coefficients ))
