;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GO INTO THE DATA DIRECTORY THAT CONTAINS THE SCIENCE IMAGES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


.r Andor_Zyla_chronological_file_order.pro


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DARKS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

files = FILE_SEARCH('../Darks/*spool.dat')
new_files = Andor_Zyla_chronological_file_order(files)

zsize = DBL(N_ELEMENTS(new_files))

image = FLTARR(2048,2048)
ave_dark = FLTARR(2048,2048)
ave_dark[*] = 0.
dark_trend = FLTARR(zsize)
dark_trend[*] = 0.

FOR i = 0,(zsize-1) DO BEGIN &$
    image = FLOAT(READ_BINARY(new_files[i],DATA_DIMS=[2060,2050],DATA_TYPE=12)) &$
    image = image[0:2047,2:*] &$
    ave_dark =  ave_dark + (image/zsize) &$
    dark_trend[i] = AVERAGE(image) &$
    IF (i gt 1) AND (i MOD 100 eq 0) THEN plot,FINDGEN(zsize),dark_trend,yst=1,xtitle='Frame Number',ytitle='Dark Average',charsize=2,xst=1,yr=[MIN(dark_trend[1:i]),MAX(dark_trend[1:i])] &$
    IF (i gt 1) AND (i MOD 100 eq 0) THEN wait,0.1 &$
ENDFOR

tvim,ave_dark,/sc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; FLATS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

files = FILE_SEARCH('../Flats_early/*spool.dat')
new_files = Andor_Zyla_chronological_file_order(files)

zsize = DBL(N_ELEMENTS(new_files))

image = FLTARR(2048,2048)
ave_flat = FLTARR(2048,2048)
ave_flat[*] = 0.
flat_trend = FLTARR(zsize)

FOR i = 0,(zsize-1) DO BEGIN &$
    image = FLOAT(READ_BINARY(new_files[i],DATA_DIMS=[2060,2050],DATA_TYPE=12)) &$
    image = image[0:2047,2:*] &$
    ave_flat =  ave_flat + (image/zsize) &$
    flat_trend[i] = AVERAGE(image) &$    
    IF (i gt 1) AND (i MOD 100 eq 0) THEN plot,FINDGEN(zsize),flat_trend,yst=1,xtitle='Frame Number',ytitle='Flat Average',charsize=2,xst=1,yr=[MIN(flat_trend[1:i]),MAX(flat_trend[1:i])] &$
    IF (i gt 1) AND (i MOD 100 eq 0) THEN wait,0.1 &$
ENDFOR

ave_flat = ave_flat - ave_dark
ave_flat = ave_flat / MEDIAN(ave_flat)
ave_flat[WHERE(ave_flat le 0.1)] = 9999.

tvim,ave_flat,/sc,range=[0.5,1.5]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NOISE FILE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

files = FILE_SEARCH('../Flats_early/*spool.dat')
new_files = Andor_Zyla_chronological_file_order(files)

burst_number = 30.
save_directory = '/data/rosa3/oldrosa1/Speckle/Data/Raw/27Jul2015/Halpha/'

image = FLTARR(2048,2048)
noise = FLTARR(2048,2048,burst_number)
noise[*] = 0.

FOR i = 0,(burst_number-1) DO BEGIN &$
    image = FLOAT(READ_BINARY(new_files[i+1000],DATA_DIMS=[2060,2050],DATA_TYPE=12)) &$
    image = image[0:2047,2:*] &$
    image = (image - ave_dark)>0. &$
    image = image / ave_flat &$
    noise[*,*,i] = image &$
ENDFOR        

OPENW,out_lun,/GET_LUN,save_directory+'kisip.Halpha.noise128x128'
WRITEU,out_lun,noise
CLOSE,out_lun & FREE_LUN,out_lun 
OPENW,out_lun,/GET_LUN,save_directory+'kisip.Halpha.noise64x64'
WRITEU,out_lun,noise
CLOSE,out_lun & FREE_LUN,out_lun 
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CALIBRATION FILES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


