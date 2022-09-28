#= ATTENTION:
   your own folder is considered as the current working directory
   for running your solver
=#

include("../../../libSPP/librarySPP.jl")

function main()
    println("Etudiants : Delplanque Nicolas et Rekar Maxime")

    # Collecting the names of instances to solve located in the folder Data ----
    target = "../../../Data"
    fnames = getfname(target)

    fres = splitdir(splitdir(pwd())[end-1])[end]
    io = open("../res/"*fres*".res", "w")
    for instance = 1:length(fnames)

        # Load one numerical instance ------------------------------------------
        C, A = loadSPP(string(target,"/",fnames[instance]))

        zInit = 0 ; zBest = 0 ; t1 =0.0 ; t2 = 0.0

        #=
         votre code :
         t1 = @elapsed x, zInit = GreedyConstruction(C, A)
         t2 = @elapsed xbest, zBest = GreedyImprovement(C, A, x, zInit)
        =#

        # Saving results -------------------------------------------------------
        println(io, fnames[instance], " ", zInit, " ", zBest, " ", t1, " ", t2, " ", t1+t2)
    end
    close(io)

end

main()
