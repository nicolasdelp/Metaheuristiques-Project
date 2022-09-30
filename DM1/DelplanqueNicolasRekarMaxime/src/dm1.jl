#= ATTENTION:
   your own folder is considered as the current working directory
   for running your solver
=#

include("../../../libSPP/librarySPP.jl")

function GreedyConstruction(C, A)
    sumMatrix = Vector{Int64}(undef, size(A)[2]) # Somme des 1 de chaque colonne de la matrice de contraintes
    ratioMatrix = Vector{Float64}(undef, size(A)[2]) # Somme pondérée par les facteurs de la fonction objectif

    for i in 1:size(A)[2]
        sum = 0
        for j in 1:size(A)[1]
            sum = sum + A[Int64(j),Int64(i)]
        end
        sumMatrix[Int64(i)] = sum # Somme de la colonne
        ratioMatrix[Int64(i)] = sum/C[Int64(i)] # Somme pondérée de la colonne
    end

    println("Sum of each colums : ")
    println(sumMatrix)
    println("Ratio of each colums : ")
    println(ratioMatrix)

end

function GreedyImprovement(C, A, x, zInit)
    
end

function main()
    println("Students : Delplanque Nicolas & Rekar Maxime")

    # Collecting the names of instances to solve located in the folder Data ----
    target = "../../../Data"
    fnames = getfname(target)

    fres = splitdir(splitdir(pwd())[end-1])[end]
    io = open("../res/"*fres*".res", "w")
    for instance = 1:length(fnames)

        # Load one numerical instance ------------------------------------------
        C, A = loadSPP(string(target,"/",fnames[instance]))

        zInit = 0 ; zBest = 0 ; t1 =0.0 ; t2 = 0.0

        # Display data informations
        println("Objective function : ")
        println(C)

        println("Constraint matrix : ")
        for i in 1:size(A)[1]
            println(A[Int64(i),:])
        end

        GreedyConstruction(C, A)

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
