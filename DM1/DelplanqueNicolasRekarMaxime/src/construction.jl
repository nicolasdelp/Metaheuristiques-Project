function GreedyConstruction(C, A)
    #Premiere étape : calculer les ratios
    ratios = zeros(1,size(A)[2])
    ratios = calculRatios(C,A)

    #Deuxième étape : ajouter les premiers éléments 1 à 1 tant que isPossible()
    x = zeros(1,size(A)[2])
    # println("Ratios = ", ratios)
    # println("size A = ", size(A)," size X = ", size(x))
    for i in ratios 
        x[i]=1
        if(!isPossible(A,x))
            x[i]=0
        end
    end
    println(x)
    isPossible(A, x)

    #Troisième étape : calculer la fonction objectif obetnue
    zInit = calculZ(C,x)

    #Return
    return x, zInit
end