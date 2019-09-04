
using StringEncodings

struct ANC
    date::Int
    VariableHydrologique::Float64
    ancs::Vector{Float64}
end



function read_anc(path::String)

    anc = Dict{Int, Vector{ANC}}()
    open(path,enc"WINDOWS-1252") do file
        for ln in eachline(file)
            if(occursin(r"^\d",ln))
                line=split(ln)
                date=parse(Int,popfirst!(line))
                scenario=parse(Int,popfirst!(line))
                VariableHydrologique=parse(Float64,pop!(line))
                apports=Vector{Float64}()
                for number in line
                    push!(apports,parse(Float64,number))
                end
                sc=ANC(date,VariableHydrologique,apports)
                if(!haskey(anc,scenario))
                    anc[scenario]=Vector{ANC}()
                end
                push!(anc[scenario],sc)
            end
        end
    end
    return anc
end

function getAnc(centralName::String,scenario::Int)
    ancs=Vector{Float64}()
    if centralName=="BND"
        index = 1
    elseif centralName=="CCP"
        index = 2
    elseif centralName=="CCD"
        index = 3
    elseif centralName=="CCS"
        index = 4
    elseif centralName=="GORGE"
        index = 5
    elseif centralName=="CMP.MAN"
        index = 6
    else
        index = -1
    end
    allanc=read_anc("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_dynamiques/anc.txt")
    for i in allanc[scenario]
        push!(ancs,i.ancs[index])
    end
    return ancs
end
