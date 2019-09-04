include("./reservoir_power_plant.jl")
include("./Periodes.jl")
include("./Reservoirs.jl")
include("./EvaluationFonction.jl")
include("./ANC.jl")
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
#anc gestion
scenarioDate=2011
anc_RLM=getAnc("BND",scenarioDate)
anc_RPD=getAnc("CCP",scenarioDate)
anc_RCD=getAnc("CCD",scenarioDate)
anc=[anc_RLM,anc_RPD,anc_RCD]
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
function production(x::JuMP.NonlinearExpression,v::Variable, p::power_plant, period::Int, model)
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
        push!(expressions,(production(@NLexpression(model,x[i,p]),volume_reservoirs[i,p],power_plants[i],periods[p].date,model)))
    end
    #respecting plants load
    @NLconstraint(model, sum(
    expressions[i] for i in 1:size(power_plants)[1])*86.400+buyings[p]-sales[p]==periods[p].plants_load)
    #respecting minimal and maximal production rates
    @NLconstraint(model, sum(
    periods[p].minimal_production/3 <= expressions[i] for i in 1:size(power_plants)[1])*86.400 <=periods[p].maximal_production/3)

end
#Initialisation of reservoirs volumes
#@constraint(model,[i=1:size(reservoirs)[1]],volume_reservoirs[i,1]==reservoirs[i].level_over_periods[periods[1].date])
@constraint(model,volume_reservoirs[1,1]==2800.0)
@constraint(model,volume_reservoirs[2,1]==4900.0)
@constraint(model,volume_reservoirs[3,1]==400.0)
JuMP.fix(volume_reservoirs[1,1], 2800)
JuMP.fix(volume_reservoirs[2,1], 4900)
JuMP.fix(volume_reservoirs[3,1], 400)
JuMP.fix(volume_reservoirs[1,106], 2000)
JuMP.fix(volume_reservoirs[2,106], 3500)
JuMP.fix(volume_reservoirs[3,106], 300)

#Water balance
volume = ()
for p in 1:size(periods)[1]-1
    @constraint(model,[r=2:size(reservoirs)[1]], volume_reservoirs[r,p+1]==volume_reservoirs[r,p]-x[r,p]*(0.086400)-y[r,p]*(0.086400)+x[r-1,p]*(0.086400)+y[r-1,p]*(0.086400)+anc[r][p]*(0.086400))
    @constraint(model,[r=1], volume_reservoirs[r,p+1]==volume_reservoirs[r,p]-x[r,p]*(0.086400)-y[r,p]*(0.086400)+anc[r][p]*(0.086400))
end


nlp = MathProgNLPModel(model)
results=ipopt(nlp,max_iter=6000)
