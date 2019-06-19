pro ibis_180915_6563

ftsread,data,6520,6590,xlam = xlam
data = swap_endian(data)/10000.
xlam = xlam / 10.

inpath = '/net/koa/export/data/cbeck/obs2015/obs_sep_2015/IBIS_180915_reduced/180915_nb_141034_6563/'
;data/cbeck/obs2014/130314/IBIS_130314/reduced_IBIS_130314/nb_130314_6563/'

erg = read_directory(inpath,filter = '*nb*.sav')
files = erg.files

outpath = '/net/koa/export/data/cbeck/obs2015/obs_sep_2015/IBIS_180915_reduced/180915_nb_141034_6563/velomaps_6563/'

; data/cbeck/obs2014/130314/lineparam_ibis/'

for ww = 0,395 do begin 

   infile = inpath + files(ww)
   outfile_1 = outpath + 'lineparam_'+files(ww)
   restore, infile

   ll_halpha = info_nb.wave/10.

   pp = 1
   if pp eq 1 then begin

      full_spec = transpose(nb_data_dstr,[0,2,1])
      tt = size(full_spec)
      ic = reform(full_spec(*,0,*))
      ff = where(ic eq ic(0,0))

      mask = ic - ic + 1.
      mask(ff) = 0.

      i_norm = mean(ic(240:740,240:740))

      window,0,xs = 1000, ys = 1000
      tvscl,ic
      draw_rec,[240,740],[240,740],/device

      
      avprof = total(total(full_spec(240:740,*,240:740),1),2)/521./521.


      nnorm = 2400.
      ftssplined = spline(xlam,data,ll_halpha,/double)

      ttemp = (avprof/nnorm)/ftssplined
      erg = gaussfit(ll_halpha,ttemp,a,nterms = 3)

   for k = 0,tt(1)-1 do begin & for kk = 0,tt(3)-1 do begin & full_spec(k,*,kk) = reform(full_spec(k,*,kk)) / nnorm / erg & endfor & endfor

      ff =where(finite(full_spec) ne 1)
      if ff(0) ne -1 then full_spec(ff) = 1.

      avprof = total(total(full_spec(240:740,*,240:740),1),2)/521./521.


      window,0
      !p.multi = 0

      plot,ll_halpha,avprof
      oplot,xlam,data,color =240


   endif

   tt =size(full_spec)

   ftssplined = spline(xlam,data,ll_halpha,/double)
   corr = avprof/ftssplined


for k = 0,tt(1)-1 do begin & for kk = 0,tt(3)-1 do begin & full_spec(k,*,kk) = full_spec(k,*,kk) / corr  & endfor & endfor

   avprof = total(total(full_spec(240:740,*,240:740),1),2)/521./521.
   fts_splined = spline(xlam,data,ll_halpha,/double)
 
   window,0
   laodct,41
   device,decomposed = 0

   plot,ll_halpha,avprof,/ylog
   oplot,ll_halpha,fts_splined,color = 120
   oplot,xlam,data,color = 80

   icore = fltarr(tt(1),tt(3))
   iwing = fltarr(tt(1),tt(3))
   vlos = fltarr(tt(1),tt(3))

   lineasym= fltarr(tt(1),tt(3))
   linedepth= fltarr(tt(1),tt(3))
   linewidth= fltarr(tt(1),tt(3))
   eqiwidth= fltarr(tt(1),tt(3))

   bisectors = fltarr(30,tt(1),tt(3)) ; center of bisectors at 10 intensity levels
   bisectors_int = fltarr(30,tt(1),tt(3)) ; intensity of the 10 intensity levels
   bisectors_width = fltarr(30,tt(1),tt(3)) ; width of the 10 intensity levels

   iline = avprof
   
   imin = min(iline,posmin)     ; min value in av. prof
   posmin = posmin              ; position of line core
   imax = mean(iline(0:1))      ; max value in av. prof
   diff = imax-imin ; determination of 10 bisectors between minimum and maximum intensity in the profile. 

; spline the profile for the bisectors
   iline1 = spline(findgen(27),avprof,findgen(260)/10.)
   lambda_splined = spline(findgen(27),ll_halpha,findgen(260)/10.)

   erg = min(iline1,posmin1)    ; position of line core in splined profile

; test of loop
   k = 0       
   kk = 0

   laodct,41
   device,decomposed = 0
; display result
   window,2,title = 'Test of bisector determination'
   !p.multi = 0



   cchars =.7
   ssyms = .8

   ;set_plot,'PS'
   ;device,filename ='/net/cbeck-pc1/export/cbeck/work/cajets/halpha_ibis_prof.ps',xs = 8.4,ys = 4,bits_per_pixel = 8,/color

   plot,ll_halpha,avprof,xr = [ll_halpha(0)-.02,max(ll_halpha)+.02],/xstyle,charsize = cchars,xtitle ='!4k!3 [nm]',thick = 2.,ytitle = 'I/I!Dc!N',yr = [.1,.8],/ystyle,psym = -1,symsize = ssyms
   oplot,xlam,data,color = 240


;   plot,ll_halpha,iline
 ; calculate bisectors, left/right end of bisector where |I - iref| = minimal 
