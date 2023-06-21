using DataFrames
using StatsBase
using HypothesisTests
using Printf
using LsqFit
using LinearAlgebra
using Distributions
using Roots
using Dierckx

function get_calibrated_funcs(lin, ps_v, ps_bar, ps_pts, len_pts)
    fps_real = curve_fit(lin, ps_v, ps_bar, [0.218,-0.0049])
    fps_fun(x) = (x->lin(x, fps_real.param))(x)

    flen_fun = curve_fit(lin, ps_pts, len_pts, [0.218,-0.0049])
    flen_real(x) = (x->lin(x, flen_fun.param))(x)

    f_v_to_len(x) = flen_real(fps_fun(x))./10
    return f_v_to_len
end

function get_func_volt_to_bar(kal_names, df_kal, lin)
    peaks = Array{Float64, 1}()
    energies_kal = Array{Float64, 1}()
    base_energy = 5276
    mult = base_energy/parse(Int64, kal_names[1])
    for pulser_channel in kal_names
        push!(energies_kal, parse(Int64, pulser_channel)*mult)
    end
    for col in eachcol(df_kal)
        rownum = findfirst(==(maximum(col)), col)
        push!(peaks, rownum)
    end


    fcal_peaks = curve_fit(lin, peaks[1:end-1], energies_kal[1:end-1], [-20,1.0])
    # Wyskalowana funkcja do przeliczania woltów na bary
    fcal(x) = (x->lin(x, fcal_peaks.param)/1000)(x)
    return fcal
end
