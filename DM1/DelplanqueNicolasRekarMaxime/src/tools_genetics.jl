# Crée une population d'individus
function old_populationCreation(C, A, populationSize,io)
    population = Vector(undef, populationSize)
    feasibleNumber = 0
    maxZ = 0

    for individu = 1:populationSize
        feasible = false
        zInd = -1
        s = size(C)[1]
        x = zeros(1, s)

        randomOne = rand(1:s)
        print(randomOne, " ")
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
   # println("Nombre de solutions réalisables : ", feasibleNumber, "   Meilleur z = ", maxZ)

    return population, feasibleNumber
end

function populationCreation(C, A, populationSize,io)
    population = Vector(undef, populationSize)
    maxZ = 0
    xBest = []
    zBest = 0
    for i in 1:populationSize        
        x, zInit = greedyRandomizer(0.1,C,A,io)
        maxZ = max(zInit,maxZ)
        population[i] = (x, zInit, true)
    end
    #println(" Meilleur z = ", maxZ )
    return population, populationSize
end

# Sélectionne un parent dans la population
function parentSelection(population)    
    
    # ============================================
    # Tentative d'implémentation de Fitness Proportionnate Selection
    
    # sum = 0
    # for i in 1:size(population)[1]
    #     sum += population[i][2]
    # end
    # listIndProb = []
    # sum2 = 0
    # for i in 1:size(population)[1]
    #     append!(listIndProb,population[i][2]/sum)
    #     sum2 += listIndProb[i]
    # end
    # if(sum2 > 1.0)
    #     listIndProb[size(population)[1]] = listIndProb[size(population)[1]]-(1-sum2)
    # end

    # ============================================

    s = size(population)[1]
    i1 = rand(1:s)
    if(s != 1)
        i2 = i1
        while(i2==i1)
            i2 = rand(1:s)
            #println("i1 = ",i1," ,i2 = ",i2)
        end
        
        winner = survivor(population[i1],population[i2])
    else
        winner = population[s]
    end
    if (winner[1] == population[i1][1])
        deleteat!(population, i1)
    else
        deleteat!(population, i2)
    end

    return winner
end

# Effectue un croisement entre 2 individus
function crossover(C, A, Pc, parent1, parent2)
    ind1, zInd1, feasibleInd1 = parent1
    ind2, zInd2, feasibleInd2 = parent2
    child1 = copy(ind1)
    child2 = copy(ind2)
    bool = false

    if(rand() <= Pc)
        bool = true
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
    
    return (child1, calculZ(C, child1), isPossible(A, child1)), (child2, calculZ(C, child2), isPossible(A, child2)), bool
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
    survivor, zSurv, isFeasibleSurv = 0,0,0
    if(isFeasibleChild1)
        if(isFeasibleChild2)
            if(zChild1 > zChild2)
                survivor, zSurv, isFeasibleSurv = copy(ind1), zChild1, isFeasibleChild1
            else
                survivor, zSurv, isFeasibleSurv = copy(ind2), zChild2, isFeasibleChild2
            end
        else 
            survivor, zSurv, isFeasibleSurv = copy(ind1), zChild1, isFeasibleChild1
        end
    else
        survivor, zSurv, isFeasibleSurv = copy(ind2), zChild2, isFeasibleChild2
    end    
    return (survivor, zSurv, isFeasibleSurv)
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

    #println("Nombre de solutions réalisables : ", feasibleNumber, "   Max z = ", maxZ, "   Min z = ", minZ)

    return population, feasibleNumber, maxZ
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