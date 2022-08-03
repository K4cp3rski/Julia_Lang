using CSV
using GRUtils
using Dates
using DataFrames
using StatsBase

df = DataFrame(CSV.File("Julia_Lang/pleszew.csv", header=15, skipto=16, delim=",", ignorerepeated=true))

df[:, [:T2M, :PRECTOTCORR]]

transform!(df, [:YEAR, :MO, :DY] => ((y, m, d) -> Date.(y, m, d)) => :Date)

select!(df, Not([:YEAR, :MO, :DY]))

hold(false)
trange = Dates.value.(df.Date - Date(2021, 1, 1))
plot(df.PS, df.WS10M, "+r")
hold(true)
plot(df.PS, df.WS50M, "^b")

h = fit(Histogram, df.WS10M, nbins=20)
h2 = fit(Histogram, df.WS50M, nbins=20)

hold(false)
stairs(h.edges[1][1:end-1], h.weights)
hold(true)
stairs(h2.edges[1][1:end-1], h2.weights)
