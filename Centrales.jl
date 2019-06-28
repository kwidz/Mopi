#this file is retrieving all informations about hydroelectric Plants from Rio Tinto
#Saguenay lac st jean system
#TODO verify charset ISO8859-1 or windows 1252 because it generates problems
#with accents

#example reservoir("ccd", true, Float16(1.0), 2, [1.3, 1.4, 1.456])

#regex to match all centrals datas at once

# ---\s*\*{3}([\s\S]*?)#\s\*{3}

struct Centrale
    name::String
    paired_reservoir::String
#hourly variation rate  in m3 per hour
    installed_capacity::Bool
    gorge_model::Bool
    minimum_spillway_flow::Float64
    #=
        Mathematical functions types :
        1 quadratic f(x) = c1*x^2 + c2*x + c3
        2 cubic f(x) = c1*x^3 + c2*x^2 + c3*x + c4
        3 polynomial f(x) = c1*x^4 + c2*x^3 + c3*x^2 + c4*x + c5
        4 Exponential f(x) = c1*x^c2+c3
        5 Exponential f(x) = c1*exp(c2*x) + c3*exp(c4*x)
    =#
    #Evaluation function of a reservoir's level in function of its volume
    function_type::Int8
    coefficients::Array{Float64}
end
