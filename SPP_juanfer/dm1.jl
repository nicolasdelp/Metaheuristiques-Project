#= ATTENTION:
   your own folder is considered as the current working directory
   for running your solver
=#
import Pkg; 
Pkg.add("JuMP")
Pkg.add("GLPK")

include("../LibSPP/librarySPP.jl")
include("prints.jl")
include("modelSPP.jl")
include("heuristics.jl")

using LinearAlgebra
using GLPK

function main()
    println("Etudiant(e)s : HALIMI et MERCIER")

    # Collecting the names of instances to solve located in the folder Data ----
    target = "../Data"
    fnames = getfname(target)

    fres = splitdir(splitdir(pwd())[end-1])[end]
    io = open("../res/"*fres*".res", "w")

    tt = 0.0; score = 0; nb_amel = 0

    for instance = 1:length(fnames)

        # Load one numerical instance ------------------------------------------
        C, A = loadSPP(string(target,"/",fnames[instance]))

        zInit = 0 ; zBest = 0 ; t1 =0.0 ; t2 = 0.0 
        plusProf = true
        runSolver = false
        runOwnSol = true

        if(runOwnSol)
            t1 = @elapsed x, zInit = GreedyConstruction(C, A)
            t2 = @elapsed xbest, zBest = GreedyImprovement(C, A, x, zInit, plusProf)
            tt = tt+t1+t2

            # Saving results -------------------------------------------------------
            println(io, fnames[instance], " ", zInit, " ", zBest, " ", t1, " ", t2, " ", t1+t2)
            println(fnames[instance], " ", zInit, " ", zBest, " ", t1, " ", t2, " ", t1+t2)

            score = score + zBest
            nb_amel = nb_amel + upgradedPrint(zInit, zBest)
            feasiblePrint(A, xbest)
        end
        
        if(runSolver)
            println("================== SOLUTIONS OPTIMALES ==================")
            #GRB_ENV = Gurobi.Env()
            #SPP, X = modelSPP(() -> Gurobi.Optimizer(GRB_ENV), C, A)
            SPP, X = modelSPP(GLPK.Optimizer, C, A)
            #@show(SPP)
            println("\nOptimisation...")
            optimize!(SPP)
            println("\nRésultats")
            print(solution_summary(SPP))
            println()

            #free_env(GRB_ENV)
        end
    end

    resultsPrint(score, tt, nb_amel)

    close(io)

end

main()
