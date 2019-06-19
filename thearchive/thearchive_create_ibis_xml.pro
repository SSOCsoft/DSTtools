pro thearchive_create_ibis_xml,filepath = filepath,target = target, comments = comments,outpath = outpath, help = help

;+
;============================================================================
;
;	procedure : create_html
;
;	purpose  : Create Overview html-page for contents of a
;	           directory in the POLIS data archive.
;
;	written :  cbeck@KIS
;
;==============================================================================
;
;	Check number of arguments.
;
;==============================================================================
if n_elements(help) ne 0 then begin
	print
	print, "usage:  create_html,filepath = filepath,target = target,"
        print, "                    comments = comments, help = help"
	print
	print, "	Create Overview html-page from all ps/gif/text files"
        print, "        in a directory of the POLIS archive. Call "
        print, "        generate_archive_files before. Filename of html page"
        print, "        is generated from name of last subdirectory of"
        print, "        filepath. All gif files are linked with corresponding"
        print, "        ps-files. The text in the .txt file is included as"
        print, "        it is in the text file."
        print
	print, "	Arguments"
        print, "                None."
        print
        print, "        Keywords:"
        print, "               filepath : path to input directory. Either"
        print, "                        .gif,.txt. and .ps or only .ps files"
        print, "                        must exist."
        print, "               target='text' : will be added in html page."
        print, "               comments='text' : will be added in html page."
        print, "               Warning: target and comments are only added"
        print, "               to the html file, not the text file. This is"
        print, "               not recommended, use edit_archive_txt.pro."
        print
        return
endif
;==============================================================================
;-


outpath = '/export/cbeck/work/IBIS_xml/xml_exam/'
filepath ='/export/cbeck/THE_archive/2013/01/200113/'
filepath ='/export/cbeck/THE_archive/2013/10/261013/'

; input path
if n_elements(filepath) eq 0 then begin
cd,current = filepath
filepath = filepath+'/'
endif

; find full-disk jpg pointing images in the directory
erg_jpg = read_directory(filepath,filter = '*.jpg')
files_jpg =  erg_jpg.files

do_jpg = 0
if files_jpg(0) ne '' then do_jpg = 1

; find all .gif, .ps, .txt in the directory
erg = read_directory(filepath,filter = '*ScienceObservation*.gif')
files =  erg.files

if files(0) eq '' then print,filepath

erg1 = read_directory(filepath,filter = '*ScienceObservation*.txt')
files1 = erg1.files

if files1(0) eq '' then print,filepath

filenum = min([n_elements(files1),n_elements(files)])

files1 = files1(0:filenum-1)
files  = files(0:filenum-1)

ttime = fltarr(filenum,3,2)
iinstrument = strarr(filenum)
ttelescope = strarr(filenum)


for k = 0,n_elements(files1)-1 do begin

   openr,in_unit,filepath+files1(k),/get_lun
   erg2 = fstat(in_unit) & max_size = erg2.size
   aa = bytarr(max_size)
   readu,in_unit,aa
   point_lun,in_unit,0
   ff = n_elements(where(aa eq 10))
   do_ca = 0
;   for kk = 0,ff-1 do begin
   for kk = 0,ff-5 do begin
      a = strarr(1)
      readf,in_unit,a
      if kk eq 2 then b = string2num(a)   
  
; add target and comments, if specified
      if kk eq 9 and n_elements(target) ne 0 then a = a+' '+target
      if kk eq 10 and n_elements(comments) ne 0 then a = a+' '+comments
   endfor
   free_lun,in_unit

   ttime(k,*,0) = b(0:2)
   ttime(k,*,1) = b(3:5)

   erg = strmatch( files1(k), '*cc.txt' )
   if erg(0) eq 1 then begin
      iinstrument(k) = 'TIP'
      ttelescope(k) = 'VTT'
   endif

   erg = strmatch( files1(k), 'fe2*.txt' )
   if erg(0) eq 1 then begin
      iinstrument(k) = 'POLIS'
      ttelescope(k) = 'VTT'
   endif

   erg = strmatch( files1(k), '*hrt.map*.txt' )
   if erg(0) eq 1 then begin
      iinstrument(k) = 'SPINOR'
      ttelescope(k) = 'DST'
   endif

   erg = strmatch( files1(k), 'firs*.txt' )
   if erg(0) eq 1 then begin
      iinstrument(k) = 'FIRS'
      ttelescope(k) = 'DST'
   endif

   erg = strmatch( files1(k), 'das*.txt' )+ strmatch( files1(k), '*cam_data*txt')
   if erg(0) eq 1 then begin
      iinstrument(k) = 'ROSA'
      ttelescope(k) = 'DST'
   endif

   erg = strmatch( files1(k), 's00*.txt' )
   if erg(0) eq 1 then begin
      iinstrument(k) = 'IBIS'
      ttelescope(k) = 'DST'
   endif

 
