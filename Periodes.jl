using StringEncodings

struct Day
    date::Int
    plants_load::Float16
    minimal_production::Float16
    maximal_production::Float16
end



function read_periods(path::String)
    periods=Vector{Day}()
    open(path,enc"WINDOWS-1252") do file
        for ln in eachline(file)
            if(!occursin(r"^# \w",ln))
                splitedLine=split(ln)
                date=parse(Int,splitedLine[1])
                plants_load=parse(Float16,splitedLine[2])
                minimal_production=parse(Float16,splitedLine[4])
                maximal_production=parse(Float16,splitedLine[5])
                d=Day(date,plants_load,minimal_production,maximal_production)
                push!(periods,d)
            end
        end
        return periods
    end



end


#read_periods("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_dynamiques/dates.txt")
