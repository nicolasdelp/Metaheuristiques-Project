#= ATTENTION:
   your own folder is considered as the current working directory
   for running your solver
=#

include("../../../libSPP/librarySPP.jl")
include("./utils.jl")

function isTheEnd(A)
    fin = true
    for i in 1:size(A)[1]
        for j in 1:size(A)[2]
            if A[Int64(i), Int64(j)] == 1
                fin = false
            end
        end
    end
    return fin
end

function GreedyConstruction(C, A, io)
    sol = zeros(1, size(A)[2]) # Solution trouvée de retour pour ce SPP
    z = 0
    sumMatrix = Vector{Int64}(undef, size(A)[2]) # Somme des 1 de chaque colonne de la matrice de contraintes
    ratioMatrix = Vector{Float64}(undef, size(A)[2]) # Somme pondérée par les facteurs de la fonction objectif
    newA = A

    while !isTheEnd(newA)
        minimumRatio = 999999999999 # Ratio minimum
        minimumRatioIndex = -1 # Index de la colonne comportant le ratio minimum
        for i in 1:size(newA)[2]
            sum = 0
            for j in 1:size(newA)[1]
                sum = sum + newA[Int64(j),Int64(i)]
            end

            sumMatrix[Int64(i)] = sum # Somme de la colonne
            ratioMatrix[Int64(i)] = sum/C[Int64(i)] # Somme pondérée de la colonne


            if (ratioMatrix[Int64(i)] < minimumRatio) # On garde l'index de la colonne ayant le ratio le plus petit
                if sum > 0
                    minimumRatio = sum/C[Int64(i)]
                    minimumRatioIndex = i
                end
            end
        end

        sol[1, minimumRatioIndex] = 1

        for i in 1:size(newA)[1]
            if (newA[Int64(i), minimumRatioIndex] == 1) # S'il y a un 1 dans la colonne du minimum ratio, on supprime la ligne de la matrice de contraine (mettre des 0 partout sur la ligne)
                for j in 1:size(newA)[2]
                    newA[Int64(i), Int64(j)] = 0
                end
            end
        end

        println(io,"=======================================================")
        println(io,"Sum of each colums : ")
        println(io,sumMatrix)
        println(io,"Ratio of each colums : ")
        println(io,ratioMatrix)
        println(io,"Minimum ratio : ", minimumRatio)
        println(io,"Minimum ratio index : ", minimumRatioIndex)
        PrintMatrix(newA, io)
        println(io,"Solution : ", sol)
        z = CalculZ(sol, C)
        println(io,"Z = ", z)
        solucePossible(C,A,sol)
        isAdmissible(C,A,sol)
    end
    return sol, z
end

function GreedyImprovement(C, A, x, zInit, io)
    PrintMatrix(A,io)
    o = zeros(size(A)[1], size(A)[2])
    o[1,3]= 1
    o[4,2]= 1
    o[3,3]= 1
    zeroColonne(o,3)
    PrintMatrix(o,io)
    verifA(o,0)
    for i in 1:size(x)[2]
    end

    
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
        initA = copy(A)
        #PrintMatrix(io, initA)
        zInit = 0 ; zBest = 0 ; t1 =0.0 ; t2 = 0.0

        # Display data informations
        println(io,"Objective function : ")
        println(io,C)

        println(io,"Constraint matrix : ")
        PrintMatrix(A, io)

        x,z = GreedyConstruction(C, A, io)

        println(io, "-------------------------------------------")
        println(io, "-------------------------------------------")

        GreedyImprovement(C, initA, x, z, io)
        
        #=
         votre code :
         t1 = @elapsed x, zInit = GreedyConstruction(C, A)
         t2 = @elapsed xbest, zBest = GreedyImprovement(C, A, x, zInit)
        =#

        # Saving results -------------------------------------------------------
        println(io, fnames[instance], " ", zInit, " ", zBest, " ", t1, " ", t2, " ", t1+t2," salut")
    end
    close(io)

end

main()
