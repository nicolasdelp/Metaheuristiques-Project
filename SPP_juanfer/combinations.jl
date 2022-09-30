# !! DISCLAIMER !!
# Le fichier suivant n'a pas été écrit par nous.
# Il peut être retrouvé à l'adresse suivante:
# https://github.com/JuliaMath/Combinatorics.jl

#The Combinations iterator
struct Combinations
    n::Int
    t::Int
end

function Base.iterate(c::Combinations, s = [min(c.t - 1, i) for i in 1:c.t])
    if c.t == 0 # special case to generate 1 result for t==0
        isempty(s) && return (s, [1])
        return
    end
    for i in c.t:-1:1
        s[i] += 1
        if s[i] > (c.n - (c.t - i))
            continue
        end
        for j in i+1:c.t
            s[j] = s[j-1] + 1
        end
        break
    end
    s[1] > c.n - c.t + 1 && return
    (s, s)
end

Base.length(c::Combinations) = binomial(c.n, c.t)

Base.eltype(::Type{Combinations}) = Vector{Int}

"""
    combinations(a, n)

Generate all combinations of `n` elements from an indexable object `a`. Because the number
of combinations can be very large, this function returns an iterator object.
Use `collect(combinations(a, n))` to get an array of all combinations.
"""
function combinations(a, t::Integer)
    if t < 0
        # generate 0 combinations for negative argument
        t = length(a) + 1
    end
    reorder(c) = [a[ci] for ci in c]
    (reorder(c) for c in Combinations(length(a), t))
end


"""
    combinations(a)

Generate combinations of the elements of `a` of all orders. Chaining of order iterators
is eager, but the sequence at each order is lazy.
"""
combinations(a) = Iterators.flatten([combinations(a, k) for k = 1:length(a)])

