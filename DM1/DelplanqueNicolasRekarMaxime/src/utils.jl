# Permet d'afficher une matrice dans la console
function PrintMatrix(matrix, io)
    for i in 1:size(matrix)[1]
        println(io, matrix[Int64(i),:])
    end
end

# Passe à 0 toute les lignes ayant un 1 dans la colonne n
function zeroColonne(matrix, n)
    for i in 1:size(matrix)[1]
        if (matrix[Int64(i), n] == 1)
            for j in 1:size(matrix)[2]
                matrix[Int64(i), Int64(j)] = 0
            end
        end
    end
    return matrix
end

# Calcule la valeur de Z
function CalculZ(x, C)
    z = 0
    for i in 1:size(x)[2]
        z = z + (x[1,i]*C[i])
    end
    return z
end

# Vérifie que toute la matrice de contrainte est à 0
function verifA(A,io)
    vecRet = zeros(Int, size(A,1))
    bool = false
    println(vecRet)
    for i in 1:size(A)[1]
        stop = false
        j = 1
        while(!stop&&(1<=j<=size(A)[1]))
            if(A[i,j]==1)
                stop = true
                vecRet[i,1] = 1
            end
            j = j+1
        end
    end
    test = zeros(Int,size(A)[1])
    if(vecRet == test)
        println(io,"Toutes conditions respectées")
        bool = true
    end
    println(vecRet)
    return vecRet, bool

end

# TODO
function solucePossible(C, A, x)
    # println("_________________")
    # println(x)
    vecSat = zeros(Int, size(A,1)) #Gen de colonnes 0 pour vecSat
    vecUnit = ones(Int,size(A,1)) #Gen de colonnes 1 pour vecUnit, non modifié
    var1 = findall(isequal(1), x[:]) #recupère les colonnes où 1
    bool = true
    # println(var1)
    for j in var1
        # println(A[:,j])
        vecSat = vecSat .+ A[:,j] #on met des 1 là où 
    end
    # PrintMatrix(A)
    # println(vecSat)
    # println(vecUnit)
    
    if findfirst(isequal(false), (vecSat .<= vecUnit)) != nothing
        bool = false
    end
    # println(bool)
    # println("_________________")

    return bool
end