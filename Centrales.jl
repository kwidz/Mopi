#this file is retrieving all informations about hydroelectric Plants from Rio Tinto
#Saguenay lac st jean system
#TODO verify charset ISO8859-1 or windows 1252 because it generates problems
#with accents
#regex to match all centrals datas at once

# ---\s*\*{3}([\s\S]*?)#\s\*{3}
using StringEncodings

struct Spillway
    type::Int
    reservoir_influance::Bool
    fixed_capacity::Bool
end

struct Central
    name::String
    paired_reservoir::String
#hourly variation rate  in m3 per hour
    installed_capacity::Bool
    gorge_model::Bool
    minimum_spillway_flow::Float64
    downstream_reservoir_power_influance::Bool
    inflow_constraint_limit::Bool
    spillway::Spillway
    informations_file_name::String
    evacuation_capacity::Int


    #=
        Mathematical functions types :
        1 quadratic f(x) = c1*x^2 + c2*x + c3
        2 cubic f(x) = c1*x^3 + c2*x^2 + c3*x + c4
        3 polynomial f(x) = c1*x^4 + c2*x^3 + c3*x^2 + c4*x + c5
        4 Exponential f(x) = c1*x^c2+c3
        5 Exponential f(x) = c1*exp(c2*x) + c3*exp(c4*x)
    =#
    #Evaluation function of a reservoir's level in function of its volume
    #TODO check if this fuction is a power loss or production function
    function_type::Int8
    coefficients::Array{Float64}
end

centrals = Dict{String,Central}()

function read_file(path::String)
    content = open(path,enc"WINDOWS-1252") do file
        read(file, String)
    end
    println(content)

    centralsParametersTextFile = match(r"---\s*\*{3}([\s\S]*?)#\s\*{3}",content)
    println(centralsParametersTextFile)

end



read_file("../20171129T0952-CEQMT/donnees_statiques/centrales.txt")
