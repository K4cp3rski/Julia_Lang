using GRUtils

x₁ = parse(Float64, readline(stdin))
y₁ = parse(Float64, readline(stdin))
x₂ = parse(Float64, readline(stdin))
y₂ = parse(Float64, readline(stdin))
if x₁ == x₂
    println(stderr, "Podaj x₁ != x₂")
    exit(1)
end

if typeof(x₁)<:Number && typeof(x₂)<:Number && typeof(y₁)<:Number && typeof(y₂)<:Number
    println(stdout, "($x₁, $y₁), ($x₂, $y₂)")
    x = (x₁ - 2):0.1:(x₂ + 2)
    a = (y₂ - y₁)/(x₂ - x₁)
    b = y₂ - a*x₂
    y = a.*x .+ b
    println(stdout, "a = $a, b = $b")
    plot(x, y)
    legend("\$f(x) = $a x + $b\$")
    xlabel("\$x\$")
    ylabel("\$y\$")
else
    println(stderr, "Podaj wartości liczbowe")
    exit(1)
end
