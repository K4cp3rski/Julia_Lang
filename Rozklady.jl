using CSV
using GRUtils
using Dates
using DataFrames
using StatsBase
using HypothesisTests
using LsqFit
using Distributions

df = DataFrame(CSV.File("Julia_Lang/wind.csv", header=14, skipto=15, delim=",", ignorerepeated=true))

h = fit(Histogram, df.WS2M, nbins=100)

hold(false)



plot(h.edges[1][1:end-1], h.weights, "o")

ln(x,p) = pdf.(LogNormal(p...), x)

pl = curve_fit(ln, h.edges[1][1:end-1], h.weights, [3.0, 2.0])
