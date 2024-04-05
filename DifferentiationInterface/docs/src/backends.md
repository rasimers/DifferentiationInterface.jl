```@meta
CurrentModule = Main
CollapsedDocStrings = true
```

```@setup backends
using DifferentiationInterface
using DifferentiationInterface: backend_string
import Markdown
import Diffractor, Enzyme, FastDifferentiation, FiniteDiff, FiniteDifferences, ForwardDiff, PolyesterForwardDiff, ReverseDiff, Tapir, Tracker, Zygote

function all_backends()
    return [
        AutoDiffractor(),
        AutoEnzyme(Enzyme.Forward),
        AutoEnzyme(Enzyme.Reverse),
        AutoFastDifferentiation(),
        AutoFiniteDiff(),
        AutoFiniteDifferences(FiniteDifferences.central_fdm(3, 1)),
        AutoForwardDiff(),
        AutoPolyesterForwardDiff(; chunksize=2),
        AutoReverseDiff(),
        AutoTapir(),
        AutoTracker(),
        AutoZygote(),
    ]
end

function all_backends_without_enzyme()
    return filter(all_backends()) do b
        !isa(b, AutoEnzyme)
    end
end
```

# Backends

## Types

We support (and re-export) most backend choices from [ADTypes.jl](https://github.com/SciML/ADTypes.jl), and we provide a few more of our own.

!!! warning
    Only the backends listed below are supported by DifferentiationInterface.jl, even though ADTypes.jl defines more.

### Dense

```@docs
AutoChainRules
AutoDiffractor
AutoEnzyme
AutoFastDifferentiation
AutoForwardDiff
AutoForwardDiff()
AutoFiniteDiff
AutoFiniteDifferences
AutoPolyesterForwardDiff
AutoPolyesterForwardDiff()
AutoReverseDiff
AutoTapir
AutoTracker
AutoZygote
```

### Sparse

```@docs
AutoSparseFastDifferentiation
AutoSparseFiniteDiff
AutoSparseForwardDiff
AutoSparseForwardDiff()
AutoSparsePolyesterForwardDiff
AutoSparseReverseDiff
AutoSparseZygote
```

## Availability

You can use [`check_available`](@ref) to verify whether a given backend is loaded, like we did below:

```@example backends
header = "| backend | available |"  # hide
subheader = "|---|---|"  # hide
rows = map(all_backends()) do backend  # hide
    "| `$(backend_string(backend))` | $(check_available(backend) ? '✅' : '❌') |"  # hide
end  # hide
Markdown.parse(join(vcat(header, subheader, rows...), "\n"))  # hide
```

## Mutation support

All backends are compatible with allocating functions `f(x) = y`.
Only some are compatible with mutating functions `f!(y, x) = nothing`.
You can use [`check_mutation`](@ref) to check that feature, like we did below:

```@example backends
header = "| backend | mutation |"  # hide
subheader = "|---|---|"  # hide
rows = map(all_backends()) do backend  # hide
    "| `$(backend_string(backend))` | $(check_mutation(backend) ? '✅' : '❌') |"  # hide
end  # hide
Markdown.parse(join(vcat(header, subheader, rows...), "\n"))  # hide
```

## Hessian support

Only some backends are able to compute Hessians.
You can use [`check_hessian`](@ref) to check that feature, like we did below:

```@example backends
header = "| backend | Hessian |"  # hide
subheader = "|---|---|"  # hide
rows = map(all_backends()) do backend  # hide
    "| `$(backend_string(backend))` | $(check_hessian(backend) ? '✅' : '❌') |"  # hide
end  # hide
Markdown.parse(join(vcat(header, subheader, rows...), "\n"))  # hide
```

!!! warning
    Second-order operators can also be used with a combination of backends inside the [`SecondOrder`](@ref) struct.
    There are many possible combinations, a lot of which will fail.
    Due to compilation overhead, we do not currently test them all to display the working ones in the documentation, but we might if users deem it relevant.