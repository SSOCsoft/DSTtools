pro cair_030814_lineparam

ftsread,data,8480,8770,xlam = xlam
data = swap_endian(data)/10000.
xlam = xlam / 10.

ll_cair = 852.87+findgen(511)*5.55/1000.

dispersion = 5.55

inpath = '/data/cbeck/data1/obs2013/030813/fringe_filtered_8542_030813/'

outpath = '/data/cbeck/data1/obs2013/030813/lineparam_spinor/'

erg = read_directory(inpath,filter = '*.fringe_filtered.dat')
files1 = erg.files


for ww = 0,n_elements(files1)-1 do begin 

;infile = '140313.143700.0.ccc04.c-hrt.map.0004.fits.new_reduced.fringe_filtered.dat'
;restore,'/data/cbeck/obs2014/invert_cair_130314/140313.143700_spectbinverted.sav'

infile = inpath + files1(ww)

restore,infile+'.sav'

tt = size(ic)

full_spec = fltarr(tt(1), dx_final+1, tt(2),4)

openr,1,infile
a = fltarr(dx_final+1,dy_final+1,4)


for  k = 0,tt(1)-1 do begin 
   readu,1,a
   full_spec(k,*,*,*) = a
   print,tt(1)-1 - k
endfor


close,1


outfile_1 = outpath + 'lineparam_'+files1(ww)+'.sav'
    
  
   tt =size(full_spec)
 
   avprof = total(total(full_spec(*,*,75:115,0),1),2)/float(tt(1))/41. 
 
   fts_splined = spline(xlam,data,ll_cair,/double)
 
   ccorr = fts_splined / avprof
   erg = poly_fit(findgen(n_elements(ccorr)),ccorr,4,/double)
   yy = erg(0)+erg(1)*findgen(n_elements(ccorr))+erg(2)*findgen(n_elements(ccorr))^2.+erg(3)*findgen(n_elements(ccorr))^3.+erg(4)*findgen(n_elements(ccorr))^4.

   yy = yy/mean(yy)

   avprof = avprof * yy

   nnorm = mean(fts_splined(410:430)/avprof(410:430))



   full_spec = full_spec*nnorm
   
for k = 0,tt(1)-1 do begin & for kk = 0,tt(3)-1 do begin & full_spec(k,*,kk,0) = full_spec(k,*,kk,0) * yy & endfor & endfor


   avprof = total(total(full_spec(*,*,75:115,0),1),2)/float(tt(1))/41. 

   ic = reform(total(full_spec(*,1:10,*,0),2)/10.)

   i_norm = total(ic(*,0:7),2)/8.
   i_norm1 = total(ic(*,tt(3)-8:tt(3)-1),2)/8.

   ii_norm = ic -ic 

for k = 0,tt(1)-1 do begin & ii_norm(k,*) = i_norm(k)+findgen(tt(3))/(tt(3)-1.)*(i_norm1(k)-i_norm(k)) & endfor

   ii_norm = ii_norm / mean(ii_norm)




   window,0
   laodct,41
   device,decomposed = 0

   plot,avprof
   oplot,fts_splined,color = 120


   icore = fltarr(tt(1),tt(3))
   iwing = fltarr(tt(1),tt(3))
   vlos = fltarr(tt(1),tt(3))
   vlos_blend1 = fltarr(tt(1),tt(3))
   vlos_blend2 = fltarr(tt(1),tt(3))

   lineasym= fltarr(tt(1),tt(3))
   linedepth= fltarr(tt(1),tt(3))
   linewidth= fltarr(tt(1),tt(3))
   eqiwidth= fltarr(tt(1),tt(3))

   bisectors = fltarr(30,tt(1),tt(3)) ; center of bisectors at 10 intensity levels
   bisectors_int = fltarr(30,tt(1),tt(3)) ; intensity of the 10 intensity levels
   bisectors_width = fltarr(30,tt(1),tt(3)) ; width of the 10 intensity levels

   iline = avprof
   
   imin = min(iline(30:400),posmin)     ; min value in av. prof
   posmin = posmin+30.              ; position of line core
   imax = mean(iline(410:430))      ; max value in av. prof
   diff = imax-imin ; determination of 10 bisectors between minimum and maximum intensity in the profile. 

