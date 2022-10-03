# Permet d'afficher une matrice dans la console
function PrintMatrix(matrix, io)
    for i in 1:size(matrix)[1]
        println(io, matrix[Int64(i),:])
    end
end

function zeroColonne(matrix, ind)
    for i in 1:size(matrix)[1] # S'il y a un 1 dans la colonne du minimum ratio, on supprime la ligne de la matrice de contraine (mettre des 0 partout sur la ligne)
        if (matrix[Int64(i), ind] == 1)
            for j in 1:size(matrix)[2]
                matrix[Int64(i), Int64(j)] = 0
            end
        end
    end
    return matrix
end

function CalculZ(x, C)
    z = 0
    for i in 1:size(x)[2]
        z = z + (x[1,i]*C[i])
    end
    return z
end

function verifA(A,ind)
    vecRet = zeros(Int, size(A,1))
    
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
    println(vecRet)
    return vecRet

end

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