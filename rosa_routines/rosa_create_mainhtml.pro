pro rosa_create_mainhtml,inpath =inpath,outfile = outfile

if n_elements(inpath) eq 0 then inpath = '/export/raid2/cbeck/work/ROSA_archive/'

;outfile = '/dat/granny_2/cbeck/archive/POLIS_archivemain.html'

if n_elements(outfile) eq 0 then outfile = '/export/raid2/cbeck/work/ROSA_archive/ROSA_archivemain.html'


erg = read_directory(inpath)

close,/all

direcs = erg.files(where(erg.types eq 1 and erg.files ne 'polarimeter_rfs' and erg.files ne 'movies'))+'/'
plaindir = direcs
direcs = inpath+direcs

ndir = n_elements(direcs)

openw,out_unit,outfile,/get_lun

printf,out_unit,'<!DOCTYPE doctype PUBLIC "-//w3c//dtd html 4.0 transitional//en">'
printf,out_unit,'<html>'
printf,out_unit,'<head>'
printf,out_unit,'  <meta content="text/html; charset=iso-8859-1"'
printf,out_unit,' http-equiv="Content-Type">'
printf,out_unit,'  <meta content="Mozilla/4.7 [en] (X11; I; SunOS 5.8 sun4u) [Netscape]"'
printf,out_unit,' name="GENERATOR">'
if (n_elements(vip)+n_elements(tip)) eq 0 then printf,out_unit,'  <title>ROSA Archive</title>' 


printf,out_unit,'</head>'
printf,out_unit,'<body bgcolor="#FF66FF">'
printf,out_unit,'<img src="NSO.gif" alt="" style="width: 980px; height: 138px;"><bnsp&;bnsp&;<br><br>'

printf,out_unit,'<img src="pink1.gif" alt="" style="width: 129px; height: 166px;"><bnsp&;bnsp&;'

printf,out_unit,"<br><big><big> How to use the ROSA archive</big></big>"

printf,out_unit,'<img src="pink.gif" alt="" style="width: 267px; height: 155px;"><bnsp&;bnsp&<br>;'

printf,out_unit,"<br><br> For each data set two files exist. <br><br><big> .txt</big> contains the header information, as far as it was available. The text in this file is included in the overview pages, if create_html.pro is started in the directory. <br><br><big> .gif</big> is a gif file of the data set. There may be multiple images for the different wavelengths.<br><br>"

printf,out_unit,"If you are interested in any data set, please first contact the PI of the respective campaign."
printf,out_unit,"With his approval, the NSO will provide the calibrated data in a suitable way.<br><br>"

;if n_elements(tip) ne 0 then printf,out_unit,'<br><br><big><big><span style="font-weight: bold;">NEW</span><span style="font-weight: bold;"> to the archive</span></big></big>: &nbsp; &nbsp;movies from some observations can be found <a href="movies/TIP_movies.html"><big><big><span style="font-weight: bold;">here</span></big></big></a>.'

printf,out_unit,"<br><br>&nbsp;&nbsp;&nbsp; <big><big> Example: </big></big><br><br>"



 printf,out_unit,' <span style="color: rgb(51, 0, 51);"></span><br style="color: rgb(51, 0, 51);"> <table cellpadding="2" cellspacing="2" border="1" style="text-align: left; width: 704px; height: 199px;"> <tbody> <tr> <td style="vertical-align: top;" colspan="2"><span style="color: rgb(51, 0, 51);"><span style="color: rgb(51, 0, 51);">File: 23JUN2006.010_vip2pol</span><br style="color: rgb(51, 0, 51);"> <span style="color: rgb(51, 0, 51);">Date: 2005/7/9</span><br style="color: rgb(51, 0, 51);"> <span style="color: rgb(51, 0, 51);">Time: 07:40:29 until 08:18:55</span><br style="color: rgb(51, 0, 51);"> <span style="color: rgb(51, 0, 51);"># steps,stepwidth: 200,0.300000</span><br style="color: rgb(51, 0, 51);"> <span style="color: rgb(51, 0, 51);">Scan area: 60.0000x47.2700</span><br style="color: rgb(51, 0, 51);"> <span style="color: rgb(51, 0, 51);">Mod speed,n_acum,tot.integ.time: 0.610000,12,9.83607</span><br style="color: rgb(51, 0, 51);"> <span style="color: rgb(51, 0, 51);">posx, posy, hel. angle: 0.00000,0.00000,0.00000</span><br style="color: rgb(51, 0, 51);"> <span style="color: rgb(51, 0, 51);">CA data: not found</span><br style="color: rgb(51, 0, 51);"> <span style="color: rgb(51, 0, 51);">Image correction: AO</span><br> </span><span style="color: rgb(51, 0, 51);"></span><span style="color: rgb(51, 0, 51);"><span style="color: rgb(51, 0, 51);"><span style="color: rgb(51, 0, 51);"><span style="color: rgb(51, 0, 51);"><span style="color: rgb(51, 0, 51);"><span style="color: rgb(51, 0, 51);"><span style="color: rgb(51, 0, 51);">Target: Sunspot and active region<br> Comments: Lunch was terrible again<br> </span></span></span></span></span></span></span></td> <td style="vertical-align: top;"><a href="example.ps"><img alt="" style="border: 2px solid ; width: 413px;'

 printf,out_unit,'height: 163px;" example.gif="" src="example.gif"></a></td> </tr> </tbody> </table> <span style="color: rgb(51, 0, 51);"></span><br>'


