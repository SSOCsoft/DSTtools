pro cal_<YYYYMMDD>_1083

; directory to input raw data
input_dir = '/home/solarstorm/gordonm/firs/data/level0/11jun2019_firs/'


; directory for output data
output_dir = '/home/solarstorm/gordonm/firs/data/level1/20190611_firs/'


; change location of save file with data information if you do not have write
; permission in input_dir

change_save =  output_dir

; check output text file for the numbers of flat, dc, cal, observations
;get_firs_dataprop,input_dir,change_save =change_save 
;stop

flat_f = 0 
dark_f = 5
cal_f = 14
obs_f = [2,3,6,7,9] 

 
pp = 1
if pp eq 1 then begin

yyrange = [0,500,520,1023]/2.

firs_1083_ff,change_save=change_save,input_dir=input_dir,output_dir=output_dir,flat_file = flat_f,dark_file = dark_f,/plt,/quit_column,sspeed = .5,int_limit = .1,bin = 2;,/nopause;,yyrange=yyrange

firs_cal,/plt,input_dir =input_dir, output_dir = output_dir,cal_file = cal_f,darkindex= 0,gainindex = 0,change_save =change_save ,theta_err = 1.,flat_file = flat_file,retard = 83.,/quit_column,theta_pol = 0.;,/nopause

;firs_cal,/plt,input_dir =input_dir, output_dir = output_dir,cal_file = 6,darkindex= 1,gainindex = 1,change_save =change_save ,theta_err = 1.,flat_file = flat_file,retard = 83.,/quit_column,theta_pol = 45.,/nopause

;stop

endif



pp = 1
if pp eq 1 then begin

tmat_save = '/home/solarstorm/gordonm/dst_pro/firs_soft2/Tmatrix_May2010_4708-14125.idl'
wavelength = 10830.

cont_wl = [100,150]
pos_lines = [256,337]

FOR i=0,N_ELEMENTS(obs_f)-1 DO BEGIN
	IF i EQ 0 THEN BEGIN
		firs_1565_obs,/plt,input_dir = input_dir, output_dir = output_dir,cal_file = cal_f,ccal_file = ccal_file,darkindex= 0,gainindex = 0,change_save =change_save,obsindex =  obs_f[i],tmat_save = tmat_save,wavelength = wavelength,/quit_column,offang = 0.,cont_wl = cont_wl,pos_lines = pos_lines,/nopause ,/check_lines
	ENDIF ELSE BEGIN
		firs_1565_obs,/plt,input_dir = input_dir, output_dir = output_dir,cal_file = cal_f,ccal_file = ccal_file,darkindex= 0,gainindex = 0,change_save =change_save,obsindex =  obs_f[i],tmat_save = tmat_save,wavelength = wavelength,/quit_column,offang = 0.,cont_wl = cont_wl,pos_lines = pos_lines,/nopause
	ENDELSE
		
ENDFOR
;firs_1565_obs,/plt,input_dir = input_dir, output_dir = output_dir,cal_file = cal_file,ccal_file = ccal_file,darkindex= 1,gainindex = 1,change_save =change_save,obsindex =  7,tmat_save = tmat_save,wavelength = wavelength,/quit_column,offang = 0.,cont_wl = cont_wl,pos_lines = pos_lines,/nopause ,/no_align

;firs_1565_obs,/plt,input_dir = input_dir, output_dir = output_dir,cal_file = cal_file,ccal_file = ccal_file,darkindex= 1,gainindex = 1,change_save =change_save,obsindex =  8,tmat_save = tmat_save,wavelength = wavelength,/quit_column,offang = 0.,cont_wl = cont_wl,pos_lines = pos_lines,/nopause ,/no_align

;firs_1565_obs,/plt,input_dir = input_dir, output_dir = output_dir,cal_file = cal_file,ccal_file = ccal_file,darkindex= 1,gainindex = 1,change_save =change_save,obsindex =  9,tmat_save = tmat_save,wavelength = wavelength,/quit_column,offang = 0.,cont_wl = cont_wl,pos_lines = pos_lines,/nopause ,/no_align

endif
;;fix and run dst_pro/FIRS_cleanup/fringe_corr_firs_100617.pro
;;fix and run dst_pro/FIRS_cleanup/jenkins_firs.pro

stop

inpath = output_dir
outpath = '/export/raid2/cbeck/work/FIRS_archive/2017/301017/'

;

iinput_dir = input_dir

generate_firs_archive_files,inpath = inpath, outpath = outpath,twice = 3.,wavelen = 1083.,pollimit = .015,iinput_dir = iinput_dir,/check_lines

inpath = outpath
firs_create_html,filepath = inpath

outfile = '/export/raid2/cbeck/work/FIRS_archive/FIRS_archivemain.html'
inpath = '/export/raid2/cbeck/work/FIRS_archive/'
firs_create_mainhtml,outfile = outfile,inpath = inpath


stop


end
