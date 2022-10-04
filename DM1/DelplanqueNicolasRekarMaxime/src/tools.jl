function calculRatios(C, A)
    ratios = zeros(1,size(A)[2])
    #println(size(A)[1])
    for i in 1:size(A)[1]#Pour chaque contrainte
        sum = 0
        for j in 1:size(A)[2] #Pour chaque valeur de x dans la contrainte
            sum = sum + A[i,j]
        end
        #ratios[i] = sum/C[]
    end
    return ratios
end

function calculZ(C, x)
    z = 0
    for i in 1:size(x)[2]
        z = z + (x[1,i]*C[i])
    end
    return z
end

function printMatrix(matrix)
    for i in 1:size(matrix)[1]
        println(matrix[Int64(i),:])
    end
end

function isPossible(A, x)
    cumul = zeros(1,size(A)[2])
    possible = true
    
    for i in 1:size(x)[2] # Parcourir x
        if (x[i] == 1) # Si x = 1, on enregistre la contrainte dans le cumul
            for j in 1:size(A)[2]
                cumul[1,j] = cumul[1,j] + A[i,j]
            end
        end
    end

    for i in 1:size(cumul)[2] # Vérifie que les cumulés soient <= 1
        if(cumul[1,i]>1)
            possible = false
            break
        end
    end
    return possible
end

function sortDescending(x)
end