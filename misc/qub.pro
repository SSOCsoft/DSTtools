pro qub

; read in reduced data, no prior fringe correction

input_dir ='/net/koa/export/data/cbeck/QUB/'
erg = read_directory(input_dir,filter ='*.dat')
files = erg.files

; files(0) == firs.2.20160714.074131.reduced.dat
restore,input_dir+files(0)+'.sav'
tt = size(ic)

;read in the data

full_spec = fltarr(dx_final+1,dy_final+1,tt(1),4)
a = fltarr(dx_final+1,dy_final+1,4)
openr,1,input_dir+files(0)
for k = 0,tt(1)-1 do begin & readu,1,a & full_spec(*,*,k,*) = a & endfor

; correct for V-> Q cross talk
full_spec(*,*,*,1) = full_spec(*,*,*,1)  - .1*full_spec(*,*,*,3) 

; average over all scan steps, determine fringes in average one
qq = total(full_spec(*,*,*,1),3)/365.

; continuum window to the blue of Si 1082.7 nm: pixel 200 - 315

qcorr = fltarr(1020,487) ; fringe correction first attempt, didn't work

trendcorr = fltarr(1020,487)  ; correction for second order trend in wavelength

weights = fltarr(116)+1.

; loop along the slit, get 2nd order polynomial for each profile
for k = 0,486 do begin & ff = reform(qq(*,k)) & erg = poly_fit(findgen(1020),ff,2,/double) & ycorr = erg(0)+erg(1)*findgen(1020)+erg(2)*findgen(1020)^2. & trendcorr(*,k) = ycorr & ff = ff - ycorr & ff1 = ff(200:315) & ff1 = smooth(ff1,7,/edge_truncate) & phi = findgen(116)/115.*3600. & y = ff1 & n_per = 0.5 & xx = phi/180.*!pi & y = y & a = [n_per,-0.8,20,10] & erg = curvefit(xx,y,weights,a,/noderivative,function_name='sin_var',/double) & corrline1 = sin( (findgen(1020.)+200.)/1020.*3600.*1020/116./180.*!pi*a(0)+a(1) ) *a(2)   & qcorr(*,k) = corrline1 & endfor

; qcorr doesn't work, trendcorr is okay
; apply the trend correction prior to fringe determination
qq1 = qq
qq1 = qq1 - trendcorr

; approximate variation of the phase along the slit in pixels
xx = [272,278,283,288,287,284] 
yy = [482,406,328,235,100,20]  ; 145,60
erg = poly_fit(yy,xx,2,/double)
phasecurve = erg(0)+findgen(487)*erg(1)+findgen(487)^2.*erg(2)

; variation of phase
window,0
!p.multi = [2,1,2]
plot,yy,xx,/yn
oplot,phasecurve,color = 240

; determine amplitude of fringes
amplitudecurve = fltarr(487)
for k = 0,486 do begin & amplitudecurve(k) = max(abs(qq1(220:270,k))) & endfor

; catch spikes
amplitudecurve = median(amplitudecurve,5)
plot,amplitudecurve

; fringe period: hardwired, no trend considered
periodcurve = fltarr(487)+.25

; f = sin(a(0)*x+a(1))*abs(a(2))+a(3)
;a = [.25,2.5,10,.0]
;sin_var,findgen(1020),a,f
;plot,qq1(*,100)
;oplot,f,color = 240

; create correction array
qcorr1 = fltarr(1020,487)
for k = 0,486 do begin & amplitude = amplitudecurve(k) & period = periodcurve(k) & phase = -(phasecurve(k)-mean(phasecurve))/3.5-1.5 & a = [period,phase,amplitude,0] & sin_var,findgen(1020),a,f & qcorr1(*,k) = f & endfor


blink,qq1 >(-40) < 40,qcorr1

stop

window,1,xs = 1020,ys = 487
tvscl,qq1-qcorr1 >(-30) < 30,0,0

; apply correction to data
full_spec1 = full_spec
for k = 0,364 do begin & full_spec1(*,*,k,1) = full_spec(*,*,k,1)  - trendcorr & full_spec1(*,*,k,1) = full_spec1(*,*,k,1)  - qcorr1 & endfor 

; display before - after
window,2,xs = 1000,ys = 487
for k = 0,364 do begin & tvscl,congrid(reform(full_spec(*,*,k,1)/full_spec(*,*,k,0)),500,487,/interp) >(-.1) < .1,0,0 & tvscl,congrid(reform(full_spec1(*,*,k,1)/full_spec1(*,*,k,0)),500,487,/interp) >(-.1) < .1,500,0 & wait,.1 & endfor


stop

save,full_spec1,trendcorr,qcorr1,filename = ' firs.2.20160714.074131.reduced.dat_fringefilter.sav'

end

;pro sin_var,x,a,f
;f = sin(a(0)*x+a(1))*abs(a(2))+a(3)
;end
;pro sin_var_1,x,a,f
;n = n_elements(x)
;pperiod = a(0)+findgen(n)*a(1)+findgen(n)^2.*a(2)  ;+findgen(n)^3.*a(3)
;pphase = a(3)+findgen(n)*a(4)+findgen(n)^2.*a(5)
;ampl = a(6)+findgen(n)*a(7)+findgen(n)^2.*a(8)
;offset = a(9)+findgen(n)*a(10)+findgen(n)^2.*a(11)
;f = sin(pperiod*x+pphase)*ampl+offset
;end
