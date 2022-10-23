#= ATTENTION:
   your own folder is considered as the current working directory
   for running your solver
=#
import Pkg; 
Pkg.add("JuMP")
Pkg.add("GLPK")

include("tools.jl")
include("neighbors.jl")
include("construction.jl")
include("improvement.jl")
include("../../../libSPP/librarySPP.jl")
include("grasp.jl")

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
        # println("Objective function : ")
        # println(C)

        # println("Constraint matrix : ")
        # printMatrix(A)

        zInit = 0 ; zBest = 0 ; t1 =0.0 ; t2 = 0.0

        t1 = @elapsed x, zInit = greedyConstruction(C, A)
        t2 = @elapsed xbest, zBest = greedyImprovement(C, A, x, zInit, io)
        
        # Saving results -------------------------------------------------------
        println(io, fnames[instance], " ", zInit, " ", zBest, " ", t1, " ", t2, " ", t1+t2)
    end
    close(io)

end

main()
