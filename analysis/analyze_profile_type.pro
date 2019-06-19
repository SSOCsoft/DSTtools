function analyze_profile_type,i,q,u,v,linepos,p_lim,velolimit = velolimit,intenslimit = intenslimit,veloscale = veloscale,plt = plt,ir = ir,magnet_only = magnet_only,winindex = winindex,strict = strict,no_smooth = no_smooth,gfpi = gfpi,smooth_width = smooth_width


;+
;============================================================================
;
;	function : analyze_profile_type
;
;	purpose  : determine type of profile from analysis of IQUV
;
;	written :  cbeck@KIS 2005
;
;==============================================================================
;
;	Check number of arguments.
;
;==============================================================================
if (n_params() lt 6) then begin
	print
	print, "usage:  erg = analyze_profile_type(i,q,u,v,linepos,p_lim,"
        print, "              ,velolimit = velolimit,intenslimit = intenslimit"
        print, "              ,veloscale = veloscale,plt = plt,ir = ir"
        print, "              ,magnet_only = magnet_only,winindex = winindex)"
	print
	print, "	Analyze profiles of IQUV for positions, amplitudes,"
        print, "        number of lobes, polarity."        
        print
	print, "	Arguments"
        print, "                Input :"
        print, "		iquv : Stokes parameters of full spectrum"
        print, "                linepos : position of spectral line in pixel,"
        print, "                          linepos = [low,high]"
        print, "                p_lim : threshold of maximum polarization"
        print, "                        degree to call profile (un)polarized."
        print, "                        In fraction of I_c, e.g., p_lim = .01."
        print
        print, "        Keywords:"
        print, "                velolimit : limit in velocity in km/s. If QU"
        print, "                            is displaced by more than the"
        print, "                            limit from V, profile will be"
        print, "                            termed multi-component."
        print, "                intenslimit : limit in fraction of I_c."
        print, "                            If intensity is below the limit,"
        print, "                            the profile will be assumed to be"
        print, "                            regular (umbra) regardless of all"
        print, "                            other properties."
        print, "                veloscale : conversion between pixel and "
        print, "                            velocity dispersion (in km/s)."
        print, "                            1 spectral pixel = xx km/s."
        print, "                /magnet_only : do not examine shape of IQUV,"
        print, "                               only max(|V|) and L/V are"
        print, "                               returned."
        print, "                /plt : plot profiles and results"
        print, "                winindex : number of window for plotting"
        print
        print, "                Output :"
        print, "                Structure with information on the profile."
        print, "                erg.intens_type : string umbra, penumbra "
        print, "                                , or quiet sun"
        print, "                erg.lobenr : fltarr(3) # of lobes found in QUV"
        print, "                erg.lobepos: fltarr(4) central position of"
        print, "                             IQUV (line core, middle lobe)"
        print, "                erg.relvelo: fltarr(3) velocity difference"
        print, "                             between Q and U, V and Q, V and U in km/s"
        print, "                erg.profile_type : type of profile from analysis"
        print, "                                   0 = field-free"
        print, "                                   1 = regular V (2 lobes)"
        print, "                                   2 = multiple components,"
        print, "                                   either >3 lobes in V or relvelo"
        print, "                                   > velolimit"
        print, "                erg.vampl    : max (|V|)"
        print, "                erg.polarity : polarity of Stokes V, +1/-1"
        print, "                erg.linampl  : max(L = sqrt( (|Q|^2+|U|^2))"
        print, "                erg.vlobespos: fltarr(2), position of blue/red"
        print, "                               lobe for regular V signal."
        print, "                erg.areaasym : NCP, total(V)"
        print, "                erg.vtype    : string regular, irregular red/blue"
        print, "                               , or irregular multiple"
        print, "                erg.vlobeint : fltarr(2), aplitude of blue/red"
        print, "                               lobe for regular V signal."
        print, "                erg.poldeg   : max (sqrt(Q^2+U^2+V^2))"
        print, "                erg.lincircratio : L/V around V_max"
        print, "                erg.vabs     :  total(|V|)"
        print, "                erg.azi      : azimuth from U/Q "
        print
        return,{intens_type:'',lobenr:fltarr(3),lobepos:fltarr(4),relvelo:fltarr(3),profile_type:fltarr(1),vampl:fltarr(1),polarity:fltarr(1),linampl:fltarr(1),vlobespos:fltarr(2),areaasym:fltarr(1),vtype:strarr(1),vlobeint:fltarr(2),poldeg:fltarr(2),lincircratio:fltarr(1),vabs:fltarr(1),qoveru:fltarr(1),vloben:fltarr(1)}
