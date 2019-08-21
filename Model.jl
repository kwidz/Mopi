using NLPModels, NLPModelsIpopt
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