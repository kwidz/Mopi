using StringEncodings

struct Ccp
    period::Int
    minimal_outflow::Float16
    coefficients::Array{Float64}
end
ccpOverPeriods=Dict{Int,Ccp}()

function read_file(path::String)
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
                ccpOverPeriods[period]=Ccp(period,minimal_outflow,coefficients)
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
end

#read_file("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_dynamiques/CCP.cmc.txt")
read_file("C:/Users/geoffrey.glangine/Desktop/Projet Doctorat/20171129T0952-CEQMT/donnees_dynamiques/CCD.cmc.txt")
println(ccpOverPeriods[20171129])
println(ccpOverPeriods[20171229])
println(ccpOverPeriods[20180308])
