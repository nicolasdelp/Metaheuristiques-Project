function reactiveGRASP(C,A,fname,io)
    
    t1 = 0.0 ; t2 = 0.0 ; zInit = 0 ; zBest = 0 ; zWorst = typemax(Int64)
    lZInit = zeros(0)
    lZLs = zeros(0)
    lZMax = zeros(0)
    # tableaux des alphas, de leur probabilité et des moyennes pour chaque alpha
    alphas = [0.2,0.4,0.6,0.8,1]
    pK = [0.2,0.2,0.2,0.2,0.2]    
    # valeur à configurer, 
    # n contrôle le nb d'itérations à effectuer avant adaptation
    # nAdapt contrôle le nb d'adaptation à effectuer
    n = 30
    nAdapt = 3
    pEv = zeros(nAdapt+1,5)
    
    for i in 1:5
        pEv[1,i] = alphas[i]
    end

    # println(io, "__________________________________")
    # println(io, "Initialisation")
    # println(io, "pK = ", pK)
    # println(io, "__________________________________")

    for i in 1:nAdapt
        
        qK = zeros(1,5)
        sumQ = 0.0
        zSumK = [0.0,0.0,0.0,0.0,0.0]
        itK = [0,0,0,0,0]

        for j in 1:n
            random = rand()

            posAlpha = 1
            k = 1
            while(random>=0)         
                random = random - pK[k]
                if(random>0)
                    posAlpha = posAlpha +1
                end
                k = k+1
                # println(io, "--")
                # println(io, "random =", random)
                # println(io, "posAlpha = ",posAlpha)
                # println(io, "--")
            end

            # println(io, "____________")
            # println(io, "after while")
            # println(io, "random =", random)
            # println(io, "posAlpha =", posAlpha)
            t1 = @elapsed x, zConstr = greedyRandomizer(alphas[posAlpha] ,C, A,io)
            t2 = @elapsed xTry, zTry = greedyImprovement(C, A, x, zConstr, io)
            
            #pour plot
            append!(lZInit,zConstr)
            append!(lZLs, zTry)
            if((i*j)==1)
                append!(lZMax,zTry)
            elseif(lZMax[((size(lZMax)[1]))]<zTry)
                append!(lZMax,zTry)
            else
                append!(lZMax,lZMax[(size(lZMax)[1])])
            end

            if (zTry > zBest)
                zBest = zTry
            elseif (zWorst > zTry)
                zWorst = zTry
            end
            zSumK[posAlpha] = zSumK[posAlpha] + zTry
            itK[posAlpha] = itK[posAlpha] + 1

            # println(io, "____________")
            # println(io, "fin iter ",j," n")
            # println(io, "posAlpha =", posAlpha)
            # println(io, "zSumK =", zSumK)
            # println(io, "itK =", itK)
        end

        # adaptation des probabilités

        qK = zeros(1,5)
        sumQ = 0.0
        for j in 1:size(qK)[2]
            qK[j] = ((zSumK[j]/itK[j])-zWorst)/(zBest-zWorst)
            sumQ = sumQ + qK[j]
        end

        for j in 1:size(pK)[1]
            pK[j] = qK[j]/sumQ
        end

        for j in 1:5
            if(j==1)
                pEv[i+1,j] = pK[j]
            else
                pEv[i+1,j] = pEv[i+1,j-1] + pK[j]
            end
        end    
    end
    plotRunGrasp(string("_RGRASP_",fname),lZInit,lZLs,lZMax)
    plotAlphaRGRASP(fname,alphas,pEv)
end