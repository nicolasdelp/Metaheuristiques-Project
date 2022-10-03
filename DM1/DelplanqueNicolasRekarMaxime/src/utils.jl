# Permet d'afficher une matrice dans la console
function PrintMatrix(matrix)
    for i in 1:size(matrix)[1]
        println(matrix[Int64(i),:])
    end
end

function CalculZ(x, C)
    z = 0
    for i in 1:size(x)[2]
        z = z + (x[1,i]*C[i])
    end
    return z
end