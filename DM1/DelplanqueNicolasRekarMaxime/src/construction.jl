function GreedyConstruction(C, A)
    #Premiere étape : calculer les ratios
    ratios = zeros(1,size(A)[2])
    #println(size(C))
    ratios = calculRatios(C,A)
    #Seconde étape : trier les ratios en ordre décroissant

    #Troisième étape : ajouter les premiers éléments 1 à 1 tant que isPossible()
    x = zeros(1,size(A)[1])
    isPossible(A, x)
    #Quatrième étape : calculer la fonction objectif obetnue
    zInit = calculZ(C,x)
    println("zInit = ",zInit)

    #Return
    return x,zInit
end