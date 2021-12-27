-- Created by abcdef

local initial   = {r=0, R=1, s=2, e=3, E=4, f=5, a=6, q=7, Q=8, t=9, T=10, d=11, w=12, W=13, c=14, z=15, x=16, v=17, g=18}
local medial    = {k=0, o=1, i=2, O=3, j=4, p=5, u=6, P=7, h=8, hk=9, ho=10, hl=11, y=12, n=13, nj=14, np=15, nl=16, b=17, m=18, ml=19, l=20}
local final     = {r=1, R=2, rt=3, s=4, sw=5, sg=6, e=7, f=8, fr=9, fa=10, fq=11, ft=12, fx=13, fv=14, fg=15, a=16, q=17, qt=18, t=19, T=20, d=21, w=22, c=23, z=24, x=25, v=26, g=27}

return {
    initial = initial,
    medial = medial,
    final = final
}