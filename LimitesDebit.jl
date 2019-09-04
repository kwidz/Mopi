using StringEncodings

struct Day
    date::Int
    plants_load::Float16
    minimal_production::Float16
    maximal_production::Float16
end



function read_limites_debits(path::String)

    limites_debits = Dict{Int, Vector{Float64}}()
    open(path,enc"WINDOWS-1252") do file
        for ln in eachline(file)
            if(occursin(r"^\d",ln))
                line=split(ln)
                date=parse(Int,popfirst!(line))
                limites=Vector{Float64}()
                for number in line
                    push!(limites,parse(Float64,number))
                end
                limites_debits[date]=limites
            end
        end
    end
    return limites_debits
end
println(read_limites_debits("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_dynamiques/limites_debits.txt")[20171129])
