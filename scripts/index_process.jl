using Plots
using Pigeons

function first_process_index(d::Dict{Int64, Vector{Int64}}) 
    for i in eachindex(d)
        if d[i][1] == 1 
            return i 
        end 
    end
    error()
end


function main()
    # settings 
    n_chains = 4
    n_rounds = 3 # 2^n_rounds iterations
    linewidth = 3
    alpha = 0.2
    acceptance = 1.0
    seed = 1
    n_iters = 5
    padding = 0.15

    # perform pigeons simulation 
    pt = pigeons(
        target            = Pigeons.TestSwapper(acceptance), 
        record = [Pigeons.round_trip, Pigeons.index_process], 
        n_chains          = n_chains, 
        n_rounds          = n_rounds, 
        seed              = seed
    )
    index_process = pt.reduced_recorders.index_process
    first_process = first_process_index(index_process)

    # make plots 
    for n_iters_sub in 2:n_iters
        p = Plots.plot(
            1:n_iters_sub,
            index_process[first_process][1:n_iters_sub], lc = 1, 
            xlims = (1-padding, n_iters+padding), ylims = (1-padding, n_chains+padding), 
            legend = false, linewidth = linewidth + 0.5, xticks = 1:1:n_iters, 
            yticks = (1:1:n_chains, 1:n_chains), xlabel = "Iteration", ylabel = "Chain number")
        if n_iters_sub != n_iters
            Plots.plot!(
                p, n_iters_sub:n_iters, index_process[first_process][n_iters_sub:n_iters], lc = 1, 
                linewidth = linewidth, alpha = alpha^2) 
        end
        for i in eachindex(index_process)
            if i != first_process
                Plots.plot!(
                    p, 1:n_iters_sub, index_process[i][1:n_iters_sub], lc = index_process[i][1], 
                    linewidth = linewidth, alpha = alpha)
                if n_iters_sub != n_iters 
                    Plots.plot!(
                        p, n_iters_sub:n_iters, index_process[i][n_iters_sub:n_iters], 
                        lc = index_process[i][1], 
                        linewidth = linewidth, alpha = alpha^2)
                end
            end 
        end 
        display(p)
        savefig(p, "results/index_process_" * string(n_iters_sub - 1) * ".pdf")
    end
end 

main()