using GRUtils
using SpecialPolynomials

Figure()
x = -2:0.01:2
# plot(x, H2.(x), "-r")
# hold(true)
# plot(x, H3.(x), "-b")
# ylim(-20, 20)

for n in 1:6
    Hₙ = basis(Hermite, n-1)
    fig = subplot(3, 2, n)
    ψₙ = @.  1/√(2^(n-1) * factorial(n-1))*(1/π)^(0.25)*exp(-0.5*x^2)*Hₙ(x)
    plot(x, ψₙ, "-r")
    hold(true)
    plot(x, ψₙ.^2, "b--")
    title("n = $(n-1)")
    ylabel("\$\\Psi_$n(x)\$")
    hold(false)
end



display(gcf())
