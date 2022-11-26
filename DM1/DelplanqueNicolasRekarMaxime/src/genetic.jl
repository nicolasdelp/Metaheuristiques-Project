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
            print("Individu n°", individu, " "); 
            println("x = ", ind, "   z = ", zInd);
            feasibleNumber += 1
            maxZ = max(zInd, maxZ)
        end
        population[individu] = (ind, feasible)
    end
    println("Nombre de sol. réalisable : ", feasibleNumber, " | Meilleur z = ", maxZ)

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
function survivor(p1, p2)
    
end

# Donne la nouvelle generation qui deviendra notre nouvelle population de base
function nextGeneration(newGen, populationSize)
    
end

# Sélectionne deux individus elites dans notre population
function eliteIndividuals(population , populationSize)

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
        end
    end
end

