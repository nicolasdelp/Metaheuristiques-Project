function feasiblePrint(A, x)
    k = 1
    m, n = size(A)
    condCheck = zeros(Int64, m)
    feasible = true

    for i=1:length(x)
        if x[i] == 1
            condCheck = condCheck + A[:,i]
        end
    end

    while feasible && k <= m
        feasible = feasible && condCheck[k] <= 1
        k = k+1
    end

    if feasible
        printstyled("Feasible\n", color= :green)
    else 
        printstyled("NOT FEASIBLE\n", color= :red)
    end
end

function upgradedPrint(zI, zB, nb_amel=-1)
    up = 0
    if zB > zI
        up = 1
        printstyled("!! UPGRADED !!\n", color= :blue)
    end
    return up
end

function resultsPrint(score, tt, nb_amel)
    printstyled("\nRESULTS\n", color= :yellow)
    println("Score total : ", score)
    println("Temps d'exécution total : ", tt)
    println("Nombre d'améliorations : ", nb_amel)
end
