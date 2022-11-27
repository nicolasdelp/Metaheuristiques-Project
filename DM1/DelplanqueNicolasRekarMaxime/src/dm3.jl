import Pkg; 
Pkg.add("JuMP")
Pkg.add("GLPK")
Pkg.add("PyPlot")
using PyPlot
using JuMP

include("tools.jl")
include("neighbors.jl")
include("../../../libSPP/librarySPP.jl")

include("reactiveGRASP.jl") # Première Métaheuristique
include("genetic.jl") # Seconde Métaheuristique

function main()
    target = "../../../Data"
    fnames = getfname(target)
    fres = splitdir(splitdir(pwd())[end-1])[end]
    io = open("../res/"*fres*".res", "w")
    
    println("Etudiants : Delplanque Nicolas et Rekar Maxime")

    for instance = 1:2 #length(fnames)

        # Chargement de l'instance
        C, A = loadSPP(string(target,"/",fnames[instance]))
        
        # BATTEZ VOUS !!!
        # reactiveGRASP(C, A, fnames[instance], io)
        geneticAlgorithm(C, A, fnames[instance], io)
    end
    close(io)
end

main()