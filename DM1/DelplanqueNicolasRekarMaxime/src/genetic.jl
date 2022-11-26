include("construction.jl")
include("tools.jl")

# Crée une population d'individus
function populationCreation(C, A, populationSize)
    population = Vector(undef, populationSize)
    feasible = false
    feasibleNumber = 0
    maxZ = 0

    for individu = 1:populationSize
        feasible = false
        ind = zeros(1,size(A)[2])
        for i = 1:size(ind)[2]
            ind[i] = rand(0:1)
        end
        if(isPossible(A, ind))
            zInd = calculZ(C, ind)
            feasibleNumber += 1
            maxZ = max(zInd, maxZ)
            # print("Individu n°", individu, " "); 
            # println("x = ", ind, "   z = ", zInd);
        end
        population[individu] = (ind, feasible)
    end
    println("Nombre de solutions réalisables : ", feasibleNumber, "   Meilleur z = ", maxZ)

    return population
end

# Sélectionne un parent dans la population
function parentSelection(population)
    parent = 0

    return parent
end

# Effectue un croisement entre 2 individus
function crossover(parent1, parent2)
    child1 = 0
    child2 = 0

    return child1, child2
end

# Effectue la mutation d'un individu (Mutation en 1 point)
function mutation(individu)
    individuCopy = copy(individu)
    a = rand(1:size(individuCopy)[2])

    if individuCopy[a] == 0
        individuCopy[a] = 1
    else
        individuCopy[a] = 0
    end
    
    return individuCopy
end

# Sélectionne le survivant entre 2 individus
function survivor(child1, child2)

    return child1
end

# Donne la nouvelle generation qui deviendra notre nouvelle population de base
function nextGeneration(newGen, populationSize)
    
end

# Sélectionne le meilleur individu dans une population
function bestIndividualIndex(population , populationSize)
    bestIndex = 0

    return bestIndex
end

#################################################################################################

function geneticAlgorithm(C, A, fname,io)
    generationNumber = 20
    populationSize = 100 # Doit être un multiple de 2
    
    population = populationCreation(C, A, populationSize)

    for generation = 1:generationNumber
        newGen = []
        println("NOUVELLE GENERATION : N°", generation)

        for replication = 1:Int(populationSize/2)
            parent1 = parentSelection(population)
            parent2 = parentSelection(population)
            child1, child2 = crossover(parent1, parent2)
            child1 = survivor(child1 , mutation(child1))
            child2 = survivor(child2 , mutation(child2))

            z = calculZ(C, child1)
            feasible = isPossible(A, child1)
            push!(newGen, (child1, z, feasible))

            z = calculZ(C, child2)
            feasible = isPossible(A, child2)
            push!(newGen, (child2, z, feasible))
        end

        population = nextGeneration(newGen, populationSize)
    end

    theBestIndex = bestIndividualIndex(population , populationSize)

    if(theBestIndex != 0)
        println("#####################")
        println("CONFIGURATION ")
        println("#####################")
        println("Nombre de générations : ", generationNumber)
        println("Nombre d'individus par population : ", populationSize)
        println("Meilleur individu trouvé => ", population[theBestIndex])
    end
end