save_directory = '/data/solarstore1/rosa/Reconstructed/27Jul2015/limb/Halpha/calibrations/'


;;;;;;;;;
;TARGETS
;;;;;;;;;
files = FILE_SEARCH('../Targets_random_guider/*spool.dat') 
new_files = Andor_Zyla_chronological_file_order(files)
zsize = DBL(N_ELEMENTS(new_files))
image = FLTARR(2048,2048)
ave_target = FLTARR(2048,2048)
ave_target[*] = 0.
FOR i = 0,(zsize-1) DO BEGIN &$
    image = FLOAT(READ_BINARY(new_files[i],DATA_DIMS=[2060,2050],DATA_TYPE=12)) &$
    image = (REFORM(image[0:2047,2:*]) - ave_dark) / ave_flat &$
    ave_target =  ave_target + (image/zsize) &$
    IF (i MOD 100 eq 0) THEN tvim, ave_target, /sc &$
    IF (i MOD 100 eq 0) THEN wait,0.1 &$
ENDFOR
WRITEFITS,save_directory+'average_target.fits',ave_target


;;;;;;;;;
;GRIDS
;;;;;;;;;
files = FILE_SEARCH('../Grids_random_guider/*spool.dat') 
new_files = Andor_Zyla_chronological_file_order(files)
zsize = DBL(N_ELEMENTS(new_files))
image = FLTARR(2048,2048)
ave_grid = FLTARR(2048,2048)
ave_grid[*] = 0.
FOR i = 0,(zsize-1) DO BEGIN &$
    image = FLOAT(READ_BINARY(new_files[i],DATA_DIMS=[2060,2050],DATA_TYPE=12)) &$
    image = (REFORM(image[0:2047,2:*]) - ave_dark) / ave_flat &$
    ave_grid =  ave_grid + (image/zsize) &$
    IF (i MOD 100 eq 0) THEN tvim, ave_grid, /sc &$
    IF (i MOD 100 eq 0) THEN wait,0.1 &$
ENDFOR
WRITEFITS,save_directory+'average_grid.fits',ave_grid


;;;;;;;;;
;DOTS
;;;;;;;;;
files = FILE_SEARCH('../Dots_random_guider/*spool.dat') 
new_files = Andor_Zyla_chronological_file_order(files)
zsize = DBL(N_ELEMENTS(new_files))
image = FLTARR(2048,2048)
ave_dots = FLTARR(2048,2048)
ave_dots[*] = 0.
FOR i = 0,(zsize-1) DO BEGIN &$
    image = FLOAT(READ_BINARY(new_files[i],DATA_DIMS=[2060,2050],DATA_TYPE=12)) &$
    image = (REFORM(image[0:2047,2:*]) - ave_dark) / ave_flat &$
    ave_dots =  ave_dots + (image/zsize) &$
    IF (i MOD 100 eq 0) THEN tvim, ave_dots, /sc &$
    IF (i MOD 100 eq 0) THEN wait,0.1 &$
ENDFOR
WRITEFITS,save_directory+'average_dots.fits',ave_dots




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DATA BURST
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NOTE THAT THIS WILL TAKE A WHILE!!!!!!!!
files = FILE_SEARCH('*spool.dat') 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

new_files = Andor_Zyla_chronological_file_order(files)

zsize = DBL(N_ELEMENTS(new_files))

save_directory = '/data/rosa3/oldrosa1/Speckle/Data/Raw/27Jul2015/Halpha/'

burst_number = 30.   
factor = FIX(zsize / burst_number) 
image = FLTARR(2048,2048)
datacube = FLTARR(2048,2048,burst_number)

temp = FLTARR(2048,2048,2)

; READY TO START NOW!
batch = 0
counter = 0
FOR i = 0,(factor-1) DO BEGIN &$
    FOR j = 0,(burst_number-1) DO BEGIN &$
        image = FLOAT(READ_BINARY(new_files[(i*burst_number)+j],DATA_DIMS=[2060,2050],DATA_TYPE=12)) &$
        image = image[0:2047,2:*] &$
        image = (image - ave_dark)>0. &$
        image = FLOAT(image) / FLOAT(ave_flat) &$
        datacube[*,*,j] = image &$
    ENDFOR &$
