import Pkg;
Pkg.add("PyPlot")
using PyPlot

include("tools.jl")
include("neighbors.jl")
include("../../../libSPP/librarySPP.jl")

include("grasp.jl")
include("improvement.jl")
include("reactiveGRASP.jl") # Première Métaheuristique
include("genetic.jl") # Seconde Métaheuristique
include("tools_genetics.jl")
include("tools_plot.jl")
function main()
    target = "../../../Data"
    fnames = getfname(target)
    fres = splitdir(splitdir(pwd())[end-1])[end]
    io = open("../res/"*fres*"_DM3.res", "w")
    
    println("Etudiants : Delplanque Nicolas et Rekar Maxime")

    old_GA_plotZbest = []
    old_GA_plotT = []
    GA_plotZbest = []
    GA_plotT = []
    RGRASP_plotZMax = []
    RGRASP_plotT = []
    

    for instance = 1:length(fnames)
        # Chargement de l'instance
        C, A = loadSPP(string(target,"/",fnames[instance]))
        
        
        # println("RGRASP")
        # # BATTEZ VOUS !!!
        # RGRASP_ZMax, t1 = reactiveGRASP(C, A, fnames[instance], io)
        # println("old_GA")

        # Population = 100 doit être un multiple de 2
        t2 = @elapsed old_GA_Zbest = old_geneticAlgorithm(C, A, 20, 100, 0.4, 0.05, fnames[instance], io)
        println(io, "temps d'exec = ",t2)

        t3 = @elapsed GA_Zbest = geneticAlgorithm(C, A, 20, 100, 0.4, 0.05, fnames[instance], io)
        # println(io, "temps d'exec = ",t3)
        # println("GA")

        append!(old_GA_plotZbest,old_GA_Zbest)
        #append!(old_GA_plotT,t1)

        append!(GA_plotZbest,GA_Zbest)
        append!(GA_plotT,t2)

        append!(RGRASP_plotZMax,RGRASP_ZMax)
        append!(RGRASP_plotT,t3)


    end
    # plotAnalyseBattle(fnames,RGRASP_plotZMax, old_GA_plotZbest, GA_plotZbest)
    close(io)
end

main()