; spline the profile for the bisectors
 ;  iline1 = spline(findgen(27),avprof,findgen(260)/10.)
 ;  lambda_splined = spline(findgen(27),ll_cair,findgen(260)/10.)
   iline1 = iline
   erg = min(iline1(30:400),posmin1)    ; position of line core in splined profile
   posmin1 = posmin1 + 30.

; test of loop
   k = 0       
   kk = 0

   laodct,41
   device,decomposed = 0
; display result
   window,2,title = 'Test of bisector determination'
   !p.multi = 0
  ;
   cchars =.7
   set_plot,'PS'
   device,filename ='/net/cbeck-pc1/export/cbeck/work/cajets/cair_spinor_prof.ps',xs = 8.4,ys = 4,bits_per_pixel = 8,/color

   plot,ll_cair,avprof,xr = [ll_cair(0),max(ll_cair)],/xstyle,charsize = cchars,xtitle ='!4k!3 [nm]',thick = 2.,ytitle = 'I/I!Dc!N',yr = [.1,1.02],/ystyle
   oplot,ll_cair,fts_splined,color = 240


; plot,ll_cair,iline
 ; calculate bisectors, left/right end of bisector where |I - iref| = minimal 
for kkk = 1,30 do begin & iref = imin+kkk/30.*diff &  ttemp = iline1(0:posmin1)-iref &  ff = where(ttemp gt 0) & posmin_left = max(ff) & ttemp = iline1(posmin1:*)-iref & ff = where(ttemp gt 0) & posmin_right = min(ff)+posmin1 & if min(ff) eq -1 then posmin_right = 260.-1 & bisectors(kkk-1,k,kk) = (posmin_right+posmin_left)/2. &  bisectors_int(kkk-1,k,kk)=iref & bisectors_width(kkk-1,k,kk)= (posmin_right - posmin_left) & oplot,ll_cair([posmin_left,posmin_right]),[0,0]+iref,color = (10+kkk*20) mod 254 & oplot,[0,0]+ ll_cair(bisectors(kkk-1,k,kk)),[imax,iref],color = (10+kkk*20) mod 254 &  endfor
 
  legend1,text =[' FTS',' OBS'],charsize = cchars,pos = [855.,.15],/data,/no_box,linestyle = fltarr(2),color = [240,0],ttextcolor = [240,0],thick =[1,3]

device,/close
set_plot,'X'

stop

; print,kkk,posmin_left/10.,posmin_right/10.

   laodct,0

window,0,xs = tt(1)*4., ys = tt(3)*2.

