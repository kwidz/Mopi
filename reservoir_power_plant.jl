using StringEncodings
struct reservoir_power_plant
    period::Int
    minimal_outflow::Float16
    coefficients::Array{Float64}
end

function read_reservoir_power_plant(path::String)
    plant_over_periods=Dict{Int,reservoir_power_plant}()
    nextLineIsCoefficients=false
    coefficients=Float64[]
    minimal_outflow=0.0
    period=0
    open(path,enc"WINDOWS-1252") do file
        for ln in eachline(file)
            if(nextLineIsCoefficients)
                splitedLine=split(ln)
                for (index, value) in enumerate(splitedLine)
                    push!(coefficients, parse(Float64, value))
                end
                plant_over_periods[period]=reservoir_power_plant(period,minimal_outflow,coefficients)
                coefficients=Float64[]
                minimal_outflow=0.0
                period=0
                nextLineIsCoefficients=false
            else
                if(occursin(r" Periode",ln))
                    splitedLine=split(ln,"= ")
                    period=parse(Int,splitedLine[2])

                end
                if(occursin(r" Debit minimum",ln))
                    splitedLine=split(ln,"= ")
                    minimal_outflow=parse(Float64,splitedLine[2])

                end
                if(occursin(r" Type de surface",ln))
                    nextLineIsCoefficients=true
                end
            end
        end
    end
    return plant_over_periods
end

#read_file("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_dynamiques/CCP.cmc.txt")
#println(read_file("C:/Users/geoffrey.glangine/Desktop/Projet Doctorat/20171129T0952-CEQMT/donnees_dynamiques/CCD.cmc.txt"))
