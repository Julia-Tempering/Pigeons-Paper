"""
    Generate MH-walk figures for a unimodal distribution.
"""
    
using Plots
using Distributions
using Random
    
include("MH_walk.jl")

target_pdf(x, y) = pdf(Normal(0.0, 1.0), x) * pdf(Normal(0.0, 1.0), y)

function main()
    res = 1_000
    n_walk = 200

    xs = range(-4.0, 4.0, length = res)
    ys = copy(xs)
    z = zeros(res, res)
    for i in 1:res
        x = xs[i]
        for j in 1:res
            y = ys[j]
            z[i, j] = target_pdf(x, y)
        end
    end
    

    function target_pdf_2(x) 
        target_pdf(x[1], x[2])
    end

    anim = @animate for n in 1:n_walk
        rng = MersenneTwister(1)
        walk = MH_walk(rng, [0.0, 0.0], n, target_pdf_2)
        p = heatmap(
            xs, ys, z,
            colorbar = :none, border = :none, margin = (0.0,:mm), axis = nothing,
            aspect_ratio = :equal, size = (500, 500)
        )
        plot!(
            p, [walk[i][1] for i in eachindex(walk)], 
            [walk[i][2] for i in eachindex(walk)], color = 1,
            linewidth = 2, legend_position = :none, alpha = 0.5
        )
        # savefig(p, "results/unimodal/unimodal_" * string(n) * ".pdf")
    end
    gif(anim, "results/unimodal/unimodal.gif", fps = 15)
end


main()