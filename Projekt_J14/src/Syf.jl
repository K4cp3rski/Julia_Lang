using GRUtils
using SpecialFunctions
using HypergeometricFunctions
using Dierckx

ps_v = [46.4, 0.41]
ps_bar = [1.0049, 0.004]
ps_pts = [1.023,0]
len_pts = [39.5, 0]

rbar = 3.253-0.15
σᵣ = 8.649e-02-1e-2

press = [0.41, 4.85, 9.94, 14.99, 20.01, 25.07, 30.01, 32.5, 35.24, 37.54, 38.5, 38.98, 39.49, 40.0, 40.62]
dedx_tab = [1.0755668512856664, 1.1278908179575475, 1.2153440238883184, 1.3702814813408013, 1.502549134209977, 1.828710455814305, 2.1671331746751905, 2.409843397649878, 2.885848337133454, 2.1370581435969136, 1.2930099692351427, 0.101412546606675, 0.0676083644044501, -0.02780666600505637]
energies = [5.275565227081652, 4.874265263233425, 4.3918360648166015, 3.8760859307733924, 3.298040134472154, 2.6591474122444696, 1.9000095744954748, 1.446555102710293, 0.8916890877143673, 0.3339256000552777, 0.16152597659701362, 0.1093714686600598, 0.10502525966531365, 0.10212778700214954, 0.10357652333373159]

function pbdv(a,z)
    return 1/(sqrt(π)) * 2^(a/2)*exp(-0.25*z^2)*(cos((π*a)/(2))*gamma((a+1)/(2))*HypergeometricFunctions.M(-0.5*a, 0.5, 0.5*z^2) + sqrt(2)*z*sin((π*a)/(2))*gamma(0.5*a+1)*HypergeometricFunctions.M(0.5-0.5*a, 1.5, 0.5*z^2))
end

function cyl_gauss(a, x)
    "Calculate product of Gaussian and parabolic cylinder function"
    y = copy(x)
    branch = -12.0   #for large negative values of the argument we run into numerical problems, need to approximate result
    x1 = 0
    x2 = 0
    y1 = 0
    y2 = 0
    if x<branch
        x1 = x
        y1 = @. sqrt(2*π)/gamma(-a)*(-x1)^(-a-1)
        y = y1
    else

    x2 = x
    y2a = pbdv(a,x2)     #special function yielding parabolic cylinder function
    y2b = exp(-x2*x2/4)
    y2 = y2a*y2b

    y = y2
end

    return y
end


function bragg(R0, sigma, scale=1, epsilon=-0.1, p=1.50)
    "
    R₀ - Range
    σᵣ - Straggling sigma
    ϵ - low energy contamination
    p - exponent of range-energy relationship
    "

    z = 0:(1.1*R0/200):1.1*R0

    out = 0.65*(cyl_gauss.(-1 ./p,(z.-R0)./sigma).+sigma.*(0.01394.+epsilon./R0).*cyl_gauss.(-1 ./p-1,(z.-R0)./sigma))

    out *= 1 ./out[1].*scale

    return out
end



@. lin(x, p) = p[1] * x + p[2]
f_v_to_len = get_calibrated_funcs(lin, ps_v, ps_bar, ps_pts, len_pts)

spl2 = Spline1D(f_v_to_len.(press), energies, k=3, bc="extrapolate", s=10)
spl3 = Spline1D(f_v_to_len.(press[1:end-1]), dedx_tab, k=3, bc="extrapolate", s=10)

hold(false)
plot(f_v_to_len.(press[1:end-1]), dedx_tab, "x")
hold(true)
plot(0:(1.1*rbar/200):1.1*rbar, bragg(rbar, σᵣ))
legend("Dane pomiarowe", "Krzywa Bragga", location="upper left")
ylabel("dE/dx [MeV]")
xlabel("Grubość warstwy absorbującej [cm]")
yticks(0.25, 2)
xticks(0.1, 3)
xlim(0,4)
ylim(0,3.5)
title("Wykres strat energii w funkcji przebytej drogi")
savefig("bardziejkrzywaBragga.pdf", gcf())
display(gcf())
