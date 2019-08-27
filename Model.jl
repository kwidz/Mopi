include("./reservoir_power_plant.jl")
include("./Periodes.jl")
include("./Reservoirs.jl")
include("./EvaluationFonction.jl")
using StringEncodings, NLPModels, NLPModelsJuMP, JuMP, Ipopt, NLPModelsIpopt
#TODO utiliser les données statiques de centrales pour compléter
struct power_plant
    name::String
    capacity::Bool
    periods::Dict{Int,reservoir_power_plant}
end

BND=power_plant("BND",false,Dict{Int,reservoir_power_plant}())
#CCP=power_plant("CCP",true,read_reservoir_power_plant("C:/Users/geoffrey.glangine/Desktop/Projet Doctorat/20171129T0952-CEQMT/donnees_dynamiques/CCP.cmc.txt"))
#CCD=power_plant("CCP",true,read_reservoir_power_plant("C:/Users/geoffrey.glangine/Desktop/Projet Doctorat/20171129T0952-CEQMT/donnees_dynamiques/CCD.cmc.txt"))
CCP=power_plant("CCP",true,read_reservoir_power_plant("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_dynamiques/CCP.cmc.txt"))
CCD=power_plant("CCD",true,read_reservoir_power_plant("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_dynamiques/CCD.cmc.txt"))
#Power plant set
power_plants=[BND,CCP,CCD]
ANC_RLM=[86.00, 86.00, 85.00, 84.00, 83.00, 82.00, 81.00, 81.00, 80.00, 79.00, 78.00, 78.00, 77.00, 76.00, 75.00, 75.00, 74.00, 73.00, 72.00, 72.00, 71.00, 70.00, 70.00, 69.00, 68.00, 68.00, 67.00, 66.00, 66.00, 65.00, 64.00, 64.00, 63.00, 62.00, 62.00, 61.00, 61.00, 60.00, 59.00, 59.00, 58.00, 58.00, 57.00, 57.00, 56.00, 56.00, 55.00, 55.00, 54.00, 53.00, 53.00, 52.00, 52.00, 51.00, 51.00, 51.00, 50.00, 50.00, 49.00, 49.00, 48.00, 48.00, 47.00, 47.00, 46.00, 46.00, 46.00, 45.00, 45.00, 44.00, 44.00, 43.00, 43.00, 43.00, 42.00, 42.00, 41.00, 41.00, 41.00, 40.00, 40.00, 40.00, 39.00, 39.00, 38.00, 38.00, 38.00, 37.00, 37.00, 37.00, 36.00, 36.00, 36.00, 35.00, 35.00, 35.00, 34.00, 34.00, 34.00, 34.00, 33.00, 33.00, 33.00, 32.00, 32.00, 32.00]
ANC_RPD=[132.00, 130.00, 127.00, 125.00, 123.00, 121.00, 119.00, 117.00, 116.00, 114.00, 113.00, 112.00, 110.00, 109.00, 108.00, 107.00, 106.00, 105.00, 104.00, 103.00, 102.00, 101.00, 100.00, 99.00, 99.00, 98.00, 97.00, 96.00, 96.00, 95.00, 94.00, 94.00, 93.00, 92.00, 92.00, 91.00, 91.00, 90.00, 90.00, 89.00, 88.00, 88.00, 87.00, 87.00, 86.00, 86.00, 85.00, 85.00, 84.00, 84.00, 83.00, 83.00, 83.00, 82.00, 82.00, 81.00, 81.00, 80.00, 80.00, 80.00, 79.00, 79.00, 78.00, 78.00, 77.00, 77.00, 77.00, 76.00, 76.00, 76.00, 75.00, 75.00, 74.00, 74.00, 74.00, 73.00, 73.00, 73.00, 72.00, 72.00, 77.00, 74.00, 73.00, 72.00, 71.00, 71.00, 70.00, 70.00, 70.00, 69.00, 69.00, 68.00, 68.00, 68.00, 67.00, 67.00, 67.00, 66.00, 66.00, 66.00, 94.00, 91.00, 85.00, 80.00, 77.00, 74.00]
ANC_RCD=[130.00, 126.00, 123.00, 121.00, 125.00, 118.00, 112.00, 108.00, 105.00, 103.00, 101.00, 98.00, 96.00, 94.00, 92.00, 90.00, 97.00, 101.00, 90.00, 86.00, 84.00, 83.00, 81.00, 79.00, 78.00, 76.00, 75.00, 73.00, 72.00, 70.00, 69.00, 68.00, 67.00, 65.00, 64.00, 63.00, 62.00, 61.00, 60.00, 59.00, 58.00, 57.00, 56.00, 55.00, 54.00, 53.00, 52.00, 51.00, 50.00, 49.00, 48.00, 47.00, 47.00, 46.00, 45.00, 44.00, 44.00, 43.00, 42.00, 41.00, 41.00, 40.00, 39.00, 39.00, 38.00, 37.00, 37.00, 36.00, 36.00, 35.00, 35.00, 34.00, 33.00, 33.00, 32.00, 32.00, 31.00, 31.00, 30.00, 30.00, 30.00, 29.00, 29.00, 28.00, 28.00, 27.00, 27.00, 27.00, 26.00, 26.00, 26.00, 25.00, 25.00, 25.00, 25.00, 24.00, 24.00, 24.00, 23.00, 23.00, 23.00, 24.00, 23.00, 22.00, 22.00, 22.00]
ANC=[ANC_RLM,ANC_RPD,ANC_RCD]
#Periods set
#periods=read_periods("C:/Users/geoffrey.glangine/Desktop/Projet Doctorat/20171129T0952-CEQMT/donnees_dynamiques/dates.txt")
periods=read_periods("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_dynamiques/dates.txt")
level_over_periods = Dict{Int, Float64}()
for p in (periods)
    level_over_periods[p.date]=-1.0