endfor

starttime = ttime(*,0,0)+ttime(*,1,0)/60.+ttime(*,2,0)/3600.
endtime =  ttime(*,0,1)+ttime(*,1,1)/60.+ttime(*,2,1)/3600.

ff = sort(starttime)
starttime = starttime(ff)
endtime = endtime(ff)
files = files(ff)
files1 = files1(ff)
iinstrument = iinstrument(ff)
ttelescope =  ttelescope(ff)
for k = 0,2 do begin & for kk = 0,1 do begin ttime(*,k,kk) = ttime(ff,k,kk) & endfor & endfor


ffixstarttime = fix(starttime)
hhours = unique(ffixstarttime)


obstitle = strarr(filenum)+'SERVICE MODE'
ttarget = strarr(filenum)+''
sciobject =  strarr(filenum)+''
sciobs =  strarr(filenum)+''
scienmot = strarr(filenum)+''
scienpurp= strarr(filenum)+''
descript = strarr(filenum)+''

; loop over files
for k = 0,filenum-1 do begin


   outfile = outpath + ttelescope(k)+'_'+iinstrument(k)+'_'+strmid(files1(k),29,strlen(files1(k))-4-29)+'.xml'


; read in all lines in .txt file
if files1(k) ne '' then begin

  
   openr,in_unit,filepath+files1(k),/get_lun

   erg2 = fstat(in_unit) & max_size = erg2.size
   aa = bytarr(max_size)
   readu,in_unit,aa
   point_lun,in_unit,0
   ff = n_elements(where(aa eq 10))
   do_ca = 0

   full_text = strarr(ff-4)

   for kk = 0,ff-5 do begin
   
      a = strarr(1)
      readf,in_unit,a
      
      full_text(kk) = a

      if kk eq 3 then b = string2num(a)
      
; add target and comments, if specified
      if kk eq 9 and n_elements(target) ne 0 then a = a+' '+target
      if kk eq 10 and n_elements(comments) ne 0 then a = a+' '+comments

     
   endfor

  
   free_lun,in_unit

endif

fileyear  = strmid(files1(k),29,strlen(files1(k))-29-15)
filemonth = strmid(files1(k),33,strlen(files1(k))-33-13)
fileday   = strmid(files1(k),35,strlen(files1(k))-35-11)

filehour = strmid(files1(k),38,strlen(files1(k))-46)
filemin  = strmid(files1(k),40,strlen(files1(k))-46)
filesec  = strmid(files1(k),42,strlen(files1(k))-46)


;print,fileyear,' ',filemonth,' ',fileday,' ',filehour,' ',filemin,' ',filesec
; current time

erg = systime()
current_year = strmid(erg,strlen(erg)-4,4)
current_mm = strmid(erg,strlen(erg)-20,3)
if current_mm eq 'Jan' then current_month = '01'
if current_mm eq 'Feb' then current_month = '02'
if current_mm eq 'Mar' then current_month = '03'
if current_mm eq 'Apr' then current_month = '04'
if current_mm eq 'May' then current_month = '05'
if current_mm eq 'Jun' then current_month = '06'
if current_mm eq 'Jul' then current_month = '07'
if current_mm eq 'Aug' then current_month = '08'
if current_mm eq 'Sep' then current_month = '09'
if current_mm eq 'Oct' then current_month = '10'
if current_mm eq 'Nov' then current_month = '11'
if current_mm eq 'Dec' then current_month = '12'
current_day = strmid(erg,strlen(erg)-16,2)
if current_day lt 10 then current_day = '0'+strtrim(current_day,2)
current_time = strmid(erg,strlen(erg)-13,8)+'.000'

erg =string2num(full_text(7),divider = ' ,')
posx = num2string(fix(erg(0)))
posy = num2string(fix(erg(1)))

erg =string2num(full_text(6),divider = ' ,')
expos = num2string(fix(erg))

erg =string2num(full_text(5),divider = ' x')
dimx = num2string(fix(erg(0)))
dimy = num2string(fix(erg(1)))

erg =string2num(full_text(2),divider = ' :')
if fix(erg(0)) lt 10 then hourstart = '0'+ num2string(fix(erg(0))) else hourstart = num2string(fix(erg(0)))
if fix(erg(1)) lt 10 then minstart = '0'+num2string(fix(erg(1))) else minstart = num2string(fix(erg(1)))
if fix(erg(2)) lt 10 then secstart ='0'+num2string(fix(erg(2))) else secstart = num2string(fix(erg(2)))
if fix(erg(3)) lt 10 then hourend = '0'+num2string(fix(erg(3))) else hourend = num2string(fix(erg(3)))
if fix(erg(4)) lt 10 then minend = '0'+ num2string(fix(erg(4))) else minend = num2string(fix(erg(4)))
if fix(erg(5)) lt 10 then secend = '0'+num2string(fix(erg(5))) else secend = num2string(fix(erg(5)))


