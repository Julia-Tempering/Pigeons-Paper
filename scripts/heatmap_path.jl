"""
    Generate a path of heatmaps from a unimodal reference to a bimodal target.
"""

using Plots
using Distributions

include("distributions.jl")

function main()
    a = 2.5
    res = 1_000
    βs = [0.0, 0.05, 0.15, 0.25, 0.5, 1.0]

    xs = range((-a-4.0), (a+4.0), length = res)
    ys = copy(xs)
    z = zeros(res, res)
    k = 1
    for β in βs
        for i in 1:res
            x = xs[i]
            for j in 1:res
                y = ys[j]
                z[i, j] = reference_pdf(x, y, a)^(1-β) * target_pdf(x, y, a)^β
            end
        end
        p = heatmap(xs, ys, z,
                colorbar = :none, border = :none, margin = (0.0,:mm), axis = nothing,
                aspect_ratio = :equal, size = (500, 500))
        savefig(p, "img/heatmap_path_$k.pdf")
        k += 1
    end
end

main()