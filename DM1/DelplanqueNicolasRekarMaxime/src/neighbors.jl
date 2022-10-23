#zeroToOne : change 1 variables 0 à 1
function zeroToOne!(C,A,x)
    z = -1
    i = 1
    while(i != size(x)[2])
        i = 1
        stop = false
        while(!stop && (i != size(x)[2]))
            if(x[i]==0)
                println("Tentative de passer x",i," à 1")
                x[i]=1
                if(!isPossible(A,x))
                    x[i]=0
                    println("Impossible")
                else
                    stop = true
                    z = calculZ(C,x)
                end
            end
            i=i+1
        end
    end
        
    return z
end

#oneToOne : change 1 variable 1 à 0, et 1 variables 0 à 1
function oneToOne!(C,A,x,zInit,io)
    z = -1
    i = 1 
    while(i != size(x)[2])
        stop = false
        while(!stop && (i != size(x)[2]))
            if(x[i]==1)
                #println(io,"I : Tentative de passer x",i," à 0")
                x[i]=0
                j = 1
                while(!stop && (j != size(x)[2]))
                    if(x[j]==0 && j != i)
                        x[j]=1
                        z = calculZ(C,x)
                        #println(io,"J : Tentative de passer x",j," à 1")
                        if(zInit < z)
                            #println(io,"J : Tentative isPossible()")

                            if(isPossible(A,x))
                                stop = true 
                                #println(io,"J : Reussi")

                            else
                                x[j]=0
                                #println(io,"J : Raté")
                            end
                        else
                            x[j]=0
                        end
                    end
                    j = j + 1
                end
            end
            i=i+1
        end
    end

    return z
end

#twoToOne : change 2 variable 1 à 0, et 1 variables 0 à 1
function twoToOne!(C,A,x,zInit,io)
    z = -1
    i = 1
    while(i != size(x)[2])
        stop = false
        #println(io,"boucle de base, size(x) = ",size(x)[2], " i = ", i)
        while((i != size(x)[2]) && !stop)
            #println(io,"parcours i, size(x) = ",size(x)[2], " i = ", i)
            if(x[i]==1) #Selection premier var à 1 à 0 
                #println(io,"I : Tentative de passer x",i," à 0")
                x[i]=0
                k = i+1
                while((k != size(x)[2]) && !stop)
                    #println(io,"parcours k, size(x) = ",size(x)[2], " k = ", k)

                    if(x[k]==1) #selection seconde var à 1 à 0
                        j = 1
                        #println(io,"parcours j, size(x) = ",size(x)[2], " j = ", j)
                        while((j != size(x)[1])&& !stop  )
                            if(x[j]==0 && j != i && j != k)
                                x[j]=1
                                z = calculZ(C,x)
                                #println(io,"J : Tentative de passer x",j," à 1")
                                if(zInit < z)
                                    #println(io,"J : Tentative isPossible()")

                                    if(isPossible(A,x))
                                        stop = true 
                                        #println(io,"J : Reussi")

                                    else
                                        x[j]=0
                                        #println(io,"J : Raté")
                                    end
                                else
                                    x[j]=0
                                end
                            end
                            j = j + 1
                        end
                    end
                    k = k +1
                end
            end
            i=i+1
        end
        
    end

    return z
end
