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

    stop1 = false
    while(!stop1)
        stop1 = true
        stop2 = false
        while(!stop2)
            stop2 = true
            zTest, xTest = twoToOne!(C,A,xBest,zBest,io) #meta 2-1
            if(zTest > zBest) # si on réussit à modifier, on relancera toute la boucle.
                xBest = copy(xTest)
                zBest = zTest
                stop1 = false
                stop2 = false
            else
                xTest = copy(xBest)
                zTest = zBest
            end
        end
        #println(io, "2-1 : zBest = ",zBest)
        #println(io,"xBest = ",xBest)

        #On utilise seconde heuristique 1-1
        stop2 = false
        while(!stop2)
            stop2 = true
            zTest, xTest = oneToOne!(C,A,xBest,zBest, io) # meta 1-1
            if(zTest > zBest)
                xBest = copy(xTest)
                zBest = zTest
                stop1 = false
                stop2 = false
            else
                xTest = copy(xBest)
                zTest = zBest
                
            end
        end
        #println(io, "1-1 : zBest = ",zBest)
        #println(io,"xBest = ",xBest)

        #On utilise première heuristique 0-1
        stop2 = false
        while(!stop2)
            zTest, xTest = zeroToOne!(C,A,xBest,zBest,io)
            stop2 = true

            if(zTest > zBest)
                xBest = copy(xTest)
                zBest = zTest
                stop1 = false
                stop2 = false
            else
                xTest = copy(xBest)
                zTest = zBest
            end
        end

        #println(io, "0-1 : zBest = ",zBest)
        #println(io,"xBest = ",xBest)
    end
    return xBest, zBest
end