end
all_reservoirs = read_reservoirs("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_statiques/reservoirs.txt", level_over_periods)
reservoirs=[all_reservoirs["RLM"],all_reservoirs["RPD"],all_reservoirs["RCD"]]
#at the starting point, RLM is 2800 hm3
reservoirs[1].level_over_periods[periods[1].date]=2800.0
#at the starting point, RPD is 4900 hm3
reservoirs[2].level_over_periods[periods[1].date]=4900.0
#at the starting point, RCD is 400 hm3
reservoirs[3].level_over_periods[periods[1].date]=400.0
#buying price per gigawatt
buying_price=1.0
#selling price per gigawatt
selling_price=0.999900

#println(reservoirs[1].level_over_periods[periods.keys[1]])
#x volume turbiné, volume du réservoir
function production(x::JuMP.NonlinearExpression,v::Float64, p::power_plant, period::Int, model)
    if(p.capacity)
        return EvaluatePolynomial(x,v,p.periods[period].coefficients,model)
    else
        return @NLexpression(model,0*x)
    end
end
model = Model()
#Qunatity of electricity bought in GW
@variable(model, buyings[1:size(periods)[1]] >= 0)
#Qunatity of electricity sold in GW
@variable(model, sales[1:size(periods)[1]] >= 0)
#Turbinated Flow per power_plant in hm3
@variable(model, x[1:size(power_plants)[1],1:size(periods)[1]] >= 0)
#Spillway flow per power_plant in hm3
@variable(model, y[1:size(power_plants)[1],1:size(periods)[1]]>= 0)

@variable(model, volume_reservoirs[1:size(reservoirs)[1],1:size(periods)[1]]>= 0)

#Objective function
#Minimising the sum of Selling GW minus buying GW over the periods
#@objective(model,Min,sum{buyings[p]*buying_price-sales[p]*selling_price,
@objective(model,
Min,
sum(buyings[p]*buying_price - sales[p]*selling_price for p in 1:size(periods)[1])
)
#Constraints
for p in 1:size(periods)[1]
    expressions=Vector{JuMP.NonlinearExpression}()
    for i in 1:size(power_plants)[1]
        push!(expressions,(production(@NLexpression(model,x[i,p]),reservoirs[i].level_over_periods[periods[p].date],power_plants[i],periods[p].date,model)))
    end
    #respecting plants load
@NLconstraint(model, sum(
expressions[i] for i in 1:size(power_plants)[1])*86.400+buyings[p]-sales[p]==periods[p].plants_load)
end
#Initialisation of reservoirs volumes
#@constraint(model,[i=1:size(reservoirs)[1]],volume_reservoirs[i,1]==reservoirs[i].level_over_periods[periods[1].date])
@constraint(model,volume_reservoirs[1,1]==2800.0)
@constraint(model,volume_reservoirs[2,1]==4900.0)
@constraint(model,volume_reservoirs[3,1]==400.0)
#Water balance
for p in 1:size(periods)[1]-1
    @constraint(model,[r=2:size(reservoirs)[1]], volume_reservoirs[r,p+1]==volume_reservoirs[r,p]-x[r,p]*(0.086400)-y[r,p]*(0.086400)+x[r-1,p]*(0.086400)+y[r-1,p]*(0.086400)+ANC[r][p]*(0.086400))
    @constraint(model,[r=1], volume_reservoirs[r,p+1]==volume_reservoirs[r,p]-x[r,p]*(0.086400)-y[r,p]*(0.086400)+ANC[r][p]*(0.086400))
end

nlp = MathProgNLPModel(model)

results=ipopt(nlp)
println("Achats d'électricité")
for i in 1:1166
println(results.solution[i],"   ")
end
