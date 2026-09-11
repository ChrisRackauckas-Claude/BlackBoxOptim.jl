using BlackBoxOptim, BenchmarkTools
using StableRNGs

const SUITE = BenchmarkGroup()
const rng = StableRNG(123)

rosenbrock2d(x) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
rastrigin(x) = 10 * length(x) + sum(abs2, x) - 10 * sum(cos.(2π .* x))

# =============================================================================
# bboptimize — black-box optimization entry point
# =============================================================================

SUITE["bboptimize"] = BenchmarkGroup()

SUITE["bboptimize"]["default_de"] = @benchmarkable bboptimize(
    $rosenbrock2d; SearchRange = (-5.0, 5.0), NumDimensions = 2,
    MaxFuncEvals = 2000, TraceMode = :silent
)
SUITE["bboptimize"]["separable_nes"] = @benchmarkable bboptimize(
    $rosenbrock2d; SearchRange = (-5.0, 5.0), NumDimensions = 2,
    Method = :separable_nes, MaxFuncEvals = 2000, TraceMode = :silent
)
SUITE["bboptimize"]["adaptive_de"] = @benchmarkable bboptimize(
    $rosenbrock2d; SearchRange = (-5.0, 5.0), NumDimensions = 2,
    Method = :adaptive_de_rand_1_bin_radiuslimited, MaxFuncEvals = 2000,
    TraceMode = :silent
)
SUITE["bboptimize"]["de_10d"] = @benchmarkable bboptimize(
    $rastrigin; SearchRange = (-5.0, 5.0), NumDimensions = 10,
    Method = :de_rand_1_bin, MaxFuncEvals = 4000, TraceMode = :silent
)
SUITE["bboptimize"]["prob_de"] = @benchmarkable bboptimize(
    $rastrigin, $(rand(rng, 10)); SearchRange = (-5.0, 5.0),
    NumDimensions = 10, Method = :dxnes, MaxFuncEvals = 2000,
    TraceMode = :silent
)
