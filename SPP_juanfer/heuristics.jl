# --------------------------------------------------------
#   Heuristiques de construction et d'amélioration
# --------------------------------------------------------
# Auteurs : Khedaoudj HALIMI, Juanfer MERCIER

#include("kpexchanges_optim.jl")
include("movements.jl")

# Paramètres
#   u : un vecteur de même taille que v
#   v : un vecteur de même taille que u
#
# Valeur de retour
#   1 si u et v sont disjoints, 0 sinon
function disjointUnion(u, v)
    n = length(u)
    cv = copy(v)

    @assert n == length(v)

    for i=1:n
        if u[i] + cv[i] > 1 # jointure
            return 0, u
        else
            cv[i] = u[i] + cv[i]
        end
    end

    return 1, cv
end

# Paramètres
#   C : le vecteur des poids des variables
#   A : la matrice des données du problèmes
#
# Valeur de retour
#   couple (x0, zInit) avec x la solution initiale et zInit
#   le coût de la solution initiale x0
function GreedyConstruction(C, A)
    m, n = size(A) # dimensions de la matrice A
    U = Vector{Float64}(undef, n) # vecteur des utilités
    x0 = zeros(Int64, n) # solution initiale
    condCheck = zeros(Int64, m) # vecteur permettant de vérifier
        # la condition

    # calcul des utilités
    for j=1:n
        U[j] = C[j] / sum(A[:,j]) 
    end

    # indices des utilités dans l'ordre des utilités décroissantes
    u_order = sortperm(U, rev=true) 

    # initialisation (on prend les variables correspondants à 
    # la plus grande utilité)
    x0[u_order[1]] = 1
    condCheck = condCheck + A[:,u_order[1]]

    # On fait de même pour les autres utilités tant que l'on respecte la condition
    k = 2
    while sum(condCheck) != m && k <= n
        b, condCheck = disjointUnion(condCheck, A[:,u_order[k]])
        x0[u_order[k]] = b
        k = k + 1
    end

    return x0, dot(x0, C)
end

function feasible(A, x)
    k = 1
    m, n = size(A)
    condCheck = zeros(Int64, m)
    feasible = true
    println(length(x))
    println("================================")
    for i=1:length(x)
        if x[i] == 1
            condCheck = condCheck + A[:,i]
        end
    end

    while feasible && k <= m 
        # on vérifie la condition
        feasible = feasible && condCheck[k] <= 1 
        k = k+1
    end

    return feasible 
end

function GreedyImprovement(C, A, x, zInit, deep=true)
    xbest, zBest = x, zInit
    # on éxécute le 2-1 échange d'abord
    xtemp, zTemp = two_oneExchange(C, A, x, zInit, !deep)

    while xbest != xtemp && zBest != zTemp
        # Ensuite le 1-1 échange sur la solution trouvée
        xtemp, zTemp = one_oneExchange(C, A, xtemp, zTemp, !deep)
        # Puis le 0-1 échange...
        xtemp, zTemp = zero_oneExchange(C, A, xtemp, zTemp, !deep)
        # Et on reprend...
        xbest, zBest = two_oneExchange(C, A, xtemp, zTemp, !deep)
    end

    return xbest, zBest
end
