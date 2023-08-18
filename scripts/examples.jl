using Turing
@model function coinflip(n, y)
    p1 ~ Uniform(0.0, 1.0)
    p2 ~ Uniform(0.0, 1.0)
    y ~ Binomial(n, p1 * p2)
    return y
end
model = coinflip(1e5, 5e4)

using Pigeons
pt = pigeons(
    target = TuringLogPotential(model), 
    record = [traces, online, round_trip, Pigeons.timing_extrema, Pigeons.allocation_extrema]) 

# pt_large = pigeons(
#     target = TuringLogPotential(model), 
#     record = [traces, online, round_trip, Pigeons.timing_extrema, Pigeons.allocation_extrema],
#     n_rounds = 17) # not in JCON

single_chain = pigeons(
    target = TuringLogPotential(model), 
    n_chains = 1, 
    record = [traces])

using MCMCChains, StatsPlots, PlotlyJS
# plotlyjs()
# samples = Chains(sample_array(pt), variable_names(pt))
# my_plot = StatsPlots.plot(samples)
# display(my_plot)

# using PairPlots, CairoMakie
# my_plot = PairPlots.pairplot(samples) 
# display(my_plot)

# Not a JCON code chunk ----------
# Increase the number of samples to make the estimated posterior smoother
# samples_large = Chains(sample_array(pt_large), variable_names(pt_large))
# my_plot_large = PairPlots.pairplot(samples_large)
# # CairoMakie.save("img/coinflip_posterior.pdf", my_plot_large) 
# my_traceplot_large = StatsPlots.plot(samples_large)
# display(my_traceplot_large)

sa = sample_array(pt)[:, 1, :] # not a JCON code chunk ----------
sa = reshape(sa, size(sa, 1), 1, 1)
samples = Chains(sa, [variable_names(pt)[1]])
# my_plot = StatsPlots.plot(samples)
# display(my_plot)
# turn off plotlyjs() for this plot!
my_plot_v2 = Plots.plot(
    1:(size(sa)[1]), sa[:,1,1],
    xlabel = "Iteration", ylabel = "Sample value", legend = false
)
display(my_plot_v2)
StatsPlots.savefig(my_plot_v2, "img/trace_density_plots_pt.pdf")

sa = sample_array(single_chain)[:, 1, :] # not a JCON code chunk ----------
sa = reshape(sa, size(sa, 1), 1, 1)
samples = Chains(sa, [variable_names(single_chain)[1]])
# my_plot = StatsPlots.plot(samples)
# display(my_plot)
my_plot_v2 = Plots.plot(
    1:(size(sa)[1]), sa[:,1,1],
    xlabel = "Iteration", ylabel = "Sample value", legend = false
)
display(my_plot_v2)
StatsPlots.savefig(my_plot_v2, "img/trace_density_plots_single_chain.pdf")

# stepping_stone(pt)

# using Statistics
# mean(pt); var(pt)

# Pigeons.global_barrier(pt)

# n_tempered_restarts(pt)

# # pigeons(
# #     target = TuringLogPotential(model), 
# #     checkpoint = true,
# #     on = ChildProcess(
# #             n_local_mpi_processes = 4,
# #             n_threads = 1)

# pigeons(
#     target = TuringLogPotential(model),
#     n_rounds = 10, 
#     n_chains = 10,
#     variational = GaussianReference()
# )


# # pigeons(
# #     target = TuringLogPotential(model),
# #     n_rounds = 10, 
# #     n_chains = 10,
# #     n_chains_variational = 10,
# #     variational = GaussianReference(), 
# #     record = [round_trip]
# # )