endif
;==============================================================================
;-

; default values for limits in I, p , v
if n_elements(p_lim) eq 0 then p_lim = .015
if n_elements(intenslimit) eq 0 then intenslimit= .7
if n_elements(velolimit) eq 0 then velolimit= .7
if n_elements(veloscale) eq 0 then veloscale = .718
if n_elements(winindex) ne 0 then windex = winindex else windex = 0
if n_elements(smooth_width) eq 0 then smooth_width = 3

; structure of output
erg = {intens_type:'',lobenr:fltarr(3),lobepos:fltarr(4),relvelo:fltarr(3),profile_type:fltarr(1),vampl:fltarr(1),polarity:fltarr(1),linampl:fltarr(1),vlobespos:fltarr(2),areaasym:fltarr(1),vtype:strarr(1),vlobeint:fltarr(2),poldeg:fltarr(2),lincircratio:fltarr(1),vabs:fltarr(1),azi:fltarr(1),vloben:fltarr(1)}

; cut out line from spectrum
ii = i(linepos(0):linepos(1))
qq = q(linepos(0):linepos(1))
uu = u(linepos(0):linepos(1))
vv = v(linepos(0):linepos(1))

iold = ii
qold = qq
uold = uu
vold = vv

; replace 0 in intensity
tt = where(ii eq 0)
if tt(0) ne -1 then ii(tt) = mean(ii)

; polarization degree
erg.poldeg(0) = max( sqrt(qq^2.+uu^2.+vv^2.)/ii)
erg.poldeg(1) = total(sqrt(qq^2.+uu^2.+vv^2.))/float(n_elements(ii))

; smooth data for suppression of noise to enhance lobes
if n_elements(no_smooth) eq 0 then begin
ii = smooth(ii,smooth_width)
qq = smooth(qq,smooth_width)
uu = smooth(uu,smooth_width)
vv = smooth(vv,smooth_width)
endif

; calculate new max. poldeg after smoothing
pp = sqrt(qq^2.+uu^2.+vv^2.)  ;
p_max = max(pp)

; determine type of profile from intensity, umbra < intenslimit
; quiet sun > intenslimit, p < p_lim
int_max = max(ii)
if int_max gt intenslimit(0) then erg.intens_type = 'penumbra'
if int_max le intenslimit(0) then erg.intens_type = 'umbra'
if p_max le p_lim then erg.intens_type = 'quiet sun'

qlobeindex = 0
ulobeindex = 0
vlobeindex = 0
prof_type = 0

; NCP and total V
erg.areaasym = total(vold)
erg.vabs = float(total(abs(vold)))

erg.vtype = 'nonmagnetic'

; line core position in Stokes I
lim = n_elements(ii)
mist = min(ii,posmin)

if posmin-4 lt 0 then posmin = 5
if posmin+4 ge lim then posmin = lim-5

lpff,ii(posmin-4:posmin+4),ipos
ipos = ipos+ posmin-4


if n_elements(plt) ne 0 then begin
vv_abs = abs(vv)
qq_abs = abs(qq)
uu_abs = abs(uu)

wset,windex
erase
!p.multi= [4,1,4]
plot,ii,/ynozero,charsize=2,ytitle = 'I'
plot,qq_abs,charsize=2,/ynozero,ytitle = 'Q'
plot,uu_abs,charsize=2,/ynozero,ytitle = 'U'
plot,vv,charsize=2,ytitle = 'V'

endif

; examine profiles if magnetic
if p_max gt p_lim then begin

if n_elements(magnet_only) eq 0 then begin

llimit = 5.
if n_elements(gfpi) ne 0 then llimit = 3

n = length(ii)
vv_abs = abs(vv)
qq_abs = abs(qq)
uu_abs = abs(uu)

vlobes = fltarr(n-llimit+1)
ulobes = fltarr(n-llimit+1)
qlobes = fltarr(n-llimit+1)



threshh = 2.

if n_elements(strict) ne 0 then threshh = strict

; test for lobes in QUV, lobe > max(surroundings)

