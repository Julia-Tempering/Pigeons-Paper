using LinearAlgebra 
using Distributions

"""
Compute the acceptance ratio for a MH random walk. 
Assumes that the proposal is standard normal and that there are exactly two dimensions!
"""
function acceptance_ratio(x_0, x_1, target_pdf)
    return min(1.0, target_pdf(x_1) * pdf(MvNormal([x_1[1], x_1[2]], I), x_0) / 
           (target_pdf(x_0) * pdf(MvNormal([x_0[1], x_0[2]], I), x_1)))
end

"""
Very primitive implementation of a Metropolis-Hastings random walk 
with a standard normal proposal with exactly two dimensions. (Used only for plotting purposes.)
"""
function MH_walk(rng, x_0, n, target_pdf)
    xs = Vector{Vector{Float64}}(undef, n+1)
    xs[1] = x_0
    for i in 2:(n+1)
        x_prev = xs[i-1]
        x_prop = x_prev + rand(rng, MvNormal([0.0, 0.0], I))
        α = acceptance_ratio(x_prev, x_prop, target_pdf)
        U = rand(rng, Uniform(0.0, 1.0))
        if U ≤ α
            xs[i] = x_prop 
        else 
            xs[i] = copy(x_prev)
        end
    end
    return xs
end