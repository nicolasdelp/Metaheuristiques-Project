#= ATTENTION:
   your own folder is considered as the current working directory
   for running your solver
=#
import Pkg; 
Pkg.add("JuMP")
Pkg.add("GLPK")
Pkg.add("PyPlot") # Mandatory before the first use of this package
using PyPlot
using JuMP

include("tools.jl")
include("neighbors.jl")
include("construction.jl")
include("improvement.jl")
include("../../../libSPP/librarySPP.jl")
include("grasp.jl")

function modelSPP(solveur, C, A)
m, n = size(A) # dimensions de la matrice A
    
    # Création du modèle
    spp = Model(solveur)
    
 # Définition des variables
    @variable(spp, x[1:n], Bin)
    
    # Définition de l’objectif (la somme des ci*xi correspond
    # au produit scalaire du vecteur C et du vecteur X)
    @objective(spp, Max, dot(C, x))
    # Définition des contraintes
    @constraint(spp, ctes[i=1:m], sum(A[i,j] * x[j] for j=1:n) <= 1)
    
    # On retourne le modèle spp et le vecteur des variables x
    return spp, x
end

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
        for i in 1:50

            zInit = 0 ; zBest = 0 ; t1 =0.0 ; t2 = 0.0
            #println("C = ",C)
            #println("A = ",A)

            t1 = @elapsed x, zInit = greedyRandomizer(0 ,C, A,io)
            t2 = @elapsed xbest, zBest = greedyImprovement(C, A, x, zInit, io)
            # Saving results -------------------------------------------------------

            println(io, fnames[instance], " ", zInit, " ", zBest, " ", t1, " ", t2, " ", t1+t2)       
        end
        println(io,"____________________________________________")
    end
    close(io)

end

main()
