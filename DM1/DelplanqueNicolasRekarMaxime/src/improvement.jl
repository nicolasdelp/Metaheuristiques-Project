#=
    Amélioration de notre première solution x_0 en explorant le voisinage en utilisant l'algorithme glouton
    @C : la fonction objectif
    @A : la matrice des contraintes
    @x : notre première solution x_0
    @zInit : la valeur de z calculé à partir de notre x_0 trouvé
=#
function greedyImprovement(C, A, x, zInit, io)
    xBest = copy(x)
    zBest = zInit
    xTest = copy(xBest)
    zTest = zBest
    bool = true

    #On utilise première heuristique 0-1
    zTest = zeroToOne!(C,A,xTest)
    if(zTest > zBest)
        xBest = copy(xTest)
        println("Modification x et zBest")
    else
        println("zeroToOne non efficace")
        xTest = copy(xBest)
    end

    #On utilise seconde heuristique 1-1
    zTest = oneToOne!(C,A,xTest,zInit, io)
    if(zTest > zBest)
        xBest = copy(xTest)
        println("Modification x et zBest")
    else
        println("oneToOne non efficace")
        xTest = copy(xBest)
    end

    #On utilise troisième heuristique 2-1
    zTest = twoToOne!(C,A,xTest,zInit,io)
    if(zTest > zBest)
        xBest = copy(xTest)
        println("Modification x et zBest")
    else
        println("twoToOne non efficace")
        xTest = copy(xBest)
    end

    return xBest, zBest
end