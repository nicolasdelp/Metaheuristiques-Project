# --------------------------------------------------------
#       Modélisation du Set Packing Problem en JuMP
# --------------------------------------------------------
# Auteurs : Khedaoudj HALIMI, Juanfer MERCIER

using JuMP

# Paramètres
#   solveur : le solveur choisie pour traiter le problème
#   C : le vecteur des poids des variables
#   A : la matrice des données du problème
#
# Valeur de retour
#   couple (spp, x) avec spp le modèle du problème et x le vecteur
#   des variables
function modelSPP(solveur, C, A)
    m, n = size(A) # dimensions de la matrice A

    # Création du modèle
    spp = Model()

    # Attribution du solveur
    if !isnothing(solveur)
        set_optimizer(spp, solveur)
    end
    
    # Définition des variables
    @variable(spp, x[1:n], Bin)

    # Définition de l'objectif (la somme des ci*xi correspond 
    # au produit scalaire du vecteur C et du vecteur X)
    @objective(spp, Max, dot(C, x))

    # Définition des contraintes
    @constraint(spp, ctes[i=1:m], sum(A[i,j] * x[j] for j=1:n) <= 1)

    return spp, x
end
