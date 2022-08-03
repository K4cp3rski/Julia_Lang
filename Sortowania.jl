using BenchmarkTools
using GRUtils
using StatsBase
using SortingAlgorithms

function HeapSort_my(tab)
    heap = copy(tab)
    shape = size(heap)[1]
    out = []
    max_ind = 1
    for el = 2:shape
        if heap[el] > heap[max_ind]
            max_ind = el
        end
    end
    heap[1], heap[max_ind] = heap[max_ind], heap[1]

    while shape > 0
        for el = shape:-1:2
            par_ind = Int64(floor(el / 2))
            if heap[par_ind] < heap[el]
                heap[par_ind], heap[el] = heap[el], heap[par_ind]
            end
        end
        append!(out, heap[1])
        deleteat!(heap, 1)
        shape = size(heap)[1]
    end
    return out
end

function choiceSort!(tab)
    shape = size(tab)[1]
    #     Numer elementu który aktualnie jest porównywany
    el_num = 1
    while el_num < shape + 1
        #     Najmniejszy element większy od obecnie porównywanej
        ind_min = el_num
        for el = el_num+1:shape-1
            if tab[el] < tab[el_num]
                if ind_min == el_num
                    ind_min = el
                elseif tab[el] < tab[ind_min]
                    ind_min = el
                end
            end
            tab[ind_min], tab[el_num] = tab[el_num], tab[ind_min]
        end
        el_num += 1
    end
    return tab
end

x = rand(1:10000, 100)


function main()
    N = [10, 100, 1000, 10000]
    for alg in [QuickSort, InsertionSort, HeapSort, TimSort]
        t = zeros(size(N))
        for (i, n) in enumerate(N)
            b = @benchmark sort(rand($n), alg = $alg) samples = 10
            t[i] = mean(b.times)
        end
        plot(N, t, "o")
        hold(true)
    end
    plot(N, N .* log.(N), "-")
    plot(N, N .^ 2, "--")
    xlog(true)
    ylog(true)
    legend("Quick", "Insert", "Heap", "Tim", location = 2)
    xlim(1, 1e6)
    ylim(1e2, 1e10)
    xlabel("N")
    ylabel("t(s)")
end