; loop over spectra
   for k = 0,tt(1)-1 do begin

      ii = reform(full_spec(k,*,*,0))
    ;  dummy = ii - ii

   ;   deskew1,ii,dummy,dummy,dummy,474-5,474+5,0,tt(3)-1,0,tt(3)-1,2,474

     ; full_spec(k,*,*,0) = ii

      for kk = 0,tt(3)-1 do begin

         iline = reform(full_spec(k,*,kk,0))

         iline = iline(30:470)

         imin = min(iline,posmin)
         posmin = posmin
         imax = mean(iline(380:400)) ; max I taken at first 3 wls
         diff = imax-imin   
         iline1 = iline
         erg = min(iline1,posmin1)
         posmin1 = posmin1
         iwing(k,kk) = imax     ; I_c = max I
      ; bisectors
      for kkk = 1,30 do begin & iref = imin+kkk/30.*diff &  ttemp = iline1(0:posmin1)-iref &  ff = where(ttemp gt 0) & posmin_left = max(ff) & ttemp = iline1(posmin1:*)-iref & ff = where(ttemp gt 0) & posmin_right = min(ff)+posmin1 & if min(ff) eq -1 then posmin_right = 180.-1 & bisectors(kkk-1,k,kk) = (posmin_right+posmin_left)/2. &  bisectors_int(kkk-1,k,kk)= iref & bisectors_width(kkk-1,k,kk)= ( posmin_right -posmin_left) & endfor

         icore(k,kk) =  min(iline1) ;line-core intensity
         linedepth(k,kk) = iwing(k,kk) - icore(k,kk) ; a1(0)                        ; amplitude of Gaussian



         erg1 = min(iline1,posmin1) ; position of line core

         if posmin1 le 2 then posmin1 = 3
         if posmin1 ge n_elements(iline)-3 then posmin1 = n_elements(iline)-4
         lpff,iline1(posmin1-2:posmin1+2),ppos1 
         ppos1  = ppos1 + posmin1-2
         iline1_old = iline1
         vlos(k,kk) = ppos1

         erg1 = min(iline1(104-10:104+10),posmin2) ;
         posmin2 = posmin2 + 104-10
         lpff,iline1(posmin2-2:posmin2+2),ppos2
         ppos2  = ppos2 + posmin2-2
         vlos_blend1(k,kk) =  ppos2

         erg1 = min(iline1(425-10:425+10),posmin2) ;
         posmin2 = posmin2 + 425-10
         lpff,iline1(posmin2-2:posmin2+2),ppos2
         ppos2  = ppos2 + posmin2-2
         vlos_blend2(k,kk) =  ppos2

; prepare profile for rest of calculations: put continuum to ~0, flip
; profile in y -> absorption profile down from I_c turns into emission
; profile up from 0 
         iline1 = iline1 - iline1(0) & iline1 = -iline1

         if ppos1 gt n_elements(iline)-12 then  ppos1 = n_elements(iline)-12 
         if ppos1 le 11 then  ppos1 = 11 


         nn = length(iline1(ppos1-10:ppos1+10))
         erg2 = gaussfit(findgen(21),iline1(ppos1-10:ppos1+10),a1,nterms= 3) ;   fit of Gaussian to solar line
         
         linewidth(k,kk) = a1(2)*2*sqrt(2*alog(2))*dispersion ; FWHM of Gaussian
         eqiwidth(k,kk) = total(iline1)                 ; area of Gaussian

; for the calculation of line asymmetry, shift the profile to have
; line centered around pixel 103 -> fixed range around 103 can be used
         temp = fltarr(n_elements(iline),2)
         temp(*,0) = iline1
         temp(*,1) = iline1
         temp = shift_frac(temp,222-ppos1,0,'C')
         iline1 = reform(temp(*,0))
         lineasym(k,kk) = (total(iline1(204:222)) - total(iline1(222:240)))/ (total(iline1(204:222)) + total(iline1(222:240)))
     
   endfor
   print,k

   tvscl,iwing,0,0
   tvscl,icore,tt(1),0
   tvscl,vlos-mean(vlos(where(vlos ne 0))) >(-5) < 5.,tt(1),tt(3)
   tvscl,lineasym < .5 >(-.5),0,tt(3)

   tvscl,vlos_blend1-mean(vlos_blend1(where(vlos_blend1 ne 0))) >(-2) < 2.,tt(1)*2,0
   tvscl,vlos_blend2-mean(vlos_blend2(where(vlos_blend2 ne 0))) >(-2) < 2.,tt(1)*3,0
  

endfor




print,'Saving to: ',outfile_1

save,  icore ,   iwing ,   vlos ,   lineasym,   linedepth,   linewidth,   eqiwidth,   bisectors ,   bisectors_int ,   bisectors_width, vlos_blend1,vlos_blend2,filename = outfile_1


endfor





stop



end

