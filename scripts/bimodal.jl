"""
    Generate a figure for a bimodal distribution.
"""
    
using Plots
using Distributions
using Random
using Pigeons

include("distributions.jl")
include("MH_walk.jl")

struct MyLogPotential 
    a::Float64
end
struct MyLogPotentialReference 
    a::Float64
end
(lp::MyLogPotential)(x) = log(target_pdf(x[1], x[2], lp.a)) # numerically unstable but OK for purposes of illustration 
(lp::MyLogPotentialReference)(x) = log(reference_pdf(x[1], x[2], lp.a))
Pigeons.initialization(::MyLogPotential, ::AbstractRNG, ::Int) = [0.0, 0.0]
function Pigeons.sample_iid!(lp::MyLogPotentialReference, replica, shared)
    state = replica.state
    rng = replica.rng
    randn!(rng, state)
    state .= state .* sqrt(lp.a^2 + 1)
end

function main()
    # simulation settings
    a = 2.5
    res = 1_000
    n_walk = 1_000

    # base heatmap plot
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
    p2 = deepcopy(p)

    # define targets
    function target_pdf_2(x) 
        target_pdf(x[1], x[2], a)
    end
    
    # get samples (MH and Pigeons)
    rng = MersenneTwister(2)
    walk = MH_walk(rng, [-a, -a], n_walk, target_pdf_2)
    pt = pigeons(
        target = MyLogPotential(a), 
        reference = MyLogPotentialReference(a), 
        n_chains = 10, 
        n_rounds = Int(ceil(log2(n_walk))),
        record = [traces]
    )
    samples = get_sample(pt)

    # make plots
    plot!(
        p, [walk[i][1] for i in eachindex(walk)], 
        [walk[i][2] for i in eachindex(walk)], color = 1,
        linewidth = 2, legend_position = :none, alpha = 0.5
    )
    savefig(p, "img/bimodal.pdf")

    plot!(
        p2, [samples[i][1] for i in eachindex(samples)], 
        [samples[i][2] for i in eachindex(samples)], color = 1, 
        linewidth = 2, legend_position = :none, alpha = 0.5, 
        seriestype = :scatter
    )
    savefig(p2, "img/bimodal_pigeons.pdf")
end


main()