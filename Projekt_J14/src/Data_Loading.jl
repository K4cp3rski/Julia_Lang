using DataFrames
using CSV
using Printf


function load_data_df(filenames, names)
    df = DataFrame(CSV.File(@sprintf("./src/data/%s", filenames[1]), skipto=13, header=false, footerskip=16, delim="\t"))
    for file in filenames
        if file == filenames[1]
            continue
        else
            df_new = DataFrame(CSV.File(@sprintf("./src/data/%s", file), skipto=13, header=false, footerskip=15, delim="\t"))
            df = hcat(df, df_new, makeunique=true)
        end
    end
    rename!(df, Symbol.(names))
    return df
end

function load_kal_df(kal_names, filenames)
    df_kal = DataFrame(CSV.File(@sprintf("./src/data/%s", filenames[1]), skipto=13, header=false, footerskip=16, delim="\t"))
    for file in kal_names
        if file == kal_names[1]
            continue
        else
            df_new = DataFrame(CSV.File(@sprintf("./src/data/kalibracja_%s.Spe", file), skipto=13, header=false, footerskip=15, delim="\t"))
            df_kal = hcat(df_kal, df_new, makeunique=true)
        end
    end
    rename!(df_kal, Symbol.(kal_names))
    return df_kal
end