;    temp[*,*,0] = datacube[*,*,0] &$
;    FOR k = 1,(burst_number-1) DO BEGIN &$
;	temp[*,*,1] = datacube[*,*,k] &$
;	FOR z = 0,4 DO ccshifts = TR_GET_DISP(temp,/shift) &$
;	datacube[*,*,k] = temp[*,*,1] &$
;    ENDFOR &$
    IF (batch le 9) THEN batchname = '0' + arr2str(batch,/trim) &$
    IF (batch gt 9) AND (batch le 99) THEN batchname = arr2str(batch,/trim) &$
    IF (counter le 9) THEN name = '0000' + arr2str(counter,/trim) &$
    IF (counter gt 9) AND (counter le 99) THEN name = '000' + arr2str(counter,/trim) &$
    IF (counter gt 99) AND (counter le 999) THEN name = '00' + arr2str(counter,/trim) &$
    IF (counter gt 999) AND (counter le 9999) THEN name = '0' + arr2str(counter,/trim) &$
    IF (counter gt 9999) AND (counter le 99999) THEN name = '' + arr2str(counter,/trim) &$
    OPENW,out_lun,/GET_LUN,save_directory+'kisip.raw.batch' + batchname + '.' + STRING(counter,FORMAT='(I3.3)') &$
    WRITEU,out_lun,datacube &$
    CLOSE,out_lun & FREE_LUN,out_lun &$   
    PRINT,'Processed batch number '+ARR2STR(((batch*1000)+(counter+1)),/trim)+' of '+ARR2STR(factor,/trim) &$
    counter = counter + 1 &$
    IF counter eq 1000 THEN batch = batch + 1 &$
    IF counter eq 1000 THEN counter = 0 &$
    tvim,datacube[*,*,0],/sc,/noaxis,range=[1000,10000] & wait,0.1 &$
ENDFOR





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CALLING SPECKLE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; START KISIP GUI
; GOTO /home/dbj/IDL/KISIP
; TYPE ./kisip_gui
; FILE: OPTIONS:
;       SELECTED FILENAME: /data/rosa3/oldrosa1/Speckle/Data/Raw/13Jul2011/Halpha/kisip.raw.batch00
;       (note: basically just leave off the final numbering of the filename)
;       START: 000
;       END: 499
;       SELECTED FILENAME: /data/rosa3/oldrosa1/Speckle/Data/Recontructed/13Jul2011/Halpha/Halpha_kisip_batch00
;       (note: basically the save directory minus the final numbering of the filename)
; DATA: PROPERTIES:
;       XSIZE: 2048
;       YSIZE: 2048
;       ARCSEC/PX IN X: 0.109
;       ARCSEC/PX IN Y: 0.109
;       TELESCOPE DIAMETER: 760 (in mm)
;       WAVELENGTH: 656 (in nm)
;       ADAPTIVE OPTICS USED: yes and tick box
;       AO LOCK STRUCTURE: auto (unless poor speckle then manually type in lock point in pixels)
; CLICK ON TRIPLE CORRELATION TAB
;       SUBFIELD SIZE: 12.0
;       PHASE REC: 100
;       U IN X: 10
;       U, V & U+V: 10
;       MAXIMUM ITERATIONS: 30
;       AUTOSET THRESHOLD: 80
;       WEIGHTING EXPONENT: 1.3
;       PHASE APODISATION: 15
;       TICK NOISE-FILTERING BOXES
; CLICK ON WRITE
; CLICK ON QUIT
;
;;;OLD;;; OPEN hostfile
;;;OLD;;;     LIST NODES AND CORES USED (eg r22:8)
;;;OLD;;; 
;;;OLD;;; SUBMIT PARALLEL JOB USING:
;;;OLD;;; nohup mpirun -machinefile /home/dbj/IDL/KISIP/hostfile -n 8 /home/dbj/IDL/KISIP/entry < /dev/null > log.txt &
;;;OLD;;; NOTE: the "8" above is the TOTAL number of cores listed in hostfile
;
;;;OLD;;;     SSH INTO wasp
;;;OLD;;;     GOTO /home/dbj/IDL/KISIP
;
;;;OLD;;;     START THE JOB USING:
;;;OLD;;;     qsub sg3_kisip.run
;;;OLD;;;
;;;OLD;;;     CHECK THE JOB STATUS BY TYPING:
;;;OLD;;;     qstat -l
;
;
; SSH INTO starbase
; GOTO /home/dbj/IDL/KISIP_SG3
;
; AFTER RUNNING THE ./kisip_gui PROGRAM:
; START THE JOB USING:
; salloc -p sg3 -n 48 -J speckle_CaK_dbj ./slurm_kisip_sg3.tcsh &
; OR FOR SG2:
; salloc -p sg2 -n 88 -J speckle_CaK_dbj ./slurm_kisip_sg2.tcsh &
; OR FOR SG4:
; salloc -p sg4 -n 48 -J speckle_Hbeta_dbj ./slurm_kisip_sg4.tcsh &
; 
; TO VIEW THE JOBS LIST TYPE:
; squeue
;
; TO SEE AN INTERACTIVE VIEW TYPE:
; sview


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CONVERT KISIP FILES BACK INTO FITS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FOLLOW INSTRUCTIONS IN KISIP_to_FITS_converter.bat


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ALIGN IMAGES (works on both IBIS & ROSA data)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; FOLLOW INSTRUCTIONS IN align_IBIS_frames.bat


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DESTRETCHING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; YOU MUST INITIALIZE THE ROSA PROGRAMMES!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@ROSA_pipeline_init.bat

