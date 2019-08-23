#this file is retrieving all informations about reservoirs from Rio Tinto
#Saguenay lac st jean system
#TODO verify charset ISO8859-1 or windows 1252 because it generates problems
#with accents

#example reservoir("ccd", true, Float16(1.0), 2, [1.3, 1.4, 1.456])
struct Reservoir
    name::String
    constraint_overrun::Bool
#hourly variation rate  in m3 per hour
    maximum_hourly_variation_rate::Float16
    #=
        Mathematical functions types :
        1
        2 cubic f(x) = c1*x^3 + c2*x^2 + c3*x + c4
        3 polynomial f(x) = c1*x^4 + c2*x^3 + c3*x^2 + c4*x + c5
        4 Exponential f(x) = c1*x^c2+c3
        5
    =#
    #Evaluation function of a reservoir's level in function of its volume
    function_type::Int8
    coefficients::Array{Float64}
end
function poly(x::Float64, c::Array{Float64})
    result = 0.0
    power = size(c)[1]-1
    for coeff in c
        result+=coeff*x^power
        power-=1
    end
    return result
end
function exponential(x::Float64, c::Array{Float64})

    return c[1]*x^c[2]+c[3]
end

function get_level(reservoir::Reservoir, volume)
    if(reservoir.function_type==2)
        return poly(volume,reservoir.coefficients)
    end
    if(reservoir.function_type==3)
        return poly(volume,reservoir.coefficients)
    end
    if(reservoir.function_type==4)
        return exponential(volume,reservoir.coefficients)
    end

    return -1

end


#contains all reservoir in the saguenay lac st jean's system
reservoirs=Dict{String,Reservoir}()
function is_end_of_file(line)
    return occursin(r"FIN DU FICHIER",line)
end
#Function to avoid all comentaries in the config file
function avoid_comments(file)
    line=readline(file)
    while(occursin(r"^# \w",line))
        line=readline(file)
    end
    return line
end

#Return only the value of the line
function get_value_on_line(line)
    return match(r"=\s*(?<value>.*)$",line)[:value]
end

function read_file(path::String)
    open(path) do file
        line = readline(file)
        #checking if the end of file is reached
        while !eof(file)
            while !occursin(r"#\s\*{3}.*\*{3}(.*)",line)
                line = readline(file)
            end
            if(is_end_of_file(line))
                break
            end
            name = get_value_on_line(avoid_comments(file))
            constraint_overrun =
                    parse(Bool,get_value_on_line(avoid_comments(file)))
            maximum_hourly_variation_rate =
                    parse(Float16,get_value_on_line(avoid_comments(file)))
            function_type = parse(Int8,get_value_on_line(avoid_comments(file)))
            line = readline(file)
            coefficients=Float64[]
            while(!occursin(r"#\s\*{3}.*\*{3}(.*)",line))
                push!(coefficients, parse(Float64,get_value_on_line(line)))

                line = readline(file)
            end
            reservoir = Reservoir(name,
                                constraint_overrun,
                                maximum_hourly_variation_rate,
                                function_type,
                                coefficients)
            reservoirs[reservoir.name]=reservoir

        end
    end
end

        #read_file("../20171129T0952-CEQMT/donnees_statiques/reservoirs.txt")
        read_file("C:/Users/geoffrey.glangine/Desktop/Projet Doctorat/20171129T0952-CEQMT/donnees_statiques/reservoirs.txt")

println(reservoirs)
println("###########")
#finding initial level
println(get_level(reservoirs["RLM"],2800.0))
println(get_level(reservoirs["RPD"],4900.0))
println(get_level(reservoirs["RCD"],400.0))
println(get_level(reservoirs["RLSJ"],5000.0))
println(get_level(reservoirs["RIM"],120.0))
