# Crée une population d'individus
function populationCreation(C, A, populationSize,io)
    population = Vector(undef, populationSize)
    maxZ = 0
    xBest = []
    zBest = 0
    
    for i in 1:populationSize
        # if (i <= populationSize*0.05)
        #     x, zInit = greedyRandomizer(1,C,A,io)
        # elseif (i <= populationSize*0.4)
            x, zInit = greedyRandomizer(0,C,A,io)
        # else
        #     x, zInit = greedyRandomizer(0.1,C,A,io)
        # end
        maxZ = max(zInit,maxZ)
        population[i] = (x, zInit, true)
    end

    println(" Meilleur z = ", maxZ )
    return population, populationSize
end

# Sélectionne un parent dans la population
function parentSelection(population)    
    sum = 0
    for i in 1:size(population)[1]
        sum += population[i][2]
    end
    listIndProb = []
    sum2 = 0
    for i in 1:size(population)[1]
        append!(listIndProb,population[i][2]/sum)
        sum2 += listIndProb[i]
    end
    if(sum2 > 1.0)
        listIndProb[size(population)[1]] = listIndProb[size(population)[1]]-(1-sum2)
    end
    

    parent1, z1, feasible1 = population[1]
    parent2, z2, feasible2 = population[2]
    index1, index2 = 1, 2
    
    for i in 3:size(population)[1]
        ind, z, feasible = population[i]
        
        if(feasible && z > z2)
            if(z > z1) # Donc devient parent 1, actuel parent 1 devient parent 2
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
    child1 = copy(ind1)
    child2 = copy(ind2)


    if(rand() <= Pc)
        stop = false
        listCross = []
        i = 1
        

        while(!stop)
            index = rand(1:size(child1)[1])
            if(!issubset(index, listCross))
                temp = child1[index]
                child1[index]=child2[index]
                child2[index] = temp

                append!(listCross,index)
                stop = (rand()<= 1/i^0.7)
                i += 1
            end
        end
    else
        child1, child2 = ind1, ind2
    end
    
    return (child1, calculZ(C, child1), isPossible(A, child1)), (child2, calculZ(C, child2), isPossible(A, child2))
end

# Effectue la mutation d'un individu (Mutation en 1 point, et 10% de chances de répeter sur un autre point)
function mutation(C, A, Pm, individu)
    ind, z , feasible = individu
    if(rand() <= Pm)
        stop = false
        listMut = []
        i=1
        while (!stop)
            index = rand(1:size(C)[1])
            if(!issubset(index,listMut))
                if ind[index] == 0
                    ind[index] = 1
                else
                    ind[index] = 0
                end
                append!(listMut,index)
                stop = (0.9>=rand())
                i = i +1
            end
        end
            
    end

    return (ind, calculZ(C, ind) , isPossible(A,ind))
end

# Sélectionne le survivant entre 2 individus
function survivor(child1, child2)
    ind1, zChild1, isFeasibleChild1 = child1
    ind2, zChild2, isFeasibleChild2 = child2

    if(isFeasibleChild1)
        if(isFeasibleChild2)
            if(zChild1 > zChild2)
                return (ind1, zChild1, isFeasibleChild1)
            else
                return (ind2, zChild2, isFeasibleChild2)
            end
        else 
            return (ind1, zChild1, isFeasibleChild1)
        end
    else
        return (ind2, zChild2, isFeasibleChild2)
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