for k = llimit,n-llimit do begin
    if vv_abs(k) gt max(vv_abs(k+1:k+llimit-1)) and vv_abs(k) gt max(vv_abs(k-llimit+1:k-1)) and vv_abs(k) gt p_lim/threshh then begin
        vlobes(vlobeindex) = k
        vlobeindex = vlobeindex+1
    endif
    if qq_abs(k) gt max(qq_abs(k+1:k+llimit-1)) and qq_abs(k) gt max(qq_abs(k-llimit+1:k-1)) and qq_abs(k) gt p_lim/threshh then begin
        qlobes(qlobeindex) = k
        qlobeindex = qlobeindex+1
    endif
    if uu_abs(k) gt max(uu_abs(k+1:k+llimit-1)) and uu_abs(k) gt max(uu_abs(k-llimit+1:k-1)) and uu_abs(k) gt p_lim/threshh then begin
        ulobes(ulobeindex) = k
        ulobeindex = ulobeindex+1
    endif
endfor

erg.vloben = vlobeindex

if vlobeindex eq 3 then vpos = vlobes(0)
if vlobeindex ge 3 then begin
erg.vtype = 'irregular, multiple'
endif

if vlobeindex eq 1 then begin
vpos = vlobes(0)
if vpos gt ipos then erg.vtype = 'irregular, red'
if vpos le ipos then erg.vtype = 'irregular, blue'

llimit = 3
if n_elements(gfpi) ne 0 then llimit = 2
if vlobes(0)-llimit lt 0 then posmin = 0 else posmin = vlobes(0)-llimit
lpff,vv_abs(posmin:vlobes(0)+llimit),pos1
vpos1 = pos1+posmin
erg.vlobespos(0) = vpos1

endif

; for regular V profiles calculate positions, amplitude 
if vlobeindex eq 2 then begin
erg.vtype = 'regular'

llimit = 3
if n_elements(gfpi) ne 0 then llimit = 2

if vlobes(0)-llimit lt 0 then posmin = 0 else posmin = vlobes(0)-llimit

lpff,vv_abs(posmin:vlobes(0)+llimit),pos1
vpos1 = pos1+posmin

if vlobes(1)+llimit ge n then posmax = n-1 else posmax =  vlobes(1)+llimit 

lpff,vv_abs(vlobes(1)-llimit:posmax),pos2
vpos2 = pos2+vlobes(1)-llimit
vpos0 = (vpos2-vpos1)/2.+vpos1
vpos = vpos0

erg.vlobespos(0) = vpos1
erg.vlobespos(1) = vpos2

erg.vlobeint(0)= vold(vpos1)
erg.vlobeint(1)= vold(vpos2)

if abs(vlobes(0)-vlobes(1)) gt 5 then begin

yy = vold(vlobes(0)+2:vlobes(1)-2)
pp = min(abs(yy),posminpp)

xx1 = posminpp-3+findgen(6)+vlobes(0)+2

ergg = analytger(xx1,vv(xx1))
vpos = -ergg(1)/ergg(0)

if n_elements(plt) eq 10 then begin
yy1 = ergg(1)+ergg(0)*xx1
xx = vlobes(0)+2 + findgen(vlobes(1)-vlobes(0)-3)
!p.multi= [2,1,2]
wset,windex
erase
plot,xx,yy,/ynozero
oplot,[vpos,vpos],[-2,2]

plot,xx1,yy1,/ynozero
oplot,[vpos,vpos],[-2,2]
wait,1.
endif

endif

endif

if qlobeindex eq 3 then qpos = qlobes(1)
if ulobeindex eq 3 then upos = ulobes(1)
if qlobeindex eq 1 then qpos = qlobes(0)
if ulobeindex eq 1 then upos = ulobes(0)
if qlobeindex eq 2 then qpos = (qlobes(1)-qlobes(0))/2.+qlobes(0)
if ulobeindex eq 2 then upos = (ulobes(1)-ulobes(0))/2.+ulobes(0)


; test for velocity displacements between QUV for 3-lobed QU
if n_elements(ir) eq 0 and n_elements(qpos) ne 0 and qlobeindex ge 2 then do_q = 1 else do_q = 0
if n_elements(ir) ne 0 and n_elements(qpos) ne 0 and qlobeindex eq 3 then do_q = 1 else do_q = 0
if n_elements(ir) eq 0 and n_elements(upos) ne 0 and ulobeindex ge 2 then do_u = 1 else do_u = 0
if n_elements(ir) ne 0 and n_elements(upos) ne 0 and ulobeindex eq 3 then do_u = 1 else do_u = 0
if n_elements(vpos) ne 0 and vlobeindex eq 2 then do_v = 1 else do_v = 0

