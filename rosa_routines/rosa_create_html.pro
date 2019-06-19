pro rosa_create_html,filepath = filepath,target = target, comments = comments, help = help

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

; input path
if n_elements(filepath) eq 0 then begin
cd,current = filepath
filepath = filepath+'/'
endif

; find all .gif, .ps, .txt in the directory
erg = read_directory(filepath,filter = '*.gif')
files =  erg.files

erg2 = read_directory(filepath,filter = '*.ps')
files2 =  erg2.files

erg1 = read_directory(filepath,filter = '*.txt')
files1 = erg1.files

filenum = max(n_elements(files1))

ttimes = fltarr(n_elements(files))

;stop

;for k = 0,n_elements(files)-1 do begin & erg = string2num(files(k),divider = '._') & ttimes(k) = erg(1)+erg(2)/60.+erg(3)/3600. & endfor

for k = 0,n_elements(files)-1 do begin & erg = string2num(files(k),divider = '._') & ttimes(k) = erg(0)+erg(1)/60.+erg(2)/3600. & endfor

ff = sort(ttimes)
ttimes = ttimes(ff)
files = files(ff)
files1 = files1(ff)


; generate Overview page file name
fff = strsplit(filepath,'/',/extract)
fff = fff(n_elements(fff)-1)

fff = long(fff)
if fff/100000 eq 0 then textstring = '0'+num2string(fff) else textstring = num2string(fff)

openw,out_unit,filepath+'Overview.'+textstring+'.html',/get_lun

; print out html header declaration
printf,out_unit,'<!DOCTYPE doctype PUBLIC "-//w3c//dtd html 4.0 transitional//en">'
printf,out_unit,'<html>'
printf,out_unit,'<head>'
printf,out_unit,'  <meta content="text/html; charset=iso-8859-1"'
printf,out_unit,' http-equiv="Content-Type">'
printf,out_unit,'  <meta content="Mozilla/4.7 [en] (X11; I; SunOS 5.8 sun4u) [Netscape]"'
printf,out_unit,' name="GENERATOR">'
printf,out_unit,'  <title>'+textstring+'</title>'
printf,out_unit,'</head>'
printf,out_unit,'<body bgcolor="#FF66FF">'

printf,out_unit,'<a href="../../ROSA_archivemain.html"> <big>Back to main page </big></a><br><br>' 


; loop over files
for k = 0,filenum-1 do begin
printf,out_unit,'<br>'
printf,out_unit,'<br>'

if files1(k) eq '' and files(k) eq '' then printf,out_unit,'<a href="'+files2(k)+'"> '+files2(k)+' </a><br>'

; read in all lines in .txt file
if files1(k) ne '' then begin
openr,in_unit,filepath+files1(k),/get_lun

erg2 = fstat(in_unit) & max_size = erg2.size
aa = bytarr(max_size)
readu,in_unit,aa
point_lun,in_unit,0
ff = n_elements(where(aa eq 10))
do_ca = 0

for kk = 0,ff-1 do begin
a = strarr(1)
readf,in_unit,a

;print,a,kk

if kk eq 3 then b = string2num(a)

; add target and comments, if specified
if kk eq 6 and n_elements(target) ne 0 then a = a+' '+target
if kk eq 7 and n_elements(comments) ne 0 then a = a+' '+comments

printf,out_unit,'<span style="color: rgb(51, 0, 51);">'+a+'</span><br style="color: rgb(51, 0, 51);">'



endfor



printf,out_unit,'<br>'
free_lun,in_unit

endif

; include gif file of visible data, link it with .ps files
if files(k) ne '' then begin

basefile = strmid(files1(k),0,strlen(files1(k))-3)

ergg = read_directory(filepath,filter = basefile+'gif')
imgfiles = ergg.files

tdiff = fltarr(4)+10.
for kk = 1,3 do begin & if k+kk le n_elements(ttimes)-1 then tdiff(kk) = ttimes(k+kk)-ttimes(k) & endfor

tdiff(0) = 0
ff = where(tdiff lt 0.01)

if ff(0) ne -1 then begin
   imgfiles = strarr(n_elements(ff))
   for kk = 0,n_elements(ff)-1 do begin
      basefile = strmid(files1(k+kk),0,strlen(files1(k+kk))-3)
      ergg = read_directory(filepath,filter = basefile+'gif')
      imgfiles(kk) = ergg.files
   endfor
endif

for kk = 0,n_elements(imgfiles)-1 do begin

    read_gif,filepath+imgfiles(kk),a

    a = size(a)

    ssize =  a(1)             ;

;if floor(b(0)*b(1)/47.27*81.5*4.) gt a(1) then ssize =  a(1)*2
    hheight = a(2)      

    printf,out_unit,'<a href="'+imgfiles(kk)+'"><img style="border: 2px solid ; width: '+num2string(fix(ssize))+'px; height: '+num2string(hheight)+'px; alt="'+imgfiles(kk)+'" src= "'+imgfiles(kk)+'"></a>'

endfor
printf,out_unit,'<br>'

endif

;print,k,files(k)
if n_elements(ff) gt 1 then k = k +n_elements(imgfiles)-1
;if k lt n_elements(files) then print,k,files(k)

endfor



printf,out_unit,'</body>'
printf,out_unit,'</html>'

free_lun,out_unit


end
