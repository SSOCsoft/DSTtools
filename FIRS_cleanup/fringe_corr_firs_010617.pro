pro fringe_corr_firs_010617

output_dir = '/net/koa/export/data/cbeck/obs2017/obs_may2017/FIRS_010617_reduced_fringecorr/'
input_dir ='/net/koa/export/data/cbeck/obs2017/obs_may2017/FIRS_010617_reduced/'

erg = read_directory(input_dir,filter ='*.dat')
files = erg.files

; if these are not specified, the routine will ask for them. Click on
; Si 1082.7 in the spectrum, click on He 1083 in the spectrum, set
; continuum window to a region w/o line to the blue of Si 1082.7

cont_wl = [150,210] ; continuum window for I_c map

pos_lines = [260,350] ; Si 1082.7 , He I 1083 location in pixels

; Frequencies to be filtered out
; x dimension: spectral axis
; y dimension: spatial axis

; set x to cover the fringe periods

; choose y-range to set the spatial scales along the slit to be considered:
; y0,y1 = 0,0 -> only patterns that are >constant< along the whole
; slit are removed
; y0,y1 = 0,1 -> patterns with half the slit length are removed
; y0,y1 = 0,2 -> patterns with 1/3 of the slit length are removed
; Be careful: polarization signal can extend over a large range along
; the slit, especially in sunspots
; Recommended: stay with y0,y1 = 0,0 (or 0,1 at max.)
; Check if the fringe filter changes the polarization signal
; visibly. If yes, reduce the range in y.

pposq = [20,150,0,0]    ; x0, x1, y0, y1
pposu = [20,150,0,0]
pposv = [20,150,0,0]

; Best usage for routine:
; Run it once without giving the values above (pposq, pposu, pposv). 
; Interactively select the periods and y-range, check what happens
; with the spectra when applied. Values in QUV can be different, but
; usually the fringes have the same period.
; Routine will ask for qhat to filter in QUV (in that order).
; Click in the window that says: "Please mark frequencies..."
; That window shows the 2D Fourier power of the spectra. The FFT power
; has four identical quadrants, stay in the lower left one (left edge
; to middle, bottom to middle).
; You define a rectangle with two clicks (lower left corner, upper
; right corner). To make sure that you can also do y0,y1  = 0,0, you
; can also click below the Fourier power image. 
; If the rectangle is defined, the filter is applied. Check the other
; window, it shows on the left the original and on the right the
; corrected slit spectrum.
; The routine will ask if position is fine on the terminal. If
; confirmed, you can add a second rectangle (up to three in total) or
; go to the next Stokes parameter. When happy with the result, put the
; corresponding numbers into the pposq, ... above, uncommented them,
; then the routine will apply the filter to all data files in the
; folder without asking if you re-run the procedure.
; While it runs, the routine will show you IQUV before and after the correction.

pp = 1

if pp eq 1 then begin

for k = 0,n_elements(files)-1 do begin & infile = files(k) &  spinor_corr_fringes_new,infile,input_dir = input_dir,output_dir = output_dir,pposi = pposi,pposq = pposq,pposu = pposu,pposv = pposv,pos_solar = pos_solar,cont_wl =cont_wl,pos_lines = pos_lines,noiquv = [0,1,1,1],/plt & endfor

endif

stop


end
