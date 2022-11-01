#zeroToOne : change 1 variables 0 à 1
function zeroToOne!(C,A,xInit, zInit, io)
    zBest=zInit
    xBest = copy(xInit)
    xTest = copy(xBest)
    zTest = zBest
    for i in 1:size(xInit)[2]
        if(xBest[i] == 0)
            xTest[i] = 1
            if(isPossible(A,xTest))
                zTest = calculZ(C,xTest)
                if(zBest<zTest)
                    zBest = zTest
                    xBest = copy(xTest)
                end
            else
                i = 0
            end
        end
    end
    return zBest, xBest
end

#oneToOne : change 1 variable 1 à 0, et 1 variables 0 à 1
function oneToOne!(C,A,xInit,zInit,io)
    xBest = copy(xInit)
    zBest = zInit
    xTest = copy(xBest)
    zTest = zBest
    for i in 1:size(xInit)[2] #parcours 1er 1
        if (xBest[i]==1)
            xTest[i] = 0
            for j in 1:size(xInit)[2] #parcours des 0
                if (xBest[j] == 0 && j!=i) #vérification que le 0 n'est pas i
                    xTest[j] = 1
                    zTest = calculZ(C,xTest)
                    if(zBest < zTest) # test si le xTest donnerait un meilleur résultat
                        if(isPossible(A,xTest)) # test si xTest est possible
                            xBest = copy(xTest) #sauvegarde de x et z si possible
                            zBest = zTest
                        else
                            xTest[j] = 0 #remise à 0 si impossible
                        end
                    else
                        xTest[j] = 0 #remise à 0 si z est moins interessant
                    end
                end
            end
            if (xBest[i]!=0) # vérification si xBest a été modifié. Si oui, pas besoin de modifier xTest
                xTest[i] = 1
            end
        end
    end
    return zBest, xBest
end

#twoToOne : change 2 variable 1 à 0, et 1 variables 0 à 1
function twoToOne!(C,A,xInit,zInit,io)
    xBest = copy(xInit)
    zBest = zInit
    xTest = copy(xBest)
    zTest = zBest
    for i in 1:size(xInit)[2] #parcours 1er 1
        if (xBest[i]==1)
            xTest[i] = 0
            for j in i+1:size(xInit)[2] #parcours 2nd 1
                if(xBest[j]==1)
                    xTest[j] = 0
                    for k in 1:size(xInit)[2] #parcours des 0
                        if (xBest[k] == 0 && k!=i && k!=j) #vérification que le 0 n'est pas i ou j
                            xTest[k] = 1
                            zTest = calculZ(C,xTest)
                            if(zBest < zTest) # test si le xTest donnerait un meilleur résultat
                                if(isPossible(A,xTest)) # test si xTest est possible
                                    xBest = copy(xTest) #sauvegarde de x et z si possible
                                    zBest = zTest
                                else
                                    xTest[j] = 0 #remise à 0 si impossible
                                end
                            else
                                xTest[j] = 0 #remise à 0 si z est moins interessant
                            end
                        end
                    end
                    if (xBest[j]!=0) # vérification si xBest a été modifié. Si oui, pas besoin de modifier xTest
                        xTest[j] = 1
                    end
                end
            end
            if (xBest[i]!=0) # vérification si xBest a été modifié. Si oui, pas besoin de modifier xTest
                xTest[i] = 1
            end
        end
        return zBest, xBest
    end


    # z = -1
    # i = 1
    # while(i != size(x)[2])
    #     stop = false
    #     #println(io,"boucle de base, size(x) = ",size(x)[2], " i = ", i)
    #     while((i != size(x)[2]) && !stop)
    #         #println(io,"parcours i, size(x) = ",size(x)[2], " i = ", i)
    #         if(x[i]==1) #Selection premier var à 1 à 0 
    #             #println(io,"I : Tentative de passer x",i," à 0")
    #             x[i]=0
    #             k = i+1
    #             while((k != size(x)[2]) && !stop)
    #                 #println(io,"parcours k, size(x) = ",size(x)[2], " k = ", k)

    #                 if(x[k]==1) #selection seconde var à 1 à 0
                        

    #                     j = 1
    #                     #println(io,"parcours j, size(x) = ",size(x)[2], " j = ", j)
    #                     while((j != size(x)[1])&& !stop  )
    #                         if(x[j]==0 && j != i && j != k)
    #                             x[j]=1
    #                             z = calculZ(C,x)
    #                             #println(io,"J : Tentative de passer x",j," à 1")
    #                             if(zInit < z)
    #                                 #println(io,"J : Tentative isPossible()")

    #                                 if(isPossible(A,x))
    #                                     stop = true 
    #                                     #println(io,"J : Reussi")

    #                                 else
    #                                     x[j]=0
    #                                     #println(io,"J : Raté")
    #                                 end
    #                             else
    #                                 x[j]=0
    #                             end
    #                         end
    #                         j = j + 1
    #                     end
    #                 end
    #                 k = k +1
    #             end
    #         end
    #         i=i+1
    #     end
        
    # end

    # return z
end
