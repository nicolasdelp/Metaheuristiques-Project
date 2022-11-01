#=
    Calcule le ratio de chauque colonne de la matrice de contrainte
    @C : la fonction objectif
    @A : la matrice des contraintes
    -----
    @return descRatios les indices des colonnes avec le ratio dans l'odre décroissant
=#
function calculRatios(C, A)
    ratios = zeros(1,size(A)[2])

    for i in 1:size(A)[2] # Pour chaque valeur de x
        sum = 0
        for j in 1:size(A)[1] # Pour chaque contrainte de x dans la contrainte
            sum = sum + A[j,i]
        end
        ratios[i] = C[i]/sum        
    end
    descRatios = sortperm(vec(ratios), rev = true) # Renvoie un tableau des indices des valeurs triées

    return descRatios
end

function calcMinMaxUtil(util)
    minUtil = typemax(Int64)
    maxUtil = 0
    for i in util
        if(i>maxUtil)
            maxUtil=i
        elseif(i != (-1) && i<minUtil)
            minUtil=i
        end
    end
    return minUtil, maxUtil
end

function calculUtil(C, A)
    utils = zeros(1,size(A)[2])
    minUtil = typemax(Int64)
    maxUtil = 0

    for i in 1:size(A)[2] # Pour chaque valeur de x (colonne)
        sum = 0

        for j in 1:size(A)[1] # Pour chaque valeur de x dans les contrainte (lignes)
            sum = sum + A[j,i]
        end
        if (sum>0)
            utils[i] = C[i]/sum
        else
            utils[i] = 0
        end

        if(utils[i] < minUtil)
            minUtil = utils[i]
        elseif(utils[i] > maxUtil)
            maxUtil = utils[i]
        end
    end
    #println("util =",utils," , minUtil = ",minUtil)
    return utils, minUtil, maxUtil
end

function calculRCL(util, RCL, lim)
    for i in 1:size(RCL)[2]
        if(RCL[i]!=2)
            if(util[i]>=lim)
                RCL[i]=1
            end
        end
    end
end

function emptyRCL(RCL)
    bool = true
    i = 1
    while(bool && i <=size(RCL)[2])
        #println("i = ",i ," size = ",size(RCL)[2])
        if(RCL[i]==1)
            bool = false
        end
        i = i +1
    end
    return bool
end

function randInRCL(RCL)
    #println(RCL)
    sum = 0
    index = 1
    for i in RCL
        if(i==1)
            sum = 1+1
        end
    end
    k = round(rand()*sum)+1
    while(k>0)
        i = 1
        #println("i = ",i ,", k = ", k)

        while(i <= size(RCL)[2] && k > 0)
            #println("i = ",i ,", k = ", k, "size = ",size(RCL)[2])

            #println(RCL)
            if(RCL[i]==1)
                k = k - 1
                #println("k = ", k)
                if (k==0)
                    index = i
                end
            end
            i = i+1
        end
    end
    return index
end

#=
    Calcule la valeur de z
    @C : la fonction objectif
    @x : la solution
    -----
    @return z la valeur de z
=#
function calculZ(C, x)
    z = 0

    for i in 1:size(x)[2]
        z = z + (x[1,i]*C[i])
    end

    return z
end

#=
    Affiche la matrice dans la console de manière plus lisible
    @matrix : la matrice a afficher
=#
function printMatrix(matrix)
    for i in 1:size(matrix)[1]
        println(matrix[Int64(i),:])
    end
end

#=
    Vérifie si la solution est admissible
    @A : la matrice des contraintes
    @x : la solution a tester
    -----
    @return possible un booleen, true si la solution est admissible sinon false
=#
function isPossible(A, x)
    cumul = zeros(1,size(A)[1])
    possible = true

    for i in 1:size(x)[2] # Parcourir x (9)
        if (x[i] == 1) # Si x = 1, on enregistre la colonne dans le cumul
            for j in 1:size(A)[1]
                cumul[1,j] = cumul[1,j] + A[j,i]
                
                if(cumul[1,j] > 1) # Vérifie que les cumulés soient <= 1
                    possible = false
                    break
                end
            end
        end
    end

    return possible
end

function plotAlphaRGRASP(iname, alphas, evolAlphas)
    figure("Evolution d'alpha",figsize=(6,6)) # Create a new figure
    title(string(" Evolutions probabilité d'alphas ", iname))
    xlabel("Itérations")
    ylabel("Probabilité")
    ylim(0, 1)

    colors = ["blue", "green", "red", "yellow", "purple"]
    for i in 1:5
        bar(collect(1:size(evolAlphas)[1]),evolAlphas[:,6-i],
         color = colors[i],
         edgecolor = "black")
    end

    savefig(string("_ALPHAS_",iname,".png"))
    close()
end