erg =string2num(full_text(1),divider = ' /')
yearstart = num2string(fix(erg(0)))
if fix(erg(1)) lt 10 then monthstart = '0'+num2string(fix(erg(1))) else monthstart = num2string(fix(erg(1)))
if fix(erg(2)) lt 10 then daystart = '0'+num2string(fix(erg(2))) else daystart = num2string(fix(erg(2)))

erg =string2num(full_text(4),divider = ' /')
nlambda = n_elements(erg)
llambda = num2string(fix(erg))
wavelen = llambda
for kk = 0,n_elements(llambda)-1 do begin & pos = stregex(full_text(4), llambda(kk)) & erg = strmid(full_text(4),pos+5,4) & llambda(kk) = llambda(kk)+' '+erg & endfor

lambdatext = strarr(n_elements(llambda))
for kk = 0,nlambda-1 do begin & lambdatext(kk) = llambda(kk) & endfor


archive_path = 'ftp://ftp.nso.edu/outgoing/cbeck/archives/THE_archive/'

imglink = strarr(nlambda)

for kk = 0,nlambda-1 do begin

   initial_letters = strmid(files1(k),0,3) 
   basefile = strmid(files1(k),0,strlen(files1(k))-3)
   ergg = read_directory(filepath,filter = basefile+'*'+wavelen(kk)+'*.gif')
   imgfiles = ergg.files
   imglink(kk) = archive_path+yearstart+'/'+monthstart+'/'+daystart+monthstart+num2string(yearstart-2000)+'/'+ imgfiles
   
endfor

 


   openw,out_unit,outfile,/get_lun


   printf,out_unit,'<?xml version="1.0" encoding="UTF-8"?>'
   printf,out_unit,'<VOEvent role="utility" ivorn="ivo://sot.lmsal.com/VOEvent#VOEvent_Obs'+ttelescope(k)+'_'+iinstrument(k)+'_'+fileyear+filemonth+fileday+'T'+filehour+':'+filemin+':'+filesec+'.xml" version="1.11" xmlns="http://www.ivoa.net/xml/VOEvent/v1.11" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:lmsal="http://sot.lmsal.com/lmsal" xmlns:crd="urn:nvo-coords" xsi:schemaLocation="http://www.ivoa.net/internal/IVOA/IvoaVOEvent/VOEvent-v1.0.xsd">'
   printf,out_unit,'	<Who>'
   printf,out_unit,'	<!-- Data pertaining to curation: observer, telescope, instrument, planner, tohbans, ... -->'
   printf,out_unit,'	<Date>'+current_year+'-'+current_month+'-'+current_day+'T'+current_time+'Z</Date>    <!-- Time VOEvent was generated. -->'
   printf,out_unit,'	<PublisherID>http://sot.lmsal.com</PublisherID>'
   printf,out_unit,'<Contact>'
   printf,out_unit,'	<Name>DST SMO team</Name>'
   printf,out_unit,'			<Institution>National Solar Observatory</Institution>'
  printf,out_unit,'			<Communication>'
 printf,out_unit,'				<Uri>http://www.nso.com</Uri>'
