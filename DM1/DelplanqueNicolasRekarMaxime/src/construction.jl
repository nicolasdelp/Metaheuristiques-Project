#=
    Construction de notre première solution x_0 en utilisant l'algorithme glouton
    @C : la fonction objectif
    @A : la matrice des contraintes
    -----
    @return x notre première solution x_0
    @return zInit la valeur de z calculé à partir de notre x_0 trouvé
=#
function greedyConstruction(C, A)
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
    #println(x)
    isPossible(A, x)

    #Troisième étape : calculer la fonction objectif obetnue
    zInit = calculZ(C,x)

    return x, zInit
end