; RUN THIS FROM THE DIRECTORY WHERE THE aligned IMAGES ARE STORED!!!!!
files = FILE_SEARCH('aligned_*')
temp = READFITS(files[0],/silent)
temp2 = READFITS(files[1],/silent)
xsize = N_ELEMENTS(temp[*,0])
ysize = N_ELEMENTS(temp[0,*])
zsize = N_ELEMENTS(files)
time_ave_image = temp
time_ave_image[*] = 0.
FOR i = 0,(zsize-1) DO time_ave_image = time_ave_image + (READFITS(files[i],/silent)/FLOAT(zsize))
kernels = [64, 32, 10]
test_reg = reg_loop(temp2, temp, kernels, disp=wl_disp, rdisp=wl_rdisp)
disp_mask = BYTARR(N_ELEMENTS(wl_disp[0,*,0]), N_ELEMENTS(wl_disp[0,0,*]))
mask_spacing_x = FIX(DBL(xsize) / kernels[N_ELEMENTS(kernels)-1])
mask_spacing_y = FIX(DBL(ysize) / kernels[N_ELEMENTS(kernels)-1])
disp_mask[*] = 0
lower_threshold_mask = 8 ; given as a percentage of width (GOOD FOR 2048x2048 sCMOS IMAGES)
lower_mask_x = RND((lower_threshold_mask/100.) * mask_spacing_x)
lower_mask_y = RND((lower_threshold_mask/100.) * mask_spacing_y)
disp_mask[(lower_mask_x-6):(mask_spacing_x-lower_mask_x+5),(lower_mask_y-6):(mask_spacing_y-lower_mask_y-28)] = 1 ; GOOD FOR 1004x1002 LIMB IMAGES
; USE THIS TO CHECK THE disp_mask
; NOTE YOU MAY HAVE TO USE THE make_zero COMMAND TO ADJUST THE LOCATIONS OF THE MASK, PARTICULARLY FOR LIMB OBSERVATIONS!
temp2 = CONGRID(time_ave_image, N_ELEMENTS(disp_mask[*,0]), N_ELEMENTS(disp_mask[0,*]), /cubic)
contour,disp_mask
tvim,temp2,/noaxis
contour,disp_mask,thick=3,/over
; SAVE THE MASK
save,filename='../processed/disp_mask.sav',disp_mask,kernels
; NOW DO THE DESTRETCHING!
vectors = ROSA_destretch_noRAM5(files, kernels=kernels, disp_mask=disp_mask, destr_vect_raw=destr_vect_raw, /no_coalign)
save,FILENAME='../processed/destretch_vectors_Halpha.sav',vectors,destr_vect_raw


