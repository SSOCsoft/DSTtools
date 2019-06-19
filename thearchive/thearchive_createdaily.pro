pro thearchive_createdaily

smo = 1

if n_elements(inpath) eq 0 then inpath = '/export/cbeck/SMO_archive/'

erg = read_directory(inpath)

direcs = erg.files(where(erg.types eq 1))+'/'
plaindir = direcs
direcs = inpath+direcs
ndir = n_elements(direcs)

for k = 0,ndir-1 do begin    ; 0
   erg = read_directory(direcs(k))
   ff = where(erg.types eq 1)
   if ff(0) ne -1 then subdirs = erg.files(ff)+'/'
   nsubdirs = n_elements(subdirs)
   
   for kk = 0,nsubdirs-1 do begin
      erg = read_directory(direcs(k)+subdirs(kk))
      ff = where(erg.types eq 1)
      if ff(0) ne -1 then subsubdirs = erg.files(ff)+'/'
      nsubsubdirs = n_elements(subsubdirs)
      for kkk = 0,nsubsubdirs - 1 do  begin

         thearchive_create_html,filepath =  direcs(k)+subdirs(kk)+subsubdirs(kkk),smo = smo

      endfor
   endfor
endfor


end