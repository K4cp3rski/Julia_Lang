using GRUtils
using SpecialFunctions
using HypergeometricFunctions

# X = 5.275565227081652*1e+6
# Xⁱ = 0.9266125437274719
# tspan = (0.0, 3.5)
# u0 = X
#
# E = X # MeV → eV
# # x = t # cm
# κ = 0.307*1e+6 # eV cm^2/g
# ρ = 1.225*(1/1000)/((1/100)^3) # kg/m³ → g/cm³
# a_z_frac = 14/(2*14.007)*0.78080 + 16/(15.999*2)*0.20950 + 18/(39.948)*0.009340 # 78.080% N₂, 20.950% O₂, 0.9340% Ar
# z = 2*1.602176634e-16 # g
# mₑ = 9.1093837015e-28 # g
# m = 6.644657230e-24 # g
# I = 80.5 # eV
# c = 299792458 # m/s
# dotE = - κ*(ρ*m*c^2*z^2*a_z_frac)/(2*E) * log.((4 * mₑ * c^2 * E)/(I*m*c^2))
#
# f(E, t, p) = (E -> - κ*(ρ*m*c^2*z^2*a_z_frac)/(2*E) * log.((4 * mₑ * c^2 * E)/(I*m*c^2)))(E)
#
# prob = ODEProblem(f,u0,tspan)

# sol = solve(prob, Tsit5())
# hold(false)
# plot(sol.t, sol.)
# display(gcf())

function RK4(func, X0, t)
    """
    Runge Kutta 4 solver.
    """
    dt = t[2] - t[1]
    nt = length(t)
    X  = zeros(nt, length(X0))
    X[1, :] = X0
    for i in 1:1:nt-1
        k1 = func(X[i, :], t[i])
        k2 = func(X[i, :] .+ dt/2. .* k1, t[i] + dt/2.)
        k3 = func(X[i, :] .+ dt/2. .* k2, t[i] + dt/2.)
        k4 = func(X[i, :] .+ dt    .* k3, t[i] + dt)
        X[i+1, :] = X[i, :]  .+ dt/6. .* (k1 .+ 2. .* k2 .+ 2. .* k3 .+ k4)
    end
    return X
end

function der(X, t)
    E = X[1] # MeV → eV
    x = t # cm
    κ = 0.307*1e+6 # eV cm^2/g
    ρ = 1.225*(1/1000)/((1/100)^3) # kg/m³ → g/cm³
    a_z_frac = 14/(2*14.007)*0.78080 + 16/(15.999*2)*0.20950 + 18/(39.948)*0.009340 # 78.080% N₂, 20.950% O₂, 0.9340% Ar
    z = 2*1.602176634e-16 # g
    mₑ = 9.1093837015e-28 # g
    m = 6.644657230e-24 # g
    I = 80.5 # eV
    c = 299792458 # m/s
    dotE = - κ*(ρ*m*c^2*z^2*a_z_frac)/(2*E) * log.((4 * mₑ * c^2 * E)/(I*m*c^2))
    return [E, dotE]
end

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


function get_bragg(R0, sigma, scale=1, epsilon=-0.8, p=1.77)
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
