filenames = ["0041.Spe", "0485.Spe", "0994.Spe", "1499.Spe", "2001.Spe", "2507.Spe", "3001.Spe", "3250.Spe", "3524.Spe", "3754.Spe", "3850.Spe", "3898.Spe", "3949.Spe", "4000.Spe", "4062.Spe"]

colnames = ["0041", "0485", "0994", "1499", "2001", "2507", "3001", "3250", "3524", "3754", "3850", "3898", "3949", "4000", "4062"]


df = load_data_df(filenames, colnames)

@testset "Fig_1"  begin
    fig = plot_fig_1_peaks(df)
    @test length(fig.plots[1].geoms) == length(colnames)
    @test fig.plots[1].attributes[:hold] == true
end
