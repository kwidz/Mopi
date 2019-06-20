#Ce fichier récupère toutes les informations sur les réservoirs du système
#TODO verifier le charset ISO8859-1 ou windows 1252 car peut générer des
#problèmes avec les accents

#exemple reservoir("ccd", true, Float16(1.0), 2, [1.3, 1.4, 1.456])
struct Reservoir
    nom::String
    depassement_de_contrainte_possible::Bool
#taux de variation horaire en m3 par heure
    taux_de_variation_horaire_maximum::Float16
    #=
        types de fonctions :
        1
        2 cubique f(x) = c1*x^3 + c2*x^2 + c3*x + c4
        3 polynomial f(x) = c1*x^4 + c2*x^3 + c3*x^2 + c4*x + c5
        4 Exponentielle f(x) = c1*x^c2+c3
        5
    =#
    #Fonction d'évaluation du niveau en fonction du volume
    type_de_fonction::Int
    coefficients::Array{Float64}
end


open("../20171129T0952-CEQMT/donnees_statiques/reservoirs.txt") do fichier
    ligne = readline(fichier)
    while !occursin(r"FIN DU FICHIER",ligne)
        if occursin(r"#\s\*{3}.*\*{3}(.*)",ligne)
            println(ligne)
        end
        ligne = readline(fichier)
    end
end
