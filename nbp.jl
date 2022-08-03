open("Julia_Lang/arch_cleared.csv", "w") do io
   write(io, readuntil("Julia_Lang/archiwum.csv", "\n\r\n"))
end
s = readlines("Julia_Lang/arch_cleared.csv")
deleteat!(s, 2)

println(s[2])

s_keys = popfirst!(s)

s_keys = split(strip(s_keys, ['\t', '\n', ')', '(', '\r']), ";")
popat!(s_keys, lastindex(s_keys))
popat!(s_keys, lastindex(s_keys))


d = Dict{Any, Any}()
arr = Array{Array, 1}()

n = 1
for line in s
   ln_raw = split(strip(replace(line, "," => "."), ['\t', '\n', ')', '(']), ";")
   popat!(ln_raw, lastindex(ln_raw))
   popat!(ln_raw, lastindex(ln_raw))
   cleaned = map(x -> parse(Float64, x), ln_raw)
   for num in 1:length(cleaned)
      if n == 1
         push!(arr, [cleaned[num]])
      else
      push!(arr[num], cleaned[num])
      end
   end
   n = 0
end

map(x -> parse(String, x), arr[1])

for num in 1:length(s_keys)
   d[s_keys[num]] = arr[num]
end

hold(false)

plot(1:length(d["1USD"]),d["1GBP"]./d["1USD"])
xlabel("\$days\$")
ylabel("\$GBP/USD\$")
title("GBP/USD")

hold(false)

plot(1:length(d["1USD"]),d["1EUR"]./d["1USD"])
xlabel("\$days\$")
ylabel("\$EUR/USD\$")
title("EUR/USD")


hold(false)

plot(1:length(d["1USD"]),d["1CHF"]./d["1USD"])
xlabel("\$days\$")
ylabel("\$CHF/USD\$")
title("CHF/USD")
