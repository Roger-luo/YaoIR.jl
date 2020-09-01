using YaoLang
using YaoLang.Compiler: optimize
using ZXCalculus
using YaoArrayRegister
using Test

@device function test_cir()
    5 => H
    5 => shift(0.0)
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    4 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 1 4 => X
    4 => shift($(7 / 4 * π))
    1 => shift($(1 / 4 * π))
    @ctrl 1 4 => X
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 3 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 3 5 => X
    4 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 3 4 => X
    4 => shift($(7 / 4 * π))
    5 => H
    3 => shift($(1 / 4 * π))
    @ctrl 3 4 => X
    5 => shift(0.0)
    @ctrl 4 5 => X
    5 => H
    5 => shift(0.0)
    @ctrl 3 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 2 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 3 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 2 5 => X
    3 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 2 3 => X
    3 => shift($(7 / 4 * π))
    5 => H
    2 => shift($(1 / 4 * π))
    @ctrl 2 3 => X
    5 => shift(0.0)
    @ctrl 3 5 => X
    5 => H
    5 => shift(0.0)
    @ctrl 2 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 2 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    2 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 1 2 => X
    2 => shift($(7 / 4 * π))
    5 => H
    1 => shift($(1 / 4 * π))
    @ctrl 1 2 => X
    5 => shift(0.0)
    @ctrl 2 5 => X
    @ctrl 1 5 => X
end
cir = test_cir()
mat = zeros(ComplexF64, 32, 32)
for i in 1:32
    st = zeros(ComplexF64, 32)
    st[i] = 1
    r0 = ArrayReg(st)
    r0 |> cir
    mat[:, i] = r0.state
end

@device optimizer = [:zx_teleport] function teleport_cir()
    5 => H
    5 => shift(0.0)
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    4 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 1 4 => X
    4 => shift($(7 / 4 * π))
    1 => shift($(1 / 4 * π))
    @ctrl 1 4 => X
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 3 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 3 5 => X
    4 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 3 4 => X
    4 => shift($(7 / 4 * π))
    5 => H
    3 => shift($(1 / 4 * π))
    @ctrl 3 4 => X
    5 => shift(0.0)
    @ctrl 4 5 => X
    5 => H
    5 => shift(0.0)
    @ctrl 3 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 2 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 3 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 2 5 => X
    3 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 2 3 => X
    3 => shift($(7 / 4 * π))
    5 => H
    2 => shift($(1 / 4 * π))
    @ctrl 2 3 => X
    5 => shift(0.0)
    @ctrl 3 5 => X
    5 => H
    5 => shift(0.0)
    @ctrl 2 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 2 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    2 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 1 2 => X
    2 => shift($(7 / 4 * π))
    5 => H
    1 => shift($(1 / 4 * π))
    @ctrl 1 2 => X
    5 => shift(0.0)
    @ctrl 2 5 => X
    @ctrl 1 5 => X
end
tp_cir = teleport_cir()
tp_mat = zeros(ComplexF64, 32, 32)
for i in 1:32
    st = zeros(ComplexF64, 32)
    st[i] = 1
    r1 = ArrayReg(st)
    r1 |> tp_cir
    tp_mat[:, i] = r1.state
end
@test sum(abs.(mat - tp_mat) .> 1e-14) == 0

@device optimizer = [:zx_clifford, :zx_teleport] function clifford_teleport_cir()
    5 => H
    5 => shift(0.0)
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    4 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 1 4 => X
    4 => shift($(7 / 4 * π))
    1 => shift($(1 / 4 * π))
    @ctrl 1 4 => X
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 3 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 4 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 3 5 => X
    4 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 3 4 => X
    4 => shift($(7 / 4 * π))
    5 => H
    3 => shift($(1 / 4 * π))
    @ctrl 3 4 => X
    5 => shift(0.0)
    @ctrl 4 5 => X
    5 => H
    5 => shift(0.0)
    @ctrl 3 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 2 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 3 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 2 5 => X
    3 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 2 3 => X
    3 => shift($(7 / 4 * π))
    5 => H
    2 => shift($(1 / 4 * π))
    @ctrl 2 3 => X
    5 => shift(0.0)
    @ctrl 3 5 => X
    5 => H
    5 => shift(0.0)
    @ctrl 2 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    5 => shift($(1 / 4 * π))
    @ctrl 2 5 => X
    5 => shift($(7 / 4 * π))
    @ctrl 1 5 => X
    2 => shift($(1 / 4 * π))
    5 => shift($(1 / 4 * π))
    @ctrl 1 2 => X
    2 => shift($(7 / 4 * π))
    5 => H
    1 => shift($(1 / 4 * π))
    @ctrl 1 2 => X
    5 => shift(0.0)
    @ctrl 2 5 => X
    @ctrl 1 5 => X
end
cl_tp_cir = clifford_teleport_cir()
cl_tp_mat = zeros(ComplexF64, 32, 32)
for i in 1:32
    st = zeros(ComplexF64, 32)
    st[i] = 1
    r1 = ArrayReg(st)
    r1 |> cl_tp_cir
    cl_tp_mat[:, i] = r1.state
end
cl_tp_mat = mat[1, 1] / cl_tp_mat[1, 1] * cl_tp_mat
@test sum(abs.(mat - cl_tp_mat) .> 1e-14) == 0

code = @code_yao test_cir()
zxd = ZXDiagram(code)
code2 = optimize(code, [:zx_teleport])
zxd2 = ZXDiagram(code2)
@test tcount(zxd2) == 8