printf,out_unit,'				<AddressLine>3010 Coronal Loop, Sunspot 88349 NM, USA</AddressLine>'
printf,out_unit,'				<Telephone>null</Telephone>'
printf,out_unit,'				<Email>dstservice@nso.edu</Email>'
printf,out_unit,'			</Communication>		</Contact>'
printf,out_unit,'		<lmsal:Telescope>'+ttelescope(k)+'</lmsal:Telescope>'
printf,out_unit,'		<lmsal:Instrument>'+iinstrument(k)+'</lmsal:Instrument>'
printf,out_unit,'		<lmsal:Tohbans>null</lmsal:Tohbans>'
printf,out_unit,'		<lmsal:ChiefPlanner>null</lmsal:ChiefPlanner>'
printf,out_unit,'		<lmsal:ChiefObserver>null</lmsal:ChiefObserver>'
printf,out_unit,'	</Who>'
printf,out_unit,'	<What>'
printf,out_unit,'		<!-- Data about what was measured/observed.  Some tags come from predicted event. -->'
printf,out_unit,'		<Param name="URLParent" value="ftp://ftp.nso.edu/outgoing/cbeck/archives/THE_archive/THE_archivemain.html"/>'
printf,out_unit,'		<Param name="catalogLink" value="ftp://ftp.nso.edu/outgoing/cbeck/archives/THE_archive/THE_archivemain.html"/>'
printf,out_unit,'		<lmsal:JOP_ID>0</lmsal:JOP_ID>'
printf,out_unit,'		<lmsal:OBSTITLE>'+obstitle(k)+'</lmsal:OBSTITLE>'
printf,out_unit,'		<lmsal:TARGET>'+ttarget(k)+'</lmsal:TARGET>'
printf,out_unit,'		<lmsal:SCI_OBJ>'+sciobject(k)+'</lmsal:SCI_OBJ>'
printf,out_unit,'		<lmsal:SCI_OBS>'+sciobs(k)+'</lmsal:SCI_OBS>'
printf,out_unit,'	</What>'
printf,out_unit,'	<WhereWhen>'
printf,out_unit,'		<!-- Space and Time Coordinates. -->'
printf,out_unit,'		<ObservatoryLocation ID="'+ttelescope(k)+'"/>'
printf,out_unit,'		<ObservationLocation>'
printf,out_unit,'			<lmsal:xCen>'+posx+'</lmsal:xCen>		<!-- xcen and ycen from FITS -->'
printf,out_unit,'			<lmsal:yCen>'+posy+'</lmsal:yCen>'
printf,out_unit,'			<lmsal:xFov>'+dimx+'</lmsal:xFov>'
printf,out_unit,'			<lmsal:yFov>'+dimy+'</lmsal:yFov>'
printf,out_unit,'			<crd:AstroCoords coord_system_id="UTC-HGS-TOPO">'
printf,out_unit,'				<crd:Time>'
printf,out_unit,'					<crd:TimeInterval>'+yearstart+'-'+monthstart+'-'+daystart+'T'+hourstart+':'+minstart+':'+secstart+'.000Z '+yearstart+'-'+monthstart+'-'+daystart+'T'+hourend+':'+minend+':'+secend+'.000Z</crd:TimeInterval>'
printf,out_unit,'				</crd:Time>'
printf,out_unit,'				<crd:Position3D>'+posx+' '+posy+'</crd:Position3D>'
printf,out_unit,'			</crd:AstroCoords>'
printf,out_unit,'		</ObservationLocation>'


for kk = 0,nlambda-1 do begin
   printf,out_unit,'		<Group name="'+lambdatext(kk)+' Line Scans">'
   printf,out_unit,'			<Param name="FOVX" value="'+dimx+'"/>'
   printf,out_unit,'			<Param name="FOVY" value="'+dimy+'"/>'
   printf,out_unit,'			<Param name="NMATCHES" value=""/>'
   printf,out_unit,'			<Param name="DATE_END" value="'+yearstart+'-'+monthstart+'-'+daystart+'T'+hourend+':'+minend+':'+secend+'.000Z"/>'
   printf,out_unit,'			<Param name="CADENCE_MODE" value=""/>'
   printf,out_unit,'			<Param name="YCEN" value="'+posy+'"/>'
   printf,out_unit,'			<Param name="UMODE" value=""/>'
   printf,out_unit,'			<Param name="XCEN" value="'+posx+'"/>'
   printf,out_unit,'			<Param name="NAXIS1" value=""/>'
   printf,out_unit,'			<Param name="NAXIS2" value=""/>'
   printf,out_unit,'			<Param name="MEAN_EXPTIME" value="'+expos+'"/>'
   printf,out_unit,'			<Param name="WAVELNTH" value="'+lambdatext(kk)+'"/>'
   printf,out_unit,'			<Param name="DATE_OBS" value="'+yearstart+'-'+monthstart+'-'+daystart+'T'+hourstart+':'+minstart+':'+secstart+'.000Z"/>'


   printf,out_unit,'                    <Param name="URL_THUMB" value="'+imglink(kk)+'"/>'
   printf,out_unit,'		</Group>'
endfor

   printf,out_unit,'	</WhereWhen>'
   printf,out_unit,'	<Why>'
   printf,out_unit,'		<!-- Why was observation performed.  Initial scientific assessment, hypothesized mechanisms, classifications, ... -->'
   printf,out_unit,'		<Concept>'
   printf,out_unit,'			<lmsal:Goal>'+scienmot(k)+'</lmsal:Goal>'
printf,out_unit,'			<lmsal:Purpose>'+scienpurp(k)+'</lmsal:Purpose>'
printf,out_unit,'		</Concept>'
printf,out_unit,'		<Description>'
printf,out_unit,'	'+descript(k)	
printf,out_unit,'		</Description>'
printf,out_unit,'	</Why>'
printf,out_unit,'</VOEvent>'

ttimeold = fix(starttime(k))

free_lun,out_unit

endfor



stop


end
