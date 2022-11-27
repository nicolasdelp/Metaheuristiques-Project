function geneticAlgorithm(C, A, generationNumber, populationSize, Pc, Pm, fname, io)
    feasibleNb = 0
    population = 0
    i = 0

    while(feasibleNb<=2)
        i = i + 1
        population, feasibleNb = populationCreation(C, A, populationSize)
        println(io, i , " " ,feasibleNb)
    end

    for generation = 1:generationNumber
        newGen = []
        println("NOUVELLE GENERATION : N°", generation)

        for replication = 1:Int(populationSize/2)
            parent1, parent2 = parentSelection(population)
            child1, child2 = crossover(C, A, Pc, parent1, parent2)
            child1, zChild1, isFeasibleChild1 = survivor(child1 , mutation(C, A, Pm, child1))
            child2, zChild2, isFeasibleChild2 = survivor(child2 , mutation(C, A, Pm, child2))
            push!(newGen, (child1, zChild1, isFeasibleChild1))
            push!(newGen, (child2, zChild2, isFeasibleChild2))
        end

        population = nextGeneration(C, newGen, populationSize)
    end

    bestInd = bestIndividual(C, population)

    if(bestInd != zeros(1, size(C)[1]))
        println("#####################")
        println("CONFIGURATION ")
        println("#####################")
        println("Nombre de générations : ", generationNumber)
        println("Nombre d'individus par population : ", populationSize)
        println("Meilleur individu trouvé => ", bestInd[1], "   Meilleur z = ", bestInd[2])
    end
end

