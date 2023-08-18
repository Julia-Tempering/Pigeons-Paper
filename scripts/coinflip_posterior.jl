using Distributions 
using Random 
using Plots 

function coinflip_posterior(n, n_success) 
    n_fail = n - n_success 
    x = range(0.0, 1.0, length = 1_000)
    y = pdf.(Beta(n_success + 1, n_fail + 1), x)
    p = Plots.plot(
        x, y, ylims = (0.0, 10.0), xlims = (0.0, 1.0), linewidth = 2, 
        xticks = 0.0:0.1:1.0, legend = false, xlabel = "θ", ylabel = "π(θ|x)"
    )
    return p 
end 


function main() 
    # settings 
    n_flips = 100 
    true_prob = 0.75
    rng = MersenneTwister(1)
    plot_indices = vcat(0:10, n_flips) # which plots to save

    y = []
    for n in 0:n_flips 
        if n == 0 
            p = coinflip_posterior(0, 0) # plot uniform distribution 
        else
            y = vcat(y, rand(rng, Bernoulli(true_prob)))
            n_success = sum(y)
            p = coinflip_posterior(n, n_success)
        end
        if n in plot_indices
            display(p)
            savefig(p, "results/coinflip/coinflip_posterior_" * string(n) * ".png")
        end
    end 
end 

main()
