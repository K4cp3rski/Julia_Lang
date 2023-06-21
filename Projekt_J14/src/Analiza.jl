using DataFrames
using CSV
using GRUtils
using StatsBase
using HypothesisTests
using Printf
using LsqFit
using LinearAlgebra
using Distributions
using Roots
using Dierckx
include("BraggCurve.jl")
include("Plots.jl")
include("Data_Loading.jl")
include("Obróbka.jl")


function main()

filenames = ["0041.Spe", "0485.Spe", "0994.Spe", "1499.Spe", "2001.Spe", "2507.Spe", "3001.Spe", "3250.Spe", "3524.Spe", "3754.Spe", "3850.Spe", "3898.Spe", "3949.Spe", "4000.Spe", "4062.Spe"]

colnames = ["0041", "0485", "0994", "1499", "2001", "2507", "3001", "3250", "3524", "3754", "3850", "3898", "3949", "4000", "4062"]
x = 1:1:4096

# Ładowanie plików z "filenames" do DataFrame

df = load_data_df(filenames, colnames)

fig = plot_fig_1_peaks(df)

res = Array{Float64, 1}()
press = Array{Float64, 1}()
for (col, pressure) in zip(eachcol(df), names(df))
    push!(res, sum(col))
    push!(press, parse(Float64, pressure)/100)
end

# Kalibracja

## Definicja funkcji liniowej
@. lin(x, p) = p[1] * x + p[2]
@. gauss(x, p) = p[2] / sqrt(2 * pi * p[3]^2) * exp(-(x - p[1])^2 / (2 * p[3]^2))

## Kalibracja ciśnienia (V -> bar)

ps_v = [46.4, 0.41]
ps_bar = [1.0049, 0.004]

ps_pts = [1.023,0]
len_pts = [39.5, 0]

f_v_to_len = get_calibrated_funcs(lin, ps_v, ps_bar, ps_pts, len_pts)


## Kalibracja Energii

kal_names = ["2123", "1623", "1123", "623", "123"]

df_kal = load_kal_df(kal_names, filenames)

# Wyskalowana funkcja do przeliczania woltów na bary
fcal = get_func_volt_to_bar(kal_names, df_kal, lin)

## Wykres kalibracji energii na podstawie pulsera
sleep(5)
fig2 = plot_fig_2_peaks(df_kal, lin, x)

## Obróbka danych

res = Array{Float64, 1}()
press = Array{Float64, 1}()
for (col, pressure) in zip(eachcol(df), names(df))
    append!(res, float(sum(col)))
    append!(press, parse(Float64, pressure)/100)
end

# println(press)

fn = curve_fit(lin, press[end-5:end-2], res[end-5:end-2], [-20,1.0])
xf = 37.75:0.1:41
x_tot = 0:0.001:press[end]
x_gauss = 0:0.001:60

f_lin(p) = fn.param[1]*p + fn.param[2]

energies = Array{Float64, 1}()
fit_gauss = Array{Vector{Float64}, 1}()
for col in eachcol(df)
    rownum = findfirst(==(maximum(col)), col)
    fitA1 = curve_fit(gauss, fcal.(x), col, [fcal(rownum), 1000 , 0.1])
    push!(fit_gauss, fitA1.param)
    push!(energies, fcal(rownum))
end
spl = Spline1D(press, res, k=3, bc="extrapolate", s=10)
spl2 = Spline1D(f_v_to_len.(press), energies, k=3, bc="extrapolate", s=10)

μ = maximum(res)/2
rbar_gauss = find_zero(x->f_lin(x)-μ, 0)
re_gauss = find_zero(f_lin, 0)
σᵣ_gauss = (re_gauss - rbar_gauss)/(sqrt(π/2))
rbar = f_v_to_len(find_zero(x->f_lin(x)-μ, 0))
re = f_v_to_len(find_zero(f_lin, 0))
σᵣ = (re - rbar)/(sqrt(π/2))

thicks = Array{String, 1}()
for len in f_v_to_len(press)
    push!(thicks, @sprintf("%.2f cm",len))
end

println("Zasięg:\n")
println(@sprintf("R̄ = %.3f cm, Rₑ = %.3f cm, Straggling σᵣ = %.3e cm", rbar, re, σᵣ))


sleep(5)
## Wykres pików absorpcji od energii

fig3 = plot_fig_3_absorpcja(fcal, df, thicks, x)
sleep(5)

## Krzywa absorpcji

fig4 = plot_fig_4(xf, x_tot, x_gauss, press, f_v_to_len, res, fn, spl, rbar_gauss, σᵣ_gauss, x, lin, μ)
sleep(5)
## Energia od długości

fig5 = plot_fig_5(press, energies, spl2, f_v_to_len, x, lin)
sleep(5)
dedx_tab = Array{Float64, 1}()
for no in 2:1:length(press)
    x_tab = f_v_to_len.(press)
    en_tab = energies
    dedx = -(en_tab[no-1]-en_tab[no])/(x_tab[no-1] - x_tab[no])
    push!(dedx_tab, dedx)
end
println(press, "\n")
println(dedx_tab)
println(energies)

fig6 = plot_fig_6(dedx_tab, press, spl2, f_v_to_len, rbar, σᵣ)
end
