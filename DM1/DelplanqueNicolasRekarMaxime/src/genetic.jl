include("construction.jl")
include("tools.jl")

# Crée une population d'individus
function populationCreation(C, A, populationSize)
    population = Vector(undef, populationSize)
    feasibleNumber = 0
    maxZ = 0

    for individu = 1:populationSize
        feasible = false
        zInd = -1
        ind = zeros(1, size(A)[2])

        for i = 1:size(ind)[2]
            ind[i] = rand(0:1)
        end
        
        if(isPossible(A, ind))
            feasibleNumber += 1
            feasible = true
            zInd = calculZ(C, ind)
            maxZ = max(zInd, maxZ)
        end
        population[individu] = (ind, zInd, feasible)
    end

    if(feasibleNumber < 2)
        population = populationCreation(C, A, populationSize) # On recommence s'il n'y a pas au moins 2 individus réalisables
    else
        println("Nombre de solutions réalisables : ", feasibleNumber, "   Meilleur z = ", maxZ)
    end

    return population
end

# Sélectionne un parent dans la population
function parentSelection(C, population)
    bestZ = 0
    parentIndex = -1
    parent = zeros(1, size(C)[1])
    x = 1

    for i in population
        ind, z, feasible = i
        if(feasible)
            if(z > bestZ) # z de l'individu est meilleur
                bestZ = z
                parentIndex = x
                parent = ind
            end
        end
        x += 1
    end

    if(parentIndex != -1)
        deleteat!(population, parentIndex) # On l'enlève de la population pour pas le reprendre avec le parent 2
    end

    return (parent, bestZ, true)
end

# Effectue un croisement entre 2 individus
function crossover(C, parent1, parent2)
    crossoverPoint = trunc(Int, round(size(C)[1]/2)) # On coupe au "milieu"
    child1 = zeros(1, size(C)[1])
    child2 = zeros(1, size(C)[1])
    ind1, zInd1, feasibleInd1 = parent1
    ind2, zInd2, feasibleInd2 = parent2

    firstCrossover = vcat(ind1[1:crossoverPoint], ind2[crossoverPoint:size(C)[1]])
    secondCrossover = vcat(ind2[1:crossoverPoint], ind1[crossoverPoint:size(C)[1]])

    for i = 1:size(C)[1]
        child1[i] = firstCrossover[i]
        child2[i] = secondCrossover[i]
    end

    return child1, child2
end

# Effectue la mutation d'un individu (Mutation en 2 points a et b)
function mutation(C, individu)
    individuCopy = copy(individu)
    a = rand(1:size(C)[1])
    b = rand(1:size(C)[1])

    if(a != b)
        if individuCopy[a] == 0
            individuCopy[a] = 1
        else
            individuCopy[a] = 0
        end

        if individuCopy[b] == 0
            individuCopy[b] = 1
        else
            individuCopy[b] = 0
        end
    else
        return mutation(C, individu)
    end
    
    return individuCopy
end

# Sélectionne le survivant entre 2 individus
function survivor(A, C, child, mutatedChild)
    zChild = calculZ(C, child)
    zMutatedChild = calculZ(C, mutatedChild)
    isFeasibleChild = isPossible(A, child)
    isFeasibleMutatedChild = isPossible(A, mutatedChild)

    if(zChild > zMutatedChild)
        return (child, zChild, isFeasibleChild)
    else
        return (mutatedChild, zMutatedChild, isFeasibleMutatedChild)
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

    return population, bestInd, maxZ
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

    return bestInd, bestZ
end

#################################################################################################

function geneticAlgorithm(C, A, fname, io)
    generationNumber = 20
    populationSize = 100 # Doit être un multiple de 2
    
    population = populationCreation(C, A, populationSize)
    bestOfEachGeneration = []

    for generation = 1:generationNumber
        newGen = []
        println("NOUVELLE GENERATION : N°", generation)

        for replication = 1:Int(populationSize/2)
            parent1 = parentSelection(C, population)
            parent2 = parentSelection(C, population)
            child1, child2 = crossover(C, parent1, parent2)
            child1, zChild1, isFeasibleChild1 = survivor(A, C, child1 , mutation(C, child1))
            child2, zChild2, isFeasibleChild2 = survivor(A, C, child2 , mutation(C, child2))
            push!(newGen, (child1, zChild1, isFeasibleChild1))
            push!(newGen, (child2, zChild2, isFeasibleChild2))
        end

        population, bestInd, zBest = nextGeneration(C, newGen, populationSize)
        push!(bestOfEachGeneration, (bestInd, zBest, true))
    end

    bestInd, bestZ = bestIndividual(C, bestOfEachGeneration)

    if(bestZ != 0)
        println("#####################")
        println("CONFIGURATION ")
        println("#####################")
        println("Nombre de générations : ", generationNumber)
        println("Nombre d'individus par population : ", populationSize)
        println("Meilleur individu trouvé => ", bestInd[1], "   Meilleur z = ", bestZ)
    end
end

