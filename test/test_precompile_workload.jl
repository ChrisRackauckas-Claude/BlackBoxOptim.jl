include("helper.jl")

@testset "Precompile workload API" begin
    objective(x) = sum(abs2, x)
    result = bboptimize(
        objective;
        SearchRange = [(-1.0, 1.0), (-1.0, 1.0)],
        Method = :random_search,
        PopulationSize = 8,
        MaxSteps = 1,
        TraceMode = :silent,
    )
    @test length(best_candidate(result)) == 2
    @test best_fitness(result) isa Float64
end
