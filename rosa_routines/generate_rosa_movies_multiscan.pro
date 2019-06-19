pro generate_rosa_movies_multiscan,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,align = align,ssampl = ssampl,rrange = rrange,ssmooth_width = ssmooth_width,single_fits = single_fits,start_scan = start_scan

if n_elements(start_scan) eq 0 then start_scan = 0.

if n_elements(ssampl) eq 0 then ssampl = 3.
if n_elements(ssmooth_witdh) eq 0 then ssmooth_width = 1.
 if n_elements(wavelen) eq 0 then wavelen = 393.

cr = string(13b)

; set input path to current directory 
if n_elements(inpath) eq 0 then begin
cd,current = current
inpath = current+'/'
endif

corr_status = 'AO'


; set output path to current directory if not specified otherwise
if n_elements(outpath) eq 0 then outpath = inpath


erg = read_directory(inpath)
direcs = erg.files(where(erg.types eq 1))+'/'
plaindir = direcs
direcs = inpath+direcs

direcs = inpath

nn = n_elements(direcs)


sampl = 0.05

for kkk = 0,nn-1 do begin

; read in all calibrated data files
 
if n_elements(single_fits) eq 0 then erg = read_directory(direcs(kkk),filter = 'das?_rosa_20*0000.fit') else erg = read_directory(direcs(kkk),filter = '*cam_data_??.??.??.fits')

   basefiles1 = erg.files(where(erg.types eq 0))
   basefiles = direcs(kkk)+erg.files(where(erg.types eq 0))

   nfiles = n_elements(basefiles)


   for kkkk = start_scan,n_elements(basefiles)-1 do begin 

      ffilter = strmid(basefiles1(kkkk),0,strlen(basefiles1(kkkk))-8)
      
      erg = read_directory(direcs(kkk),filter = ffilter+'*')
      files1 = erg.files(where(erg.types eq 0))
      files = direcs(kkk)+erg.files(where(erg.types eq 0))
      nfiles = n_elements(files1)


      if n_elements(single_fits) ne 0 and nfiles gt 1 then begin
         files1 = shift(files1,1)
         files = shift(files,1)
      endif

      print,' Found '+num2string(fix(nfiles))+' file(s) in ',direcs(kkk)+' for basefile '+basefiles1(kkkk)
      print,files1

  
    if n_elements(comments) ne 0 then begin
        if n_elements(comments) ne nfiles then comments = strarr(nfiles)+comments
    endif
    if n_elements(target) ne 0 then begin
        if n_elements(target) ne nfiles then target = strarr(nfiles)+target
    endif



iiindex = 0

; loop over files
for k =0.,nfiles-1 do begin

;k = 0


; read header information 
   fxread,files(k),data1,hdr,/nodata

   pos = stregex(hdr,'EXPOSURE')
   pos = min(where(pos ne -1))
   expo = string2num(hdr(pos),divider = "' ")*1000.


   if n_elements(single_fits) eq 0 then begin

      fxread,files(k),data,hdr,/nodata,extension = 1

      pos = stregex(hdr,'DATE')
      pos = min(where(pos ne -1))
      erg = string2num(strmid(hdr(pos),pos,30),divider = "'-")
      yyear = erg(0) & mmonth = erg(1) & dday = erg(2)

      erg = string2num(strmid(hdr(pos),pos,30),divider = "T:")
      hhour = erg(0) & mmin = erg(1) & ssec = round(erg(2))

      fxread,files(k),data,hdr,extension = 1
      sssize = size(data)

      openr,in_unit,files(k),/get_lun
      erg = fstat(in_unit)
      ssize = erg.size
      free_lun,in_unit
      nextensions = fix(ssize / float(2.*sssize(1)*sssize(2)))

   endif else begin

      fxread,files(k),data
      tt = size(data)
      nextensions = tt(3)
      dx = tt(1)
      dy = tt(2)

   endelse

   for kk = 0.,nextensions-1,ssampl do begin

      if n_elements(single_fits) eq 0 then begin

         fxread,files(k),data,hdr,/nodata,extension = 1+kk

         pos = stregex(hdr,'NAXIS1')
         pos = min(where(pos ne -1))
         dx = string2num(hdr(pos),divider = " ")
         dx = dx(0)
         
         pos = stregex(hdr,'NAXIS2')
         pos = min(where(pos ne -1))
         dy = string2num(hdr(pos),divider = " ")
         dy = dy(0)
         
         print,'Reading images...',nn-1-kkk,nfiles-1-k,nextensions-1-kk,iiindex

         fxread,files(k),data,hdr,extension = 1+kk
         img = data

         endif else begin
            img = reform(data(*,*,kk))
        

         endelse

         iimg = img

         erg = fxpar(hdr,'DATE')
         erg = string2num(erg,divider = 'T:.')
         schour = erg(1)
         scmin = erg(2)
         scsec = erg(3)

         maxi = round(max(img))


   if schour ge 10 then schourtext = num2string(fix(schour)) else  schourtext = '0'+num2string(fix(schour))
   if scmin ge 10 then scmintext = num2string(fix(scmin)) else  scmintext = '0'+num2string(fix(scmin))
   if scsec ge 10 then scsectext = num2string(fix(scsec)) else  scsectext = '0'+num2string(fix(scsec))


   pplaindir = plaindir(kkk)
   pplaindir = strmid(pplaindir,0,strlen(pplaindir)-1)

   ttemp = strsplit(direcs(kkk),'/',/extract)
   
;   if n_elements(single_fits) eq 0 then wavelen = ttemp(n_elements(ttemp)-1)
     
