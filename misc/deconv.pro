pro deconv

; get the pinhole data
restore,'/net/koa/export/data/cbeck/summer_project_2014/pinhole_data/140320.130808.0.ccc07.c-hrt.gband.pinhole.fits.reduced.sav'

; average the 10 images
ii = total(full_imag,1)/10.

; take a cut through the center of the pinhole in the image
ii1 = ii(500:1500,500:1500)
ii1 = ii1/max(ii1)

iline = reform(ii1(*,547))

; normalize to 1 at about maximum value
iline = iline/mean(iline(480:500))

; artificial pinhole
pinhole_true = iline-iline

; location of pinhole
x0 = 474
x1 = 505

pinhole_true(x0:x1) = 1.

; display of cut and artificial pinhole
window,0
plot,iline,xr = [400,600],/xstyle
oplot,pinhole_true
oplot,[0,1000],[0,0]+.5

; loop over different kernels

loadct,39,/silent
device,decomposed = 0

cchi_square = fltarr(100,100)
xx = findgen(n_elements(iline))

for k = 0.,99 do begin

   ; Gaussian
   sigma = (k+1.)/100.*2.
   kernel = exp( - ( xx-500.)^2. /  (2*sigma^2.) )   /(sqrt(2*!pi)*sigma) 

   for kk = 0.,99 do begin
      ; Lorentzian
      a = (kk+1.)/100.*3.
      kernel1 =  a / (xx^2.+a^2.)
      kkernel1 = iline - iline
      kkernel1(500:*) = kernel1(0:500)
      kkernel1(0:500) = reverse(kernel1(0:500))
      kkernel1 =  kkernel1 /total( kkernel1)

      ; convolve Gaussian and Lorentzian
      kkernel = convol(kernel,kkernel1,/edge_truncate)
      kkernel =  kkernel /total( kkernel)

; convolve artificial pinhole 
      convol_iline = convol(pinhole_true,kkernel,/edge_truncate)
      convol_iline = convol_iline/mean( convol_iline(480:500))

; calculate squared deviation
      cchi_square(k,kk) = total( (iline-convol_iline)^2.)

   endfor
   
   print,k
   tvscl,alog(cchi_square > .00001)

endfor

; find best fit 
erg = min(cchi_square,posmin)

x = posmin mod 100
y = posmin / 100

print,erg,cchi_square(x,y)

; get best-fit kernel
sigma = (x+1.)/100.*2.
a = (y+1.)/100.*3.
kernel = exp( - ( xx-500.)^2. /  (2*sigma^2.) )   /(sqrt(2*!pi)*sigma) 

kernel1 =  a / (xx^2.+a^2.)
kkernel1 = iline - iline
kkernel1(500:*) = kernel1(0:500)
kkernel1(0:500) = reverse(kernel1(0:500))
kkernel1 =  kkernel1 /total( kkernel1)
      
kkernel = convol(kernel,kkernel1,/edge_truncate)
kkernel =  kkernel /total( kkernel)

; apply to articificial pinhole      
convol_iline = convol(pinhole_true,kkernel,/edge_truncate)
convol_iline = convol_iline/mean( convol_iline(480:500))

; display results
window,1

plot,iline,xr = [400,600],/xstyle
oplot,pinhole_true
oplot,[0,1000],[0,0]+.5,linestyle = 2
oplot, convol_iline,color = 80
oplot,kkernel(10:*)/max(kkernel),color = 240

; test appplication to single example image
restore,'/net/koa/export/data/cbeck/obs2014/single_imag.sav'

; get one half of the 1D kernel
gg = kkernel(500:*)

; create a 2D version of the kernel
gg1 = fltarr(100,100)
for k = 0.,99-1 do begin & for kk = 0.,99-1 do begin & rr = sqrt((k-50.)^2.+(kk-50.)^2.) & if rr lt 200 then value = gg(rr) & if rr lt 200 then gg1(k,kk) = value & if rr ne 0 and rr lt 200 then gg1(k,kk) = gg1(k,kk)/(2.*!pi*rr)& endfor & endfor
gg1 = gg1 / total(gg1)

; insert 2D kernel in array of same dimensions as the image
ggt1 = fltarr(2048,2048)
ggt1(0:99,0:99) = gg1

; clear up image for NaN
ff = where(finite(ic) ne 1)
ff1 = where(finite(ic) eq 1)
if ff (0) ne -1 then ic(ff) = mean(ic(ff1))

; apply deconvolution
deconv = fft( fft(shift(ic,50,50),-1)*1./fft(ggt1,-1),1)
deconv = abs(deconv)

; display result
loadct,0,/silent
window,2,xs =1000,ys = 500
tvscl,alog(congrid(ic/mean(ic),500,500,/interp) >0.2 < 1.4)
tvscl,alog(congrid(deconv/mean(deconv),500,500,/interp)>0.2 < 1.4),500,0

stop

write_jpeg,'/export/raid2/cbeck/work/DST_observations/Consortium/March2018/deconvolution/pinhole_obs.jpg',a,/true

write_jpeg,'/export/raid2/cbeck/work/DST_observations/Consortium/March2018/deconvolution/psf_application.jpg',b
end
