pro cal_spinor_YYYYMMDD_854

date ='DDMMYY'

  input_dir = '/home/solardata/2019/01/25/level0/25jan2019_spinor_sarnoff_8542/'
  output_dir =  '/home/solardata/2019/01/25/level1/spinor/'
  tmat_save = '/home/solarstorm/gordonm/dst_pro/spinor_soft/Tmatrix_May2010_4708-14125.idl'

  binning = 1.5
  wavelength = 8542. ; 8542. ;5876. ; 6563.

  lf = 0	;0 says use the first lamp flat found in `inputdir',
  sf = 2	;1 says use the second, 2 use the third,... and so on.
  cal = 0
  obs = 0

  up_lim = 100000.
  yyrange = [0,450,573,1023];[26,466,565,1005]
  
  pp = 1
  if pp eq 1 then begin

; use lamp flat as initial correction
   spinor_lamp_ff,input_dir=input_dir,output_dir=output_dir,lamp_flat_file = lf,/plt

endif

  restore,output_dir+'lamp_gain.'+strcompress(lf,/REMOVE_ALL)+'.sav'
  
  pp = 1
  if pp eq 1 then begin

     ;addshift = [0,1]

     ;yyrange = [15,450,560,1000]

     spinor_ff,input_dir=input_dir,output_dir=output_dir,/plt,flat_file = sf,/full_beam,sspeed = 1.,binning = binning,addshift =addshift,lamp_gain=lamp_gain,up_lim=up_lim,yyrange=yyrange

  endif

  pp = 1
  if pp eq 1 then begin     

     spinor_cal,cal_file = cal,retard = 88.,input_dir = input_dir,output_dir = output_dir,darkindex = 0,gainindex = 0,/plt,tmat_save = tmat_save,wavelength = wavelength,n_separations=10;,/nopause

  endif

pp = 1
if pp eq 1 then begin

   pos_lines =  [218.,218.] 
   cont_wl = [120,150]

   ;binning = 1.5

;spinor_obs,/plt,gainindex = 0,darkindex = 0,angle = 0.,obsindex = 0,input_dir = input_dir,output_dir = output_dir,calindex = 0,wavelength = wavelength,tmat_save = tmat_save,/nopause,pos_lines = pos_lines,hair_up = hair_up, hair_down = hair_down,cont_wl = cont_wl,binning = binning

;spinor_obs,/plt,gainindex = 0,darkindex = 0,angle = 0.,obsindex = 1,input_dir = input_dir,output_dir = output_dir,calindex = 0,wavelength = wavelength,tmat_save = tmat_save,/nopause,pos_lines = pos_lines,hair_up = hair_up, hair_down = hair_down,cont_wl = cont_wl,binning = binning,/no_align

   spinor_obs,/plt,gainindex = 0,darkindex = 0,angle = 0.,obsindex = obs,input_dir = input_dir,output_dir = output_dir,calindex = 0,wavelength = wavelength,tmat_save = tmat_save,/nopause,pos_lines = pos_lines,binning=binning,cont_wl=cont_wl,beta=beta,lamp_gain=lamp_gain ;,hair_up = hair_up, hair_down = hair_down,cont_wl = cont_wl


; spinor_corr_fringes,'171110.081210.0.ccc02.c-hrt.map.0001.fits.reduced.dat',input_dir=input_dir,output_dir=output_dir,ppos=ppos,change_save=output_dir,/plt


endif

pp = 0 
if pp eq 1 then begin
sscale = 0.3
iinput_dir = input_dir


inpath = output_dir
outpath = output_dir+'html/'   ;'/home/cbeck/work/SPINOR_archive/2015/'+date+'/'

generate_spinor_archive_files,inpath = inpath, outpath = outpath,twice = 4,wavelen = 854.,pollimit = .01,/check_lines,sscale = sscale,iinput_dir =iinput_dir

;inpath = outpath
;spinor_create_html,filepath = inpath
;spinor_create_mainhtml,outfile = '/home/cbeck/work/SPINOR_archive/SPINOR_archivemain.html',inpath =  '/home/cbeck/work/SPINOR_archive/'

endif


stop






end
