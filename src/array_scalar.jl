"""
    value_and_gradient!(grad, backend, f, x) -> (y, grad)

Compute the primal value `y = f(x)` and the gradient `grad = ∇f(x)` of an array-to-scalar function, overwriting `grad` if possible.
"""
function value_and_gradient! end

function value_and_gradient!(
    grad::AbstractArray, backend::AbstractForwardBackend, f, x::AbstractArray
)
    y = f(x)
    for j in eachindex(IndexCartesian(), x)
        dx_j = basisarray(backend, x, j)
        _, grad[j] = value_and_pushforward!(grad[j], backend, f, x, dx_j)
    end
    return y, grad
end

function value_and_gradient!(
    grad::AbstractArray, backend::AbstractReverseBackend, f, x::AbstractArray
)
    y = f(x)
    return value_and_pullback!(grad, backend, f, x, one(y))
end

"""
    value_and_gradient(backend, f, x) -> (y, grad)

Compute the primal value `y = f(x)` and the gradient `grad = ∇f(x)` of an array-to-scalar function.
"""
function value_and_gradient(backend::AbstractBackend, f, x::AbstractArray)
    grad = similar(x)
    return value_and_gradient!(grad, backend, f, x)
end