if ndir ne 0 then begin
        for k = 0,ndir-1 do begin
;             printf,out_unit,'<br><br>'
             printf,out_unit,'&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<big><big><big>'+strsplit(plaindir(k),'/',/extract)+'</big></big></big>'
             printf,out_unit,'<br><br>'
             if k gt 15 then  printf,out_unit,'<br>'
              

             erg = read_directory(direcs(k))

           

             ff = where(erg.types eq 1)
             


             if ff(0) ne -1 then subdirs = erg.files(ff)+'/'

             nsubdirs = n_elements(subdirs)

        if nsubdirs ne 0 then begin
            erg = string2num(subdirs)
            nday = fix(erg/10000)
            nmonth = fix(erg-nday*10000.)
            nmonth = fix(nmonth/100)

            xx = sort(nmonth)
            nmonth = nmonth(xx)
            nday = nday(xx)
            subdirs = subdirs(xx)

            xx = unique(nmonth)

            for kk = 0,n_elements(xx) -1 do begin
                ff = where(nmonth eq xx(kk))
                nnday = nday(ff)
                ssub = subdirs(ff)
                xx1 = sort(nnday)
                nday(ff) = nnday(xx1)
                subdirs(ff) = ssub(xx1)
              endfor
                                               
            for kk = 0,nsubdirs-1 do begin

                if kk eq 0 then begin
                    if fix(nmonth(kk)) ge 10 then mtext = num2string(fix(nmonth(kk))) else  mtext = '0'+num2string(fix(nmonth(kk)))
                    printf,out_unit,mtext+'&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;'
                endif

                if kk gt 0 then begin
                    if  nmonth(kk) ne monthold  then begin
                        if fix(nmonth(kk)) ge 10 then mtext = num2string(fix(nmonth(kk))) else  mtext = '0'+num2string(fix(nmonth(kk)))
                        printf,out_unit,'<br><br>'+mtext+'&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;'

                       

                    endif
                endif


                printf,out_unit,'&nbsp;<a href="'+plaindir(k)+subdirs(kk)+'Overview.'+strsplit(subdirs(kk),'/',/extract)+'.html">'+subdirs(kk)+'</a>&nbsp;'

               

                monthold = nmonth(kk)

;                printf,out_unit,
               
            endfor
            printf,out_unit,'<br><br>'
        endif
    endfor
endif

printf,out_unit,'<br> <big> <big> Links to other data bases: </big> </big><br><br>'
printf,out_unit,'&nbsp;<a href="http://solarwww.mtk.nao.ac.jp/katsukaw/itp2005/"> ITP campaign July 2005 </a>&nbsp; <br>'
printf,out_unit,'&nbsp;<a href="http://dot.astro.uu.nl/Home.html"> Dutch Open Telescope </a>&nbsp; <br>'
printf,out_unit,'&nbsp;<a href="http://sohowww.nascom.nasa.gov/data/synoptic/"> Synoptic data base NASA</a>&nbsp; <br>'

if n_elements(vip) ne 0 then begin
printf,out_unit,'&nbsp;<a href="http://www.kis.uni-freiburg.de/~cbeck/POLIS_archive/POLIS_archivemain.html"> POLIS Archive</a>&nbsp; <br>'
printf,out_unit,'&nbsp;<a href="http://www.kis.uni-freiburg.de/~cbeck/TIP_archive/TIP_archivemain.html"> TIP Archive</a>&nbsp; <br>'
endif

if (n_elements(vip)+n_elements(tip)) eq 0 then begin
printf,out_unit,'&nbsp;<a href="http://www.kis.uni-freiburg.de/~cbeck/VIP_archive/VIP_archivemain.html"> VIP Archive</a>&nbsp; <br>'
printf,out_unit,'&nbsp;<a href="http://www.kis.uni-freiburg.de/~cbeck/TIP_archive/TIP_archivemain.html"> TIP Archive</a>&nbsp; <br>'
endif

if n_elements(tip) ne 0 then begin
printf,out_unit,'&nbsp;<a href="http://www.kis.uni-freiburg.de/~cbeck/POLIS_archive/POLIS_archivemain.html"> POLIS Archive</a>&nbsp; <br>'
printf,out_unit,'&nbsp;<a href="http://www.kis.uni-freiburg.de/~cbeck/VIP_archive/VIP_archivemain.html"> VIP Archive</a>&nbsp; <br>'
endif

printf,out_unit,'</body>'
printf,out_unit,'</html>'

free_lun,out_unit




end
