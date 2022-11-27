# Crée une population d'individus
function populationCreation(C, A, populationSize)
    population = Vector(undef, populationSize)
    feasibleNumber = 0
    maxZ = 0

    for individu = 1:populationSize
        feasible = false
        zInd = -1
        s = size(C)[1]
        x = zeros(1, s)
        
        randomOne = rand(0:s)
        listOne = []
        index = -1    
        for i in 1:randomOne
            while(!issubset(index, listOne))
                index = rand(1:s)
                append!(listOne,index)
                x[index] = 1
            end
        end
        
        zInd = calculZ(C, x)
        if(isPossible(A, x))
            feasibleNumber += 1
            feasible = true
            maxZ = max(zInd, maxZ)
        end
        population[individu] = (x, zInd, feasible)
    end
    println("Nombre de solutions réalisables : ", feasibleNumber, "   Meilleur z = ", maxZ)

    return population, feasibleNumber
end

# Sélectionne un parent dans la population
function parentSelection(population)    
    parent1, z1, feasible1 = population[1]
    parent2, z2, feasible2 = population[2]
    index1, index2 = 1, 2
    
    for i in 3:size(population)[1]
        ind, z, feasible = population[i]
        
        if(feasible && z > z2)
            if(z > z1) # Donc devient parent 1
                parent2, z2, feasible2 = parent1, z1, feasible1
                index2 = index1
                parent1, z1, feasible1 = population[i]
                index1 = i
            else # Sinon devient parent 2
                parent2, z2, feasible2 = population[i]
                index2 = i
            end
        end
    end

    if(index1 < index2)
        deleteat!(population, (index1, index2))
    else
        deleteat!(population, (index2, index1))
    end

    return (parent1, z1, feasible1), (parent2, z2, feasible2)
end

# Effectue un croisement entre 2 individus
function crossover(C, A, Pc, parent1, parent2)
    ind1, zInd1, feasibleInd1 = parent1
    ind2, zInd2, feasibleInd2 = parent2
    
    if(rand() <= Pc)
        crossoverPoint = trunc(Int, round(size(C)[1]/2)) # On coupe au "milieu"
        child1 = zeros(1, size(C)[1])
        child2 = zeros(1, size(C)[1])
        firstCrossover = vcat(ind1[1:crossoverPoint], ind2[crossoverPoint:size(C)[1]])
        secondCrossover = vcat(ind2[1:crossoverPoint], ind1[crossoverPoint:size(C)[1]])

        for i = 1:size(C)[1]
            child1[i] = firstCrossover[i] 
            child2[i] = secondCrossover[i] 
        end
    else
        child1, child2 = ind1, ind2
    end
    
    return (child1, calculZ(C, child1), isPossible(A, child1)), (child2, calculZ(C, child2), isPossible(A, child2))
end

# Effectue la mutation d'un individu (Mutation en 2 points a et b)
function mutation(C, A, Pm, individu)
    ind, z , feasible = individu
    if(rand() <= Pm)
        a = rand(1:size(C)[1])
        b = rand(1:size(C)[1])

        if(a != b)
            if ind[a] == 0
                ind[a] = 1
            else
                ind[a] = 0
            end

            if ind[b] == 0
                ind[b] = 1
            else
                ind[b] = 0
            end
        else
            return mutation(C, A, Pm, individu)
        end
    end

    return (ind, calculZ(C, ind) , isPossible(A,ind))
end

# Sélectionne le survivant entre 2 individus
function survivor(child, mutatedChild)
    ind1, zChild, isFeasibleChild = child
    ind2, zMutatedChild, isFeasibleMutatedChild = mutatedChild

    if(isFeasibleChild)
        if(isFeasibleMutatedChild)
            if(zChild > zMutatedChild)
                return (ind1, zChild, isFeasibleChild)
            else
                return (ind2, zMutatedChild, isFeasibleMutatedChild)
            end
        else 
            return (ind1, zChild, isFeasibleChild)
        end
    else
        return (ind2, zMutatedChild, isFeasibleMutatedChild)
    end    
end

# Donne la nouvelle generation qui deviendra notre nouvelle population de base
function nextGeneration(C, newGen, populationSize)
    population = Vector(undef, populationSize)
    feasibleNumber = 0
    minZ = 100
    maxZ = 0
    bestInd = zeros(1, size(C)[1])

    for i = 1:populationSize
        population[i] = pop!(newGen)
        ind, z, feasible = population[i]

        if(feasible)
            feasibleNumber += 1
            minZ = min(z, minZ)

            if(z > maxZ) # z de l'individu est meilleur
                bestInd = ind
            end

            maxZ = max(z, maxZ) 
        end
    end

    println("Nombre de solutions réalisables : ", feasibleNumber, "   Max z = ", maxZ, "   Min z = ", minZ)

    return population
end

# Sélectionne le meilleur individu dans une population
function bestIndividual(C, population)
    bestZ = 0
    bestInd = zeros(1, size(C)[1])

    for i in population
        ind, z, feasible = i
        if(feasible)
            if(z > bestZ) # z de l'individu est meilleur
                bestZ = z
                bestInd = i
            end
        end
    end

    return bestInd
end