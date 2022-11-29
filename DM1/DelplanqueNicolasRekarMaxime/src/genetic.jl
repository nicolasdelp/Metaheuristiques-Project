function old_geneticAlgorithm(C, A, generationNumber, populationSize, Pc, Pm, fname, io)
    feasibleNb = 0
    population = 0
    i = 0
    plotFeasible = []
    plotZ = []
    plotZBest = []
    zBest = 0

    while(feasibleNb<=2)
        i = i + 1
        population, feasibleNb = old_populationCreation(C, A, populationSize,io)
        println(io, i , " " ,feasibleNb)
    end

    for generation = 1:generationNumber
        newGen = []
        #println("NOUVELLE GENERATION : N°", generation)

        for replication = 1:Int(populationSize/2)
            bool = false
            parent1 = parentSelection(population)
            parent2 = parentSelection(population)
            child1, child2, bool = crossover(C, A, Pc, parent1, parent2)
            if(bool)
                child1, zChild1, isFeasibleChild1 = survivor(child1 , mutation(C, A, Pm, child1))
                child2, zChild2, isFeasibleChild2 = survivor(child2 , mutation(C, A, Pm, child2))
            end
            push!(newGen, (child1, zChild1, isFeasibleChild1))
            push!(newGen, (child2, zChild2, isFeasibleChild2))
        end

        population, feasibleNb, maxZ = nextGeneration(C, newGen, populationSize)
        append!(plotFeasible,feasibleNb)
        append!(plotZ, maxZ)
        zBest = max(zBest, maxZ)
        append!(plotZBest, zBest)
        
    end

    bestInd = bestIndividual(C, population)
    # plotAnalyseGAFeasible(string("_old_",fname),plotFeasible,generationNumber)
    # plotAnalyseGA(string("_old_",fname),plotZ,plotZBest,generationNumber)

    if(bestInd != zeros(1, size(C)[1]))
        println(io,"============old_GA==========")
        println(io,fname)
        println(io,"Nombre de générations : ", generationNumber)
        println(io,"Nombre d'individus par population : ", populationSize)
        println(io,"Meilleur valeur de z dans dernière génération = ", bestInd[2])
        println(io,"Meilleur valeur de z dans toute les générations = ", plotZBest[generationNumber])

    end

    return plotZBest[generationNumber]
end

function geneticAlgorithm(C, A, generationNumber, populationSize, Pc, Pm, fname, io)
    feasibleNb = 0
    population = 0
    i = 0
    plotFeasible = []
    plotZ = []
    plotZBest = []
    zBest = 0

    while(feasibleNb<=2)
        i = i + 1
        population, feasibleNb = populationCreation(C, A, populationSize,io)
        println(io, i , " " ,feasibleNb)
    end

    for generation = 1:generationNumber
        newGen = []
        #println("NOUVELLE GENERATION : N°", generation)

        for replication = 1:Int(populationSize/2)
            parent1 = parentSelection(population)
            parent2 = parentSelection(population)
            child1, child2 = crossover(C, A, Pc, parent1, parent2)

            child1, zChild1, isFeasibleChild1 = survivor(child1 , mutation(C, A, Pm, child1))
            child2, zChild2, isFeasibleChild2 = survivor(child2 , mutation(C, A, Pm, child2))
            push!(newGen, (child1, zChild1, isFeasibleChild1))
            push!(newGen, (child2, zChild2, isFeasibleChild2))
        end

        population, feasibleNb, maxZ = nextGeneration(C, newGen, populationSize)
        append!(plotFeasible,feasibleNb)
        append!(plotZ, maxZ)
        zBest = max(zBest, maxZ)
        append!(plotZBest, zBest)
    end

    bestInd = bestIndividual(C, population)
    # plotAnalyseGAFeasible(string("_",fname),plotFeasible,generationNumber)
    # plotAnalyseGA(string("_",fname),plotZ,plotZBest,generationNumber)

    if(bestInd != zeros(1, size(C)[1]))
        println(io,"===========GA=============")
        println(io,fname)
        println(io,"Nombre de générations : ", generationNumber)
        println(io,"Nombre d'individus par population : ", populationSize)
        println(io,"Meilleur valeur de z dans dernière génération = ", bestInd[2])
        println(io,"Meilleur valeur de z dans toute les générations = ", plotZBest[generationNumber])

    end

    return plotZBest[generationNumber]
end