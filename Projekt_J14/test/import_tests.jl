using Projekt_J14
using Test

filenames = ["0041.Spe", "0485.Spe", "0994.Spe", "1499.Spe", "2001.Spe", "2507.Spe", "3001.Spe", "3250.Spe", "3524.Spe", "3754.Spe", "3850.Spe", "3898.Spe", "3949.Spe", "4000.Spe", "4062.Spe"]

colnames = ["0041", "0485", "0994", "1499", "2001", "2507", "3001", "3250", "3524", "3754", "3850", "3898", "3949", "4000", "4062"]

kal_names = ["2123", "1623", "1123", "623", "123"]

@testset "Import Data" begin
    df = load_data_df(filenames, colnames)
    kal_df = load_kal_df(kal_names)
    df_size = (4096, 15)
    kal_df_size = (4096, 5)
    @test size(df) == df_size
    @test names(df) == colnames
    @test size(kal_df) == kal_df_size
    @test names(kal_df) == kal_names
end
