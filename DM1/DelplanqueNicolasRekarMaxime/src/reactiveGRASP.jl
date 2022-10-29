function reactiveGRASP(C,A,io)
    
    t1 = 0.0 ; t2 = 0.0 ; zInit = 0 ; zBest = 0 ; zWorst = 0 ; zSum = 0
    
    # tableaux des alphas, de leur probabilité et des moyennes pour chaque alpha
    alphas = [0.2,0.4,0.6,0.8,1]
    pK = [0.2,0.2,0.2,0.2,0.2]

    # valeur à configurer, 
    # n contrôle le nb d'itérations à effectuer avant adaptation
    # nAdapt contrôle le nb d'adaptation à effectuer
    n = 10
    nAdapt = 3

    for i in 1:nAdapt
        for j in 1:n
            random = rand()
            posAlpha = 1
            while(rand<=0)         
                random = random - pK[j]
                if(rand>0)
                    posAlpha = posAlpha +1
                end
            end
            
            t1 = @elapsed x, zConstr = greedyRandomizer(alphas[posAlpha] ,C, A,io)
            t2 = @elapsed xBetter, zBetter = greedyImprovement(C, A, x, zInit, io)
            if (zBetter > zBest)
                zBest = zBetter
            end
        end

        # adaptation des probabilité

    end
    greedyRandomizer(C,A,io)
    greedyImprovement(C,A,io)
end