; create gif file

       sscale = .25
       if n_elements(twice) ne 0 then sscale = twice

       ssizex = dx*sscale
       ssizey = dy*sscale

       eerg = get_screen_size()
       xdimmax = eerg(0)
       ydimmax = eerg(1)

       while (ssizex gt xdimmax or ssizey gt ydimmax) do  begin
           ssizex = ssizex /1.5
           ssizey = ssizey /1.5
       endwhile

       ssizex = ssizex(0)
       ssizey = ssizey(0)

       if (ssizey mod 2) ne 0 then ssizey = ssizey - 1
       
       loadct,0,/silent
       device,decomposed = 0
       
       if iiindex eq 0 then window,0,xsize =ssizex,ysize = ssizey else wset,0

       if n_elements(rev) eq 0 then begin

          ii = smooth(transpose(congrid(reform(img),ssizex,ssizey,/interp)),ssmooth_width,/edge_truncate)

          if n_elements(rrange) ne 0 then begin
             ii = ii/median(ii)
             ii(0,0) = rrange(0)
             ii(0,1) = rrange(1)
             ii = ii > rrange(0) < rrange(1)
          endif



             tvscl,ii,0,0
       
        endif else begin
           
          ii = smooth(reverse(reverse(transpose(congrid(reform(img),ssizex,ssizey,/interp)),2),1),ssmooth_width,/edge_truncate)

          if n_elements(rrange) ne 0 then begin
             ii = ii/median(ii)
             ii(0,0) = rrange(0)
             ii(0,1) = rrange(1)
             ii = ii > rrange(0) < rrange(1)
          endif

          tvscl,ii,0,0
       
        endelse

           xyouts,.01,.01,'I('+wavelen+')',charsize=1.5,charthick = 1.5,/normal,color=255
        
           plot,fltarr(5),/nodata,/noerase,charsize = .001,pos = [0,0,1.,1],/normal

           xyouts,.35,.9,schourtext+':'+scmintext+':'+scsectext,charsize = 1.5,/normal,charthick = 1.5,color = 255

           xyouts,.35,.85,'Imax: '+num2string(maxi),charsize = 1.5,/normal,charthick = 1.5,color = 255




;       out_gif = outpath+files1(k)+'.'+pplaindir+'.gif'
       a = tvrd()
 ;      write_gif,out_gif,a  


       if n_elements(align) ne 0 then begin
          if kk gt 0 then begin
             erg = shc(img,imgold,/filt,/interp)
             print,erg

         ;    b = a

;             if total(abs(erg)) lt 10 then b(ssizex:2*ssizex-1,*) = shift_frac(b(ssizex:2*ssizex-1,*),-erg(0),-erg(1),'C')
             
           fxread,files(k),data,hdr,extension = 1+kk
           iimg = data
           pp = 1
           if pp eq 1 then begin
             if total(abs(erg)) lt 10 then begin
                erg = erg
                img  = shift_frac(img,-erg(0),-erg(1),'C')
                iimg  = shift_frac(iimg,-erg(0),-erg(1),'C')

             endif

             img = img /mean(img)
             img(0,0) = .5
             img(0,1) = 1.2
             img = img > .5 <1.2

             if n_elements(rev) eq 0 then begin
                tvscl,smooth(transpose(congrid(reform(img),ssizex,ssizey,/interp)),ssmooth_width,/edge_truncate),0,0

             endif else begin
           
                tvscl,smooth(reverse(reverse(transpose(congrid(reform(img),ssizex,ssizey,/interp)),2),1),ssmooth_width,/edge_truncate),0,0
                
             endelse

           xyouts,.01,.01,'I('+wavelen+')',charsize=1.5,charthick = 1.5,/normal,color=255
        
           plot,fltarr(5),/nodata,/noerase,charsize = .001,pos = [0,0,1.,1],/normal

           xyouts,.35,.9,schourtext+':'+scmintext+':'+scsectext,charsize = 1.5,/normal,charthick = 1.5,color = 255

           xyouts,.35,.85,'Imax: '+num2string(round(max(img))),charsize = 1.5,/normal,charthick = 1.5,color = 255



          endif


       endif
          a = tvrd()

       endif


       imgold = iimg
       aold = a


       if iiindex lt 10 then textindex = '000'+num2string(fix(iiindex))
       if iiindex ge 10 and iiindex lt 100 then textindex = '00'+num2string(fix(iiindex))
       if iiindex ge 100 and iiindex lt 1000 then textindex = '0'+num2string(fix(iiindex))
       if iiindex ge 1000 and iiindex lt 10000 then textindex = num2string(fix(iiindex))

       iiindex = iiindex + 1

       out_jpg = outpath+textindex+'.jpg'
       write_jpeg,out_jpg,a

       if iiindex ge 10000 then stop

       if n_elements(single_fits) ne 0 then print,iiindex

    endfor


endfor

   print,'cd '+outpath

 ;  if n_elements(single_fits) eq 0 then begin
   
  ;    print,'avconv -i %04d.jpg -r 25 -b 65536k '+ files1(0)+'.'+pplaindir+'.'+num2string(fix(wavelen(0)))+'.mpg'
;   endif else begin
      print,'avconv -i %04d.jpg -r 25 -b 65536k '+ files1(0)+'.'+num2string(fix(wavelen(0)))+'.avi'

      
 ;  endelse



print,'Please copy the line above to the terminal...'

paused


;spawn,'avconv -i %04d.jpg -r 25 -b 65536k '+ files1(0)+'.'+pplaindir+'.'+num2string(fix(wavelen(kk)))+'.mpg'

cd,outpath
spawn,'rm *.jpg'



endfor



endfor







wdelete,0

;stop

end






