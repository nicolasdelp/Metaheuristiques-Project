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