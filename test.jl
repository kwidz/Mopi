using NLPModels, NLPModelsJuMP, JuMP, NLPModelsIpopt

x0 = [-1.2; 1.0]
model = Model() # No solver is required
@variable(model, x[i=1:2], start=x0[i])
@NLobjective(model, Min, (x[1] - 1)^2 + 100 * (x[2] - x[1]^2)^2)
print("done")
nlp = MathProgNLPModel(model)
ipopt(nlp)
print("dodone")
