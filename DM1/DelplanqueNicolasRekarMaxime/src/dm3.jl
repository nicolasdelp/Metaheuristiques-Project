# import Pkg; 
# Pkg.add("JuMP")
# Pkg.add("GLPK")
# Pkg.add("PyPlot")
# using PyPlot
# using JuMP

include("tools.jl")
include("neighbors.jl")
include("../../../libSPP/librarySPP.jl")

include("grasp.jl")
include("improvement.jl")
include("reactiveGRASP.jl") # Première Métaheuristique
include("genetic.jl") # Seconde Métaheuristique
include("tools_genetics.jl")
function main()
    target = "../../../Data"
    fnames = getfname(target)
    fres = splitdir(splitdir(pwd())[end-1])[end]
    io = open("../res/"*fres*".res", "w")
    
    println("Etudiants : Delplanque Nicolas et Rekar Maxime")

    for instance = 1:length(fnames)
        for i in 1:1
            # Chargement de l'instance
            C, A = loadSPP(string(target,"/",fnames[instance]))
            
            # BATTEZ VOUS !!!
            # reactiveGRASP(C, A, fnames[instance], io)
            # Population = 100 doit être un multiple de 2
            geneticAlgorithm(C, A, 50, 100, 0.6, 0.05, fnames[instance], io)
        end
    end
    close(io)
end

main()