if do_q+do_v+do_u ge 2 then begin
if do_u+do_q eq 2 then dvuq = (qpos-upos)*veloscale
if do_u+do_v eq 2 then dvuv = (upos-vpos)*veloscale
if do_v+do_q eq 2 then dvqv = (qpos-vpos)*veloscale
endif

; do plotting if wanted 
if n_elements(plt) ne 0 then begin
wset,windex
erase
!p.multi= [4,1,4]
plot,ii,/ynozero,charsize=2,ytitle = 'I'
oplot,iold,linestyle = 2
oplot,[ipos,ipos],[0,2]
plot,qq_abs,charsize=2,/ynozero,ytitle = 'Q'
oplot,qold,linestyle = 2
if n_elements(qpos) ne 0 then oplot,[qpos,qpos],[-2,2],linestyle=2
for k = 0,qlobeindex-1 do begin
    oplot,[qlobes(k),qlobes(k)],[-2,2],linestyle = 1
endfor
plot,uu_abs,charsize=2,/ynozero,ytitle = 'U'
oplot,uold,linestyle = 2
if n_elements(upos) ne 0 then oplot,[upos,upos],[-2,2],linestyle=2
for k = 0,ulobeindex-1 do begin
    oplot,[ulobes(k),ulobes(k)],[-2,2],linestyle = 1
endfor

plot,vv,charsize=2,ytitle = 'V'
oplot,vold,linestyle = 2
oplot,[0,n_elements(vv)],[0,0]
if n_elements(vpos) ne 0 then oplot,[vpos,vpos],[-2,2],linestyle=2
if vlobeindex eq 2 then begin
oplot,[vpos1,vpos1],[-2,2]
oplot,[vpos2,vpos2],[-2,2]
endif else begin
for k = 0,vlobeindex-1 do begin
    oplot,[vlobes(k),vlobes(k)],[-2,2],linestyle = 1
endfor
endelse

endif

prof_type = 1
; determine tpye of profile from # of V lobes and velocity displacements
if erg.intens_type eq 'penumbra' and vlobeindex ge 3 then prof_type = 2
if erg.intens_type eq 'penumbra' then begin
    if n_elements(dvuq) ne 0 then begin
        if abs(dvuq) gt velolimit then prof_type = 2
    endif
    if n_elements(dvuv) ne 0 then begin
        if abs(dvuv) gt velolimit then prof_type = 2
    endif
    if n_elements(dvqv) ne 0 then begin
        if abs(dvqv) gt velolimit then prof_type = 2
    endif
endif
endif

;if erg.intens_type eq 'penumbra' then prof_type = 2

; determine amplitude and location of max. V
erg.vampl = max(abs(vold),posmax)
if posmax -3 lt 0 then posmax = 3
if posmax +3 ge lim then posmax = lim-4

; calculate L, L/V
erg.lincircratio = mean( sqrt(qold(posmax-3:posmax+3)^2.+uold(posmax-3:posmax+3)^2.)/abs(vold(posmax-3:posmax+3)) )
erg.linampl = max( sqrt( abs(qold)^2.+abs(uold)^2.) )
v_temp = mittelung(mittelung(vv))

qq1 = qold(posmax-3:posmax+3)
uu1 = uold(posmax-3:posmax+3)
azi = atan( mean(qq1/float(uu1)) )
su = mean(uu1) & sq = mean(qq1)
if (su lt 0) and (sq lt 0) then azi = azi+!pi
if (su lt 0) and (sq ge 0) then azi = azi+!pi
if (su ge 0) and (sq lt 0) then azi = azi+2*!pi
erg.azi = azi/2.

pp = max(v_temp,posmax)
pp = min(v_temp,posmin)
if posmax gt posmin then erg.polarity = 1 else erg.polarity = -1

endif

if n_elements(ipos) ne 0 then erg.lobepos(0) = ipos
if n_elements(qpos) ne 0 then erg.lobepos(1) = qpos
if n_elements(upos) ne 0 then erg.lobepos(2) = upos
if n_elements(vpos) ne 0 then erg.lobepos(3) = vpos

if n_elements(dvuq) ne 0 then erg.relvelo(0) = dvuq 
if n_elements(dvqv) ne 0 then erg.relvelo(1) = dvqv 
if n_elements(dvuv) ne 0 then erg.relvelo(2) = dvuv 

erg.lobenr = [qlobeindex,ulobeindex,vlobeindex]

erg.profile_type = prof_type

;print,erg

return,erg
end