; REMOVE ANY RESIDUAL DRIFTS
files = FILE_SEARCH('destretched*')
elements = N_ELEMENTS(files)
image = READFITS(files[0],/silent)
xsize = N_ELEMENTS(image[*,0])
ysize = N_ELEMENTS(image[0,*])
; PICK THE LOCATION IN THE IMAGES WHERE A HIGH-CONTRAST SOURCE IS PRESENT:
; NOTE THESE VALUES FIRST REQUIRE IMAGE ROTATION SO TAKE THAT INTO ACCOUNT!!!!!!
x1 = 270
x2 = 1780
y1 = 1100
y2 = 1520
tvim,image,range=[0,12000] & horline,y1 & horline,y2 & verline,x1 & verline,x2

temp = FLTARR(x2-x1+1,y2-y1+1,2)
temp[*,*,0] = image[x1:x2,y1:y2]
ccshifts = FLTARR(2,2)
xshifts = FLTARR(N_ELEMENTS(files)-1)
yshifts = FLTARR(N_ELEMENTS(files)-1)
correlations = FLTARR(N_ELEMENTS(files)-1)
xshifts[*] = 0.
yshifts[*] = 0.
correlations[*] = 0.
mult,1,3
WRITEFITS,'../processed/'+files[0],image
FOR i = 1,(elements-1) DO BEGIN &$
    image = READFITS(files[i],/silent)>0. &$
    temp[*,*,1] = image[x1:x2,y1:y2] &$
    ; PLAY AROUND WITH THE reduction KEYWORD AS THAT CAN SPEED THINGS UP CONSIDERABLY
    corrmat = CORREL_IMAGES(REFORM(temp[*,*,0]), REFORM(temp[*,*,1]), xshift=20, yshift=20, reduction=1) &$
    corrmat_analyze, corrmat, xoffset_optimum, yoffset_optimum, max_corr, edge, plateau, reduction=1 &$
    image = SHIFT(image, xoffset_optimum, yoffset_optimum) &$
    xshifts[i-1] = xoffset_optimum &$
    yshifts[i-1] = yoffset_optimum &$
    correlations[i-1] = max_corr &$
    ;PUT THE NEXT LINE IN IF YOU WANT SEMI-CUMULATIVE CO-ALIGNMENT
    IF i MOD 50 EQ 0 THEN temp[*,*,0] = image[x1:x2,y1:y2] &$
    ;IF i MOD 50 EQ 0 THEN temp[*,*,0] = image &$
    WRITEFITS,'../processed/'+files[i],image &$
    IF (i MOD 100) eq 0 THEN PRINT,'Processing image number ',i,' of ',(N_ELEMENTS(files)) &$
    IF (i MOD 10) eq 0 THEN plot,xshifts,thick=2,xtitle='Frame',ytitle='x Pixel shift',xst=1,yst=1,charsize=3,yr=[MIN(xshifts[0:i-1])-1, MAX(xshifts[0:i-1])+1] &$
    IF (i MOD 10) eq 0 THEN plot,yshifts,thick=2,xtitle='Frame',ytitle='y Pixel shift',xst=1,yst=1,charsize=3,yr=[MIN(yshifts[0:i-1])-1, MAX(yshifts[0:i-1])+1] &$
    IF (i MOD 10) eq 0 THEN plot,correlations,thick=2,xtitle='Frame',ytitle='Image Correlation',xst=1,yst=1,charsize=3,yr=[MIN(correlations[0:i-1])-0.05, MAX(correlations[0:i-1])+0.05] &$
    IF (i MOD 10) eq 0 THEN wait,0.1 &$
ENDFOR
mult,1,1










