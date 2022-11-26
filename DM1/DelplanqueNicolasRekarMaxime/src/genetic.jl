include("construction.jl")

# Crée une solution x_0
function baselineSolution(instance)
    
end

# Crée une population d'individus
function populationCreation(n, baseline)
    
end

# Sélectionne un parent dans la population
function parentSelection(population)
    
end

# Effectue un croisement entre 2 individus p1 et p2
function crossover(p1, p2)
    
end

# Effectue la mutation d'un individu
function mutation(individu)
    
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

end
