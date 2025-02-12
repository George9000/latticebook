module latticebook

using CairoMakie, DataFrames, Chain, DataPipes, CategoricalArrays, Dates
using RDatasets
using RCall
using FreqTables
using Statistics

export explore
export rfig11, rfig12, rfig13, rfig14
export gcsev1, gcsev2

# Makie figure sizing
const inch = 96
const pt = 4 / 3
const cm = inch / 2.54

# datasets
const chem97 = dataset("mlmRev", "Chem97")
const barley = dataset("lattice", "barley")

# fonts
const usualf = "TheSansMonoCd Office"
const labelsf = "TheSansMono Bold"

"""
    explore()

Convenience function for temporary exploration during development.
"""
function explore()
    # names(chem97)
    # freqtable(chem97, :Score)    # discrete
    # freqtable(chem97, :GCSEScore)  # continuous
    # gc97 = groupby(chem97, :Score)
    # combine(gc97, )

    show(names(barley))
    println("\n")
    sort(transform(barley, :Variety => ByRow(levelcode) => :levelcode), :levelcode) |> show
    println("\n")
    sort(transform(barley, :Site => ByRow(levelcode) => :levelcode), :levelcode) |> show
    # show(stdout, "text/plain", sort(zip(unique(levelcode.(barley.Variety)), unique(barley.Variety)) |> collect))
    # println("\n")
    # show(describe(barley))
    # println("\n")
    # gbarley = groupby(barley, :Variety)
    # barleyYieldSort = sort(combine(gbarley, :Yield => median => :medianYield), :medianYield, rev = true)
    # show(barleyYieldSort)
    # yieldLevels = reverse(barleyYieldSort.Variety)
    # println("\n")
    # ybarley = deepcopy(barley)
    # levels!(ybarley.Variety, yieldLevels)
    # show(stdout, "text/plain", sort(zip(unique(levelcode.(ybarley.Variety)), unique(ybarley.Variety)) |> collect))
    # println("\n")
    # show(levels(barley.Variety))
    # println("\n")
    # show(unique(levelcode.(barley.Variety)))
end

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

"""
    gcsev1()

Generate figure of GCSE scores vs Chem Scores
"""
function gcsev1()
    ptheme = Theme(; fontsize=8, fonts=(; regular="TheSansMonoCd Office"))
    set_theme!(ptheme)
    fig = Figure(; size=(6inch, 2.5inch))
    ax = Axis(fig[1, 1]; title="GCSEScore Distribution")
    density!(chem97.GCSEScore, color = (:blue, 0.3))
    ax2 = Axis(fig[2, 1]; title="Chem Score Distribution", xticks = 0:2:10)
    hist!(ax2, chem97.Score, strokecolor = :black)
    set_theme!()
    return save("figures/gcsev1.pdf", fig)
end

"""
    gcsev2()

Generate figure of GCSE scores vs Chem Scores
"""
function gcsev2()
    gc97 = groupby(chem97, :Score)
    indx = eachindex(IndexLinear(), gc97)
    gc97begin = firstindex(indx)
    gc97end = lastindex(indx)
    gc97labels = [string(k.Score) for k in keys(gc97)]

    ptheme = Theme(; fontsize=8, fonts=(; regular = usualf, labelf = labelsf))
    set_theme!(ptheme)
    fig = Figure()
    for i in indx
        xlabel = (i == gc97end ? "GCSE Score" : "")
        title = (i == gc97begin ? "Chem Score: "*gc97labels[i] : gc97labels[i])
        xtvis = (i == gc97end ? true : false)
        xt = (i == gc97end ? (0:2:8) : Float64[-1])
        ax = Axis(fig[i, 1], title = title,
                  titlealign= :left,
                  limits = ((0,8), (0, 0.8)),
                  xticks = xt, xticksvisible = xtvis,
                  xlabel = xlabel, xlabelfont = :labelf, titlefont = :labelf)
        density!(ax, gc97[i].GCSEScore)
        (i == gc97end ? continue : hidedecorations!(ax, grid=false))
    end
    rowgap!(fig.layout, 1)
    set_theme!()
    return save("figures/gcsev2.pdf", fig)
end

end # module latticebook
