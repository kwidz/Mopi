include("./reservoir_power_plant.jl")
using NLPModels, NLPModelsIpopt, reservoir_power_plant
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
CCD=power_plant("CCP",true,read_reservoir_power_plant("/home/kwidz/Doctorat/ProjetRioTinto/20171129T0952-CEQMT/donnees_dynamiques/CCD.cmc.txt"))

#Power plant set
power_plants=[BND,CCP,CCD]
#x volume turbiné, h hauteur du réservoir
function production(x,h)
    return x*h
end
h=[150;150;150]
f(x) = production(x[1],h[1]) + production(x[2],h[2]) + production(x[3],h[3])
x0=[1.0,1.0,1.0]
nlp = ADNLPModel(f, x0,lvar=[0.0,0.0,0.0], uvar=[500.0,200.0,150.0] )
#geting the objective value at fx=x0
fx = obj(nlp, nlp.meta.x0)
println("fx = $fx")
#solving model
stats = ipopt(nlp)
print(stats)
