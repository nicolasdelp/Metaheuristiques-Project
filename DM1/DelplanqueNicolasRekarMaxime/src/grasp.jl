function greedyRandomizer(alpha, C, A,io)
    s = size(A)[2]
    xRand = zeros(1,s)
    util = zeros(1,s)
    util, minUtil, maxUtil = calculUtil(C,A)

    lim = (minUtil + alpha*(maxUtil-minUtil))
    
    RCL = zeros(1,s)
    calculRCL(util, RCL, lim)

    while(!emptyRCL(RCL))
     #=   
        println(io,"while")
        println(io,"xRa = ", xRand)
        println(io,"RCL = ", RCL)
        println(io,"util= ", util)
        println(io,"lim = ",lim)
      =#  

        i = randInRCL(RCL)
        RCL[i]=2
        xRand[i] = 1
        util[i] = -1
        if(!isPossible(A,xRand))
            xRand[i]=0
        end
              
        minUtil, maxUtil = calcMinMaxUtil(util)
        lim = (minUtil + alpha*(maxUtil-minUtil))
        calculRCL(util, RCL, lim)
#=
        println(io,"---------------------------------------------------")
        println(io,"while 2 ")
        println(io,"xRa = ", xRand)
        println(io,"RCL = ", RCL)
        println(io,"util= ", util)
        println(io,"lim = ",lim)
        println(io,"---------------------------------------------------")
        println(io,"---------------------------------------------------")
=#
    end
        #println(io, "fin de greedyImprovement")
        #println(io,"xRa = ", xRand)

    return xRand, calculZ(C,xRand)
end
