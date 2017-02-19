#  Copyright 2016, Los Alamos National Laboratory, LANS LLC.
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.

using JuMP
import Convex
using Pajarito
using Base.Test

include(Pkg.dir("JuMP", "test", "solvers.jl"))
include("nlptest.jl")
include("conictest.jl")

# Define solvers using JuMP/test/solvers.jl
solvers_mip = lazy_solvers

solvers_nlp = []
if ipt
    push!(solvers_nlp, Ipopt.IpoptSolver(print_level=0))
end
if kni
    push!(solvers_nlp, KNITRO.KnitroSolver(objrange=1e16,outlev=0,maxit=100000))
end

solvers_soc = []
solvers_expsoc = []
solvers_sdpsoc = []
if eco
    push!(solvers_soc, ECOS.ECOSSolver(verbose=false))
    push!(solvers_expsoc, ECOS.ECOSSolver(verbose=false))
end
if scs
    push!(solvers_soc, SCS.SCSSolver(eps=1e-5,max_iters=100000,verbose=0))
    push!(solvers_expsoc, SCS.SCSSolver(eps=1e-5,max_iters=100000,verbose=0))
    push!(solvers_sdpsoc, SCS.SCSSolver(eps=1e-5,max_iters=100000,verbose=0))
    push!(solvers_sdpexp, SCS.SCSSolver(eps=1e-5,max_iters=100000,verbose=0))
end
if mos
    push!(solvers_soc, Mosek.MosekSolver(LOG=0))
    push!(solvers_sdpsoc, Mosek.MosekSolver(LOG=0))
end

println("\nMIP solvers:")
for solver in solvers_mip
    println(solver)
end
println("\nNLP solvers:")
for solver in solvers_nlp
    println(solver)
end
println("\nConic SOC solvers:")
for solver in solvers_soc
    println(solver)
end
println("\nConic Exp+SOC solvers:")
for solver in solvers_expsoc
    println(solver)
end
println("\nConic SDP+SOC solvers:")
for solver in solvers_sdpsoc
    println(solver)
end
println("\nConic SDP+Exp solvers:")
for solver in solvers_sdpexp
    println(solver)
end
println("\nStarting Pajarito tests...\n")
flush(STDOUT)

# Tests absolute tolerance and Pajarito printing options
TOL = 1e-3
ll = 0

# # NLP tests in nlptest.jl
# @testset "NLP model - $(msd ? "MSD" : "Iter"), $(split(string(typeof(mip)), '.')[1]), $(split(string(typeof(con)), '.')[1])" for con in solvers_nlp, mip in solvers_mip, msd in [false, true]
#     runnlptests(msd, mip, con, ll)
# end
# flush(STDOUT)
#
# # Conic models tests in conictest.jl with NLP solver
# @testset "SOC NLP - $(msd ? "MSD" : "Iter"), $(split(string(typeof(mip)), '.')[1]), $(split(string(typeof(con)), '.')[1])" for con in solvers_nlp, mip in solvers_mip, msd in [false, true]
#     runsocboth(msd, mip, con, ll)
# end
# flush(STDOUT)
# @testset "Exp+SOC NLP - $(msd ? "MSD" : "Iter"), $(split(string(typeof(mip)), '.')[1]), $(split(string(typeof(con)), '.')[1])" for con in solvers_nlp, mip in solvers_mip, msd in [false, true]
#     runexpsocboth(msd, mip, con, ll)
# end
# flush(STDOUT)
#
# # Conic models tests in conictest.jl with conic solver
# @testset "SOC conic - $(msd ? "MSD" : "Iter"), $(split(string(typeof(mip)), '.')[1]), $(split(string(typeof(con)), '.')[1])" for con in solvers_soc, mip in solvers_mip, msd in [false, true]
#     runsocboth(msd, mip, con, ll)
#     runsocconic(msd, mip, con, ll)
# end
# flush(STDOUT)
# @testset "Exp+SOC conic - $(msd ? "MSD" : "Iter"), $(split(string(typeof(mip)), '.')[1]), $(split(string(typeof(con)), '.')[1])" for con in solvers_expsoc, mip in solvers_mip, msd in [false, true]
#     runexpsocboth(msd, mip, con, ll)
#     runexpsocconic(msd, mip, con, ll)
# end
# flush(STDOUT)
@testset "SDP+SOC conic - $(msd ? "MSD" : "Iter"), $(split(string(typeof(mip)), '.')[1]), $(split(string(typeof(con)), '.')[1])" for con in solvers_sdpsoc, mip in solvers_mip, msd in [false, true]
    runsdpsocconic(msd, mip, con, ll)
end
flush(STDOUT)
@testset "SDP+Exp conic - $(msd ? "MSD" : "Iter"), $(split(string(typeof(mip)), '.')[1]), $(split(string(typeof(con)), '.')[1])" for con in solvers_sdpexp, mip in solvers_mip, msd in [false, true]
    runsdpexpconic(msd, mip, con, ll)
end
flush(STDOUT)
