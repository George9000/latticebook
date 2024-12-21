module latticebook
using CairoMakie, DataFrames, Chain, DataPipes
using RDatasets
using RCall

export rfig11, rfig12, rfig13, rfig14

"""
    rfig11()

Generate figure 1.1 with Rcall.
"""
function rfig11()
   R"""
       data(Chem97, package = "mlmRev")
       xtabs( ~ score, data = Chem97)
       library("lattice")
       histogram(~gcsescore | factor(score), data = Chem97)
   """
end

"""
    rfig12()

Generate figure 1.2 with Rcall.
"""
function rfig12()
   R"""
       data(Chem97, package = "mlmRev")
       library("lattice")
       densityplot(~ gcsescore | factor(score), data = Chem97,
                     plot.points = FALSE, ref = TRUE)
   """
end

"""
    rfig13()

Generate figure 1.3 with Rcall.
"""
function rfig13()
   R"""
       data(Chem97, package = "mlmRev")
       library("lattice")
       densityplot(~ gcsescore, data = Chem97,
                     groups = score, plot.points = FALSE,
                     ref = TRUE,
                     auto.key = list(columns = 3))
   """
end


"""
    rfig14()

Generate figure 1.4 with Rcall.
"""
function rfig14()
   R"""
       data(Chem97, package = "mlmRev")
       library("lattice")
       tp1 <- histogram(~ gcsescore | factor(score), data = Chem97)
       tp2 <- densityplot(~ gcsescore, data = Chem97, groups = score,
                            plot.points = FALSE,
                            auto.key = list(space = "right", title = "score"))
       class(tp2)
       summary(tp1)
       plot(tp1, split = c(1, 1, 1, 2))
       plot(tp2, split = c(1, 2, 1, 2), newpage = FALSE)
   """
end




end # module latticebook
