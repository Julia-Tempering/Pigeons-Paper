"""
    Generate a figure for a bimodal distribution.
"""
    
using Plots
using Distributions
using Random
    
include("distributions.jl")
include("MH_walk.jl")

function main()
    a = 2.5
    res = 1_000
    n_walk = 1_000

    xs = range((-a-4.0), (a+4.0), length = res)
    ys = copy(xs)
    z = zeros(res, res)
    for i in 1:res
        x = xs[i]
        for j in 1:res
            y = ys[j]
            z[i, j] = target_pdf(x, y, a)
        end
    end
    p = heatmap(
        xs, ys, z,
        colorbar = :none, border = :none, margin = (0.0,:mm), axis = nothing,
        aspect_ratio = :equal, size = (500, 500)
    )

    function target_pdf_2(x) 
        target_pdf(x[1], x[2], a)
    end
    rng = MersenneTwister(2)
    walk = MH_walk(rng, [-a, -a], n_walk, target_pdf_2)
    plot!(
        p, [walk[i][1] for i in eachindex(walk)], 
        [walk[i][2] for i in eachindex(walk)], color = 1,
        linewidth = 2, legend_position = :none, alpha = 0.5
    )
    savefig(p, "img/bimodal.pdf")
end


main()