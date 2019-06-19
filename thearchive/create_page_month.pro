pro create_page_month,ddirecs,ssubdirs,ssubsubdirs,back_link = back_link

outfile = ddirecs+ssubdirs+strmid(ssubdirs,0,2)+'.html'
yyear = strmid(ddirecs,strlen(ddirecs)-5,4)

openw,out_unit,outfile,/get_lun

; print out html header declaration
printf,out_unit,'<!DOCTYPE doctype PUBLIC "-//w3c//dtd html 4.0 transitional//en">'
printf,out_unit,'<html>'
printf,out_unit,'<head>'
printf,out_unit,'  <meta content="text/html; charset=iso-8859-1"'
printf,out_unit,' http-equiv="Content-Type">'
printf,out_unit,'  <meta content="Mozilla/4.7 [en] (X11; I; SunOS 5.8 sun4u) [Netscape]"'
printf,out_unit,' name="GENERATOR">'
printf,out_unit,'  <title>'+strmid(ssubdirs,0,2)+'/'+yyear+'</title>'
printf,out_unit,'</head>'
if n_elements(back_link) eq 0 then printf,out_unit,'<a href="../../THE_archivemain.html"> <big>Back to main page </big></a><br><br>' else printf,out_unit,'<a href="../../SMO_archivemain.html"> <big>Back to main page </big></a><br><br>'

printf,out_unit,'<br>'
printf,out_unit,'<big>'+strmid(ssubdirs,0,2)+'/'+yyear+'</big><br>'

; loop over files
for k = 0,n_elements(ssubsubdirs)-1 do begin
   printf,out_unit,'<br>'  
   printf,out_unit,'&nbsp;<a href="'+ssubsubdirs(k)+'Overview.'+strsplit(ssubsubdirs(k),'/',/extract)+'.html">'+ssubsubdirs(k)+'</a>&nbsp;'

endfor


printf,out_unit,'</body>'
printf,out_unit,'</html>'

free_lun,out_unit




end

