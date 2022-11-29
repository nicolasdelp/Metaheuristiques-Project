function plotAlphaRGRASP(iname, alphas, evolAlphas)
    figure("Evolution d'alpha",figsize=(6,6)) # Create a new figure
    title(string(" Evolutions probabilité d'alphas ", iname))
    xlabel("Itérations")
    ylabel("Probabilité")
    ylim(0, 1)

    colors = ["blue", "green", "red", "yellow", "purple"]
    for i in 1:5
        bar(collect(1:size(evolAlphas)[1]),evolAlphas[:,6-i],
         color = colors[i],
         edgecolor = "black")
    end

    savefig(string("_ALPHAS_",iname,".png"))
    close()
end

function plotAnalyseGAFeasible(iname, plotFeasible, generationNumber)
    figure("Bilan GA",figsize=(6,6)) # Create a new figure
    title(string("GA-Feasible-SPP | ", iname))
    xlabel("Générations (pour generationNumber)")
    ylabel("Nombre de solutions possibles (pour feasibleNb)")
    xlim(1,generationNumber)

    plot(collect(1:generationNumber),plotFeasible,linestyle="-", ms=10, color="green", label="nbFeasible")
    legend(loc=4, fontsize ="small")
    savefig(string("_GA_Feasible", iname , ".png") , format="png")
    close()

end

function plotAnalyseGA(iname, plotZ,plotZBest, generationNumber)
    figure("Bilan GA",figsize=(6,6)) # Create a new figure
    title(string("GA-SPP | ", iname))
    xlabel("Générations (pour generationNumber)")
    ylabel("Valeur de Z (pour maxZ)")
    xlim(1,generationNumber)

    plot(collect(1:generationNumber),plotZBest,linestyle="-", ms=4, color="red", label="zBest")
    plot(collect(1:generationNumber),plotZ,linestyle="-", ms=4, color="green", label="zMax")

    legend(loc=4, fontsize ="small")
    savefig(string("_GA", iname , ".png") , format="png")
    close()

end

function plotAnalyseBattle(fnames, RGRASP_plotZMax , old_GA_plotZbest, GA_plotZbest)
    figure("Bilan Analyse battle",figsize=(6,6)) # Create a new figure
    title(string("Analyse de Z pour Battle "))
    xlabel("Instances")
    ylabel("Valeur de Z")
    xlim(1,size(fnames)[1])
    

    scatter(collect(1:size(fnames)[1]), RGRASP_plotZMax, color = "red", marker = "2", label ="RGRASP Z")
    scatter(collect(1:size(fnames)[1]), old_GA_plotZbest, color = "blue", marker = "+", label ="old_GA Z")
    scatter(collect(1:size(fnames)[1]), GA_plotZbest, color = "green", marker = "x", label ="GA Z")
    yticks(rotation = 90)
    savefig(string("_BATTLE.png") , format="png")
    close()
end