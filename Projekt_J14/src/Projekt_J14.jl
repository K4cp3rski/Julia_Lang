module Projekt_J14

include("Analiza.jl")
include("BraggCurve.jl")
include("Plots.jl")
include("Data_Loading.jl")

export main, get_bragg,  load_data_df, load_kal_df, get_calibrated_funcs, get_func_volt_to_bar
export plot_fig_1_peaks, plot_fig_2_peaks, plot_fig_3_absorpcja, plot_fig_4, plot_fig_5, get_bragg
end
