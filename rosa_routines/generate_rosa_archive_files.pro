pro generate_rosa_archive_files,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,oof = oof,single_fits = single_fits

if n_elements(oof) eq 0 then oof = 0.
 
cr = string(13b)

;inpath = '/net/secchi/export/data/dstservice/rawdata/19_jan_2013/rosa/'
;outpath = '/export/cbeck/ROSA_archive/2013/190113/'

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
   ;erg = read_directory(direcs(kkk),filter = 'das?_rosa_20*0000.fit')

   if n_elements(single_fits) eq 0 then erg = read_directory(direcs(kkk),filter = 'das?_rosa_20*0000.fit') else erg = read_directory(direcs(kkk),filter = '*cam_data_??.??.??.fits')


   basefiles1 = erg.files(where(erg.types eq 0))
   basefiles = direcs(kkk)+erg.files(where(erg.types eq 0))

   nfiles = n_elements(basefiles)

   for kkkk = 0,n_elements(basefiles)-1 do begin 

      ffilter = strmid(basefiles1(kkkk),0,strlen(basefiles1(kkkk))-8)
      
      erg = read_directory(direcs(kkk),filter = ffilter+'*')
      files1 = erg.files(where(erg.types eq 0))
      files = direcs(kkk)+erg.files(where(erg.types eq 0))
      nfiles = n_elements(files1)

      if n_elements(single_fits) ne 0 and nfiles gt 1 then begin
         files1 = shift(files1,1)
         files = shift(files,1)
      endif

      print,' Found '+num2string(fix(nfiles))+' file(s) in ',direcs(kkk)+' for basefile '+files1

  
    if n_elements(comments) ne 0 then begin
        if n_elements(comments) ne nfiles then comments = strarr(nfiles)+comments
    endif
    if n_elements(target) ne 0 then begin
        if n_elements(target) ne nfiles then target = strarr(nfiles)+target
    endif

; loop over files
  ;  for k =0.,0 do begin

k = 0


; read header information 
fxread,files(k),data,hdr,/nodata

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
hhour = erg(0)-oof & mmin = erg(1) & ssec = round(erg(2))

kk = nfiles-1
fxread,files(kk),data,hdr,/nodata,extension = 1

pos = stregex(hdr,'DATE')
pos = min(where(pos ne -1))

erg = string2num(strmid(hdr(pos),pos,30),divider = "T:")
schour = erg(0)-oof & scmin = erg(1) & scsec = round(erg(2))

fxread,files(k),data,hdr,/nodata,extension = 1

pos = stregex(hdr,'NAXIS1')
pos = min(where(pos ne -1))
dx = string2num(hdr(pos),divider = " ")
dx = dx(0)

pos = stregex(hdr,'NAXIS2')
pos = min(where(pos ne -1))
dy = string2num(hdr(pos),divider = " ")
dy = dy(0)

print,'Reading images...'

fxread,files(k),data,hdr,extension = 1
img = data

endif else begin

fxread,files(k),data,hdr
img = data

pos = stregex(hdr,'DATE')
pos = min(where(pos ne -1))
erg = string2num(hdr(pos),divider = "'-")
yyear = erg(0) & mmonth = erg(1) & dday = erg(2)

erg = string2num(hdr(pos),divider = "T:")
hhour = erg(0)-oof & mmin = erg(1) & ssec = round(erg(2))

pos = stregex(hdr,'NAXIS1')
pos = min(where(pos ne -1))
dx = string2num(hdr(pos),divider = " ")
dx = dx(0)

pos = stregex(hdr,'NAXIS2')
pos = min(where(pos ne -1))
dy = string2num(hdr(pos),divider = " ")
dy = dy(0)

pos = stregex(hdr,'DATE')
pos = min(where(pos ne -1))

erg = string2num(hdr(pos),divider = "T:")
schour = erg(0)-oof & scmin = erg(1) & scsec = round(erg(2))

img = reform(img(*,*,0))

schour = schour + 1
hhour = hhour +1

endelse


pplaindir = plaindir(kkk)
pplaindir = strmid(pplaindir,0,strlen(pplaindir)-1)

ttemp = strsplit(direcs(kkk),'/',/extract)

;wavelen = ttemp(n_elements(ttemp)-1)


; generate text file with header information
out_text =  outpath+files1(k)+'.'+pplaindir+'.txt'

out_text =  outpath+files1(k)+'.txt'

openw,out_unit,out_text,/get_lun
;printf,out_unit,'File: '+plaindir(kkk)+files1(k)+' to '+plaindir(kkk)+files1(nfiles-1)

printf,out_unit,'File: '+files1(k)+' to '+files1(nfiles-1)

printf,out_unit,'Date: '+num2string(fix(yyear))+'/'+num2string(fix(mmonth))+'/'+num2string(fix(dday))
            if hhour lt 10 then hhourtext = '0'+num2string(fix(hhour)) else hhourtext = num2string(fix(hhour))
            if mmin lt 10 then mmintext = '0'+num2string(fix(mmin)) else mmintext = num2string(fix(mmin))
            if ssec lt 10 then ssectext = '0'+num2string(fix(ssec)) else ssectext = num2string(fix(ssec))
                
        if schour lt 10 then schourtext = '0'+num2string(fix(schour)) else schourtext = num2string(fix(schour))
        if scmin lt 10 then scmintext = '0'+num2string(fix(scmin)) else scmintext = num2string(fix(scmin))
        if scsec lt 10 then scsectext = '0'+num2string(fix(scsec)) else scsectext = num2string(fix(scsec))

        printf,out_unit,'Time: '+hhourtext+':'+mmintext+':'+ssectext+' until '+schourtext+':'+scmintext+':'+scsectext
        printf,out_unit,'Field of view: '+num2string(dx*sampl)+'x'+num2string(dy*sampl)
        printf,out_unit,'Exp. time: '+num2string(expo)
        printf,out_unit,'Image correction: '+corr_status

if n_elements(target) eq 0 then printf,out_unit,'Target: ' else printf,out_unit,'Target: '+target(k)
 if n_elements(comments) eq 0 then printf,out_unit,'Comments: 'else printf,out_unit,'Comments: '+comments(k)
        printf,out_unit,' '
        free_lun,out_unit

     
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
       
       loadct,0,/silent
       device,decomposed = 0
       
       window,0,xsize =ssizex,ysize = ssizey
       
     

       if n_elements(rev) eq 0 then begin
             tvscl,transpose(congrid(reform(img),ssizex,ssizey,/interp)),0,0
       
        endif else begin
           
           tvscl,reverse(reverse(transpose(congrid(reform(img),ssizex,ssizey,/interp)),2),1),0,0
       
        endelse

           xyouts,.01,.01,'I('+wavelen+')',charsize=1.5,charthick = 1.5,/normal,color=255
        
           plot,fltarr(5),/nodata,/noerase,charsize = .001,pos = [0,0,1.,1],/normal
          



       out_gif = outpath+files1(k)+'.'+pplaindir+'.gif'

       out_gif = outpath+files1(k)+'.gif'

       a = tvrd()
       write_gif,out_gif,a  


    endfor


 
nextfile:


endfor



wdelete,0

;stop

end





