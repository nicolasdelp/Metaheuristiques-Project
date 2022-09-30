# --------------------------------------------------------
#                   Mouvements utilisés 
# --------------------------------------------------------
# Auteurs : Khedaoudj HALIMI, Juanfer MERCIER

# !! DISCLAIMER !!
# Le fichier suivant n'a pas été écrit par nous.
# Il peut être retrouvé à l'adresse suivante:
# https://github.com/JuliaMath/Combinatorics.jl
include("combinations.jl")

# --------------------------------------------------------
#                        k-p exchanges 
# --------------------------------------------------------

# Renvoie les indices des zéros et des uns dans x
# Paramètre : x vecteur d'entier
# Renvoie le vecteur des indices de 0, le vecteur 
#   des indices de 1, la taille du vecteur des 
#   indices de 0 et la taille du vecteur des indices 
#   de 1
function find01(x)
    k = l = 1
    n = length(x)
    all_0_idx = Vector{Int64}(undef, n)
    all_1_idx = Vector{Int64}(undef, n)

    for i=1:n
        if x[i] == 0
            all_0_idx[k] = i
            k = k+1
        elseif x[i] == 1
            all_1_idx[l] = i
            l = l+1
        end
    end

    return all_0_idx[1:k-1], all_1_idx[1:l-1], k-1, l-1
end

# paramètre fast à true pour la descente rapide, à false 
# pour la descente plus profonde
function zero_oneExchange(C, A, x::Vector{Int64}, zBest=0, fast=false; full=false, rnd=false)
    l = 1
    # Tous les indices des occurences de 0
    all_0_idx = findall(i->i==0, x)
    # Taille du voisinage
    n = length(all_0_idx)

    xbest, xtemp, zTemp = Vector{Int64}(), Vector{Int64}(), 0

    if full
        # Voisinage de x avec échange 0-1
        N = Vector{Vector{Int64}}(undef, n)
    end

    if rnd
        rndnum = rand()
    end

    for i in all_0_idx
        x[i] = 1
        if full
            N[l] = copy(x)
        end
        l = l+1
        
        if rnd
            if rand() <= rndnum
                return copy(x)
            end
        end
        
        if !full
            zTemp = dot(x, C)
                
            if zTemp >= zBest
                if fast
                    if feasible(A, x)
                        return x, zTemp
                    end
                else
                    if(feasible(A, x))
                        xbest, zBest = x, zTemp
                    end
                end
            end
        end
        
        x[i] = 0
    end

    if rnd
        return x
    elseif full
        return N[1:l-1], l-1
    elseif !fast
        return xbest, zBest
    else
        return x, zBest
    end
end

# paramètre fast à true pour la descente rapide, à false 
# pour la descente plus profonde
function one_oneExchange(C, A, x, zBest=0, fast=false; full=false, rnd=false)
    l = 1
    # Tous les indices des occurences de 0 et de 1
    # et aussi len0s, len1s tailles des tableaux d'occurences
    all_0_idx, all_1_idx, len0s, len1s = find01(x)
    xbest, zTemp = 0, 0

    if full
        # Voisinage de x avec échange 1-1
        N = Vector{Vector{Int64}}(undef, len0s * len1s)
    end

    if rnd
        rndnum = rand()
    end
    
    for i in all_1_idx
        x[i] = 0
        
        for j in all_0_idx
            if i != j
                x[j] = 1
                if full
                    N[l] = copy(x)
                end
                l = l+1

                if rnd
                    if rand() <= rndnum
                        return copy(x)
                    end
                end

                if !full
                    zTemp = dot(x, C)
                
                    if zTemp >= zBest
                        if fast
                            if feasible(A, x)
                                return x, zTemp
                            end
                        else
                            if(feasible(A, x))
                                xbest, zBest = x, zTemp
                            end
                        end
                    end
                end

                x[j] = 0
            end
        end
        
        x[i] = 1
    end
    
    if rnd
        return x
    elseif full
        return N[1:l-1], l-1
    elseif !fast
        return xbest, zBest
    else
        return x, zBest
    end
end

# paramètre fast à true pour la descente rapide, à false 
# pour la descente plus profonde
function two_oneExchange(C, A, x, zBest=0, fast=false; full=false, rnd=false)
    l = 1
    # Tous les indices des occurences de 0 et de 1
    # et aussi len0s, len1s tailles des tableaux d'occurences
    all_0_idx, all_1_idx, len0s, len1s = find01(x)
    xbest, zTemp = 0, 0

    if full
        # Voisinage de x avec échange 2-1
        N = Vector{Vector{Int64}}(undef, len0s * len1s * 2)
    end

    if rnd
        rndnum = rand()
    end
    
    # Toutes les combinaisons de pairs de 1
    all_comb = collect(combinations(all_1_idx, 2))

    for comb in all_comb
        i, j = comb[1], comb[2]
        x[i] = 0
        x[j] = 0
        
        for k in all_0_idx
            if i != k && j != k
                x[k] = 1
                if full
                    N[l] = copy(x)
                end
                l = l+1
                
                if rnd
                    if rand() <= rndnum
                        return copy(x)
                    end
                end

                if !full
                    zTemp = dot(x, C)
            
                    if zTemp >= zBest
                        if fast
                            if feasible(A, x)
                                return x, zTemp
                            end
                        else
                            if(feasible(A, x))
                                xbest, zBest = x, zTemp
                            end
                        end
                    end
                end

                x[k] = 0
            end
        end
        
        x[i] = 1
        x[j] = 1
    end

    if rnd
        return x
    elseif full
        return N[1:l-1], l-1
    elseif !fast
        return xbest, zBest
    else
        return x, zBest
    end
end
