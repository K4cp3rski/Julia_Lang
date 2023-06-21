using Projekt_J14
using GRUtils


function plot_fig_1_peaks(df)
    fig = Figure((1100, 700), "pix")
    hold(true)
    for (col, name) in zip(eachcol(df), names(df))
        plot(col)
    end
    legend("00.41", "04.85", "09.94", "14.99", "20.01", "25.07", "30.01", "32.50", "35.24", "37.54", "38.50", "38.98", "39.49", "40.00", "40.62")
    display(gcf())
    xlabel("Kanał")
    ylabel("Zliczenia")
    title("Pełen zakres zebranych danych")
    savefig("peaks.pdf", gcf())
    return fig
end

function plot_fig_2_peaks(df_kal, lin, x)
    kal_names = ["2123", "1623", "1123", "623", "123"]
    fcal = get_func_volt_to_bar(kal_names, df_kal, lin)
    hold(false)
    fig2 = Figure((1000, 600), "pix")
    for col in eachcol(df_kal)
        plot(fcal.(x), col)
        hold(true)
    end
    legend("Kanał Pulsera 2123", "Kanał Pulsera 1623", "Kanał Pulsera 1123", "Kanał Pulsera 623", "Kanał Pulsera 123", location=2)
    xticks(0.25, 2)
    xlabel("Energia [MeV]")
    ylabel("Zliczenia")
    title("Dane do kalibracji energii")
    display(gcf())
    savefig("peaks_kalibracja_energy.pdf", gcf())
    return fig2
end

function plot_fig_3_absorpcja(fcal, df, thicks,x)
    hold(false)
    fig3 = Figure((1000, 600), "pix")
    for col in eachcol(df)
        plot(fcal.(x), col)
        hold(true)
    end
    legend(thicks..., location="outer upper right")
    xticks(0.25, 2)
    xlabel("Energia [MeV]")
    ylabel("Zliczenia")
    title("Zebrane dane po skalibrowaniu energii i przeliczeniu ciśnienia na drogę przebytą w powietrzu")
    display(gcf())
    savefig("peaks_energy.pdf", gcf())
    return fig3
end


function plot_fig_4(xf, x_tot, x_gauss, press, f_v_to_len, res, fn, spl, rbar_gauss, σᵣ_gauss,x,lin, μ)
    hold(false)
    fig4 = Figure((1000, 600), "pix")
    plot(f_v_to_len.(press), res./1e+4, "x")
    hold(true)
    plot(f_v_to_len.(xf), lin(xf, fn.param)./1e+4, "-")
    plot(f_v_to_len.(x_tot), evaluate(spl, x_tot)./1e+4)
    plot(f_v_to_len.(x_gauss), pdf.(Normal(rbar_gauss, σᵣ_gauss), x_gauss)*μ*2.5./1e+4)
    plot(f_v_to_len.(ones(size(0:0.1:μ./1e+4))*rbar_gauss), 0:0.1:μ./1e+4, "k--")
    labels = ["Dane pomiarowe", "Zasięg ekstrapolowany", "Interpolacja danych pomiarowych", "Krzywa zasięgowa", "Średni zasięg"]
    ylim(0, 9)
    xlim(0, 4)
    yticks(0.25, 4)
    xticks(0.1, 3)
    xlabel("Grubość warstwy absorbującej [cm]")
    ylabel("Zliczenia (⋅10^{4})")
    title("Wykres absorpcji")
    legend(labels..., location=3)
    display(gcf())
    savefig("absorpcja.pdf", gcf())
    return fig4
end

function plot_fig_5(press, energies, spl2, f_v_to_len,x, lin)
    hold(false)
    fig5 = Figure((1000, 600), "pix")
    hold(false)
    plot(f_v_to_len.(press), energies, "x")
    hold(true)
    plot(f_v_to_len.(press), evaluate(spl2, f_v_to_len.(press)))
    ylabel("Energia [MeV]")
    xlabel("Grubość warstwy absorbującej [cm]")
    yticks(0.25, 2)
    xticks(0.1, 3)
    ylim(0,6)
    title("Energia cząstek α w funkcji drogi przebytej w powietrzu")
    savefig("energia_vs_absorber.pdf", gcf())
    display(gcf())
    return fig5
end

function plot_fig_6(dedx_tab, press, spl2, f_v_to_len, rbar, σᵣ)
    fig6 = Figure((1000, 600), "pix")
    hold(false)

    plot(f_v_to_len.(press[1:end-1]), dedx_tab, "x")
    hold(true)
    plot(0:(1.1*rbar/200):1.1*rbar, get_bragg(rbar, σᵣ))
    legend("Dane pomiarowe", "Krzywa Bragga", location="upper left")
    ylabel("dE/dx [MeV]")
    xlabel("Grubość warstwy absorbującej [cm]")
    yticks(0.25, 2)
    xticks(0.1, 3)
    xlim(0,4.5)
    ylim(0,3.5)
    title("Wykres strat energii w funkcji przebytej drogi")
    savefig("niekrzywaBragga.pdf", gcf())
    display(gcf())
    return fig6
end