for kkk = 1,30 do begin & iref = imin+kkk/30.*diff &  ttemp = iline1(0:posmin1)-iref &  ff = where(ttemp gt 0) & posmin_left = max(ff) & ttemp = iline1(posmin1:*)-iref & ff = where(ttemp gt 0) & posmin_right = min(ff)+posmin1 & if min(ff) eq -1 then posmin_right = 260.-1 & bisectors(kkk-1,k,kk) = (lambda_splined(posmin_right)+lambda_splined(posmin_left))/2. &  bisectors_int(kkk-1,k,kk)=iref & bisectors_width(kkk-1,k,kk)= (lambda_splined(posmin_right) -lambda_splined(posmin_left)) & oplot,lambda_splined([posmin_left,posmin_right]),[0,0]+iref,color = (10+kkk*20) mod 254 & oplot,[0,0]+ bisectors(kkk-1,k,kk),[imax,iref],color = (10+kkk*20) mod 254 &  endfor


  legend1,text =[' FTS',' OBS'],charsize = cchars,pos = [656.35,.15],/data,/no_box,linestyle = fltarr(2),color = [240,0],ttextcolor = [240,0],thick =[1,3]
  plots,656.38+[0,0],[0,0]+.345,psym = 1,/data
  xyouts,656.375,.33,'   sampling',charsize = cchars,/data

;device,/close
;set_plot,'X'
;stop



; print,kkk,posmin_left/10.,posmin_right/10.

   laodct,0

window,0,xs = 1000, ys = 1000

; loop over spectra
   for k = 0,tt(1)-1 do begin
      for kk = 0,tt(3)-1 do begin

         iline = reform(full_spec(k,*,kk))
         imin = min(iline,posmin)
         posmin = posmin
         imax = mean(iline(0:1)) ; max I taken at first 3 wls
         diff = imax-imin   
         iline1 = spline(findgen(27),iline,findgen(260)/10.)
         erg = min(iline1,posmin1)
         iwing(k,kk) = imax     ; I_c = max I
      ; bisectors
      for kkk = 1,30 do begin & iref = imin+kkk/30.*diff &  ttemp = iline1(0:posmin1)-iref &  ff = where(ttemp gt 0) & posmin_left = max(ff) & ttemp = iline1(posmin1:*)-iref & ff = where(ttemp gt 0) & posmin_right = min(ff)+posmin1 & if min(ff) eq -1 then posmin_right = 260.-1. & bisectors(kkk-1,k,kk) = (lambda_splined(posmin_right)+lambda_splined(posmin_left))/2. &  bisectors_int(kkk-1,k,kk)= iref & bisectors_width(kkk-1,k,kk)= (lambda_splined(posmin_right) -lambda_splined(posmin_left)) & endfor

         icore(k,kk) =  min(iline1) ;line-core intensity
         linedepth(k,kk) = iwing(k,kk) - icore(k,kk) ; a1(0)                        ; amplitude of Gaussian

         erg1 = min(iline1,posmin1) ; position of line core
         lpff,iline1(posmin1-2:posmin1+2),ppos1 
         ppos1  = ppos1 + posmin1-2
         iline1_old = iline1

         iline2 = spline(lambda_splined,iline1,656.119+findgen(200)*1.6/1000.)
         iline2_old = iline2
         
         erg2 = min(iline2,posmin2) ; position of line core
         lpff,iline2(posmin2-3:posmin2+3),ppos2
         ppos2  = ppos2 + posmin2-3

         vlos(k,kk) = ppos2

; prepare profile for rest of calculations: put continuum to ~0, flip
; profile in y -> absorption profile down from I_c turns into emission
; profile up from 0 

         if ppos2 lt 20 then ppos2 = 20
         if ppos2 ge 180 then ppos2 = 179

         iline2 = iline2 - iline2(0) & iline2 = -iline2
         nn = length(iline2(ppos2-20:ppos2+20))
         erg2 = gaussfit(findgen(41),iline2(ppos2-20:ppos2+20),a1,nterms= 3) ;   fit of Gaussian to solar line

        ; vlos(k,kk) = a1(1)

         linewidth(k,kk) = a1(2)*2*sqrt(2*alog(2))*1.6 ; FWHM of Gaussian  ; should be 1.6 !
         eqiwidth(k,kk) = total(iline2)                 ; area of Gaussian

; for the calculation of line asymmetry, shift the profile to have
; line centered around pixel 103 -> fixed range around 103 can be used
         temp = fltarr(200,2)
         temp(*,0) = iline2
         temp(*,1) = iline2
         temp = shift_frac(temp,103-ppos2,0,'C')
         iline2 = reform(temp(*,0))
         lineasym(k,kk) = (total(iline2(50:103)) - total(iline2(103:156)))/ (total(iline2(50:103)) + total(iline2(103:156)))
      

   endfor
   print,k

   tvscl,congrid(iwing,500,500,/interp),0,0
   tvscl,congrid(icore,500,500,/interp),tt(1)/2.,0
;   tvscl,congrid(vlos-mean(vlos(where(vlos ne 0))),500,500,/interp) >(-10) < 10.,tt(1)/2.,tt(3)/2.

   vv = reform(bisectors(1,*,*))
  
   tvscl,congrid(vv-656.28,500,500,/interp)>(-.05) < .05,tt(1)/2.,tt(3)/2.
   tvscl,congrid(lineasym,500,500,/interp) < .5 >(-.5),0,tt(3)/2.

endfor


print,'Saving to ',outfile_1

save,  icore ,   iwing ,   vlos ,   lineasym,   linedepth,   linewidth,   eqiwidth,   bisectors ,   bisectors_int ,   bisectors_width, filename = outfile_1



endfor

exit

stop



end

