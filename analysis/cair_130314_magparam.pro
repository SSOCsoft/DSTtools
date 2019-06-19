pro cair_130314_magparam

ftsread,data,8480,8770,xlam = xlam
data = swap_endian(data)/10000.
xlam = xlam / 10.


ll_cair = 852.915+findgen(511)*5.85/1000.

inpath = '/data/cbeck/obs2014/fringe_filtered_march_2014/130314_fringe_filt_854/'

;data/cbeck/obs2013/fringe_filtered_8542_spinor_080313/'

erg = read_directory(inpath,filter = '*fringe_filtered.dat')
files = erg.files
;files = [files(0:11),files(14:17),files(19)]



outpath = '/data/cbeck/obs2014/130314/'   ; lineparam_spinor_cair/

;  ll_cair = ll_cair(124:303)

 ; blends at 11, 45 [79, 96 telluric]

for ww = 0,n_elements(files)-1 do begin

   restore,inpath + files(ww)+'.sav'
   outfile_1 = outpath + 'mag_lineparam_'+files(ww)+'.sav'
 
   tt = size(ic)

   full_spec = fltarr(tt(1),dx_final+1,dy_final+1,4)
   a = fltarr(dx_final+1,dy_final+1,4)

   openr,1,inpath+files(ww)


for k = 0,tt(1)-1 do begin & readu,1,a &  full_spec(k,*,*,*) = a & endfor
 
for k = 0,tt(1)-1 do begin &  ii = reform(full_spec(k,*,*,0))&  qq = reform(full_spec(k,*,*,1))& uu = reform(full_spec(k,*,*,2))&  vv = reform(full_spec(k,*,*,3)) &  deskew1,ii,qq,uu,vv,473-5,473+5,0,tt(3)-1,0,tt(3)-1,2,473,/straight &    full_spec(k,*,*,0) = ii &full_spec(k,*,*,1) = qq &full_spec(k,*,*,2) = uu &full_spec(k,*,*,3) = vv & endfor
   
   tt = size(full_spec)
 
   
   fts_splined = spline(xlam,data,ll_cair,/double)

   ic = reform(total(full_spec(*,1:10,*,0),2)/10.)

   i_norm = total(ic(*,75:115),2)/41.
   i_norm1 = total(ic(*,330:370),2)/41.

   ii_norm = ic -ic 

for k = 0,tt(1)-1 do begin & ii_norm(k,*) = i_norm(k)+findgen(tt(3))/(tt(3)-1.)*(i_norm1(k)-i_norm(k)) & endfor

   ii_norm = ii_norm / mean(ii_norm)

   nnorm = 2.15*10^5.


for k = 0,tt(1)-1 do begin & for kk = 0,tt(3)-1 do begin & full_spec(k,*,kk,0) = reform(full_spec(k,*,kk,0)) / ii_norm(k,kk) / nnorm  & full_spec(k,*,kk,1) = reform(full_spec(k,*,kk,1)) / ii_norm(k,kk) /nnorm & full_spec(k,*,kk,2) = reform(full_spec(k,*,kk,2)) / ii_norm(k,kk) / nnorm & full_spec(k,*,kk,3) = reform(full_spec(k,*,kk,3)) / ii_norm(k,kk) / nnorm & endfor & endfor
   
avprof = (total(total(full_spec(*,*,75:115,0),1),2)/float(tt(1))/41. + total(total(full_spec(*,*,330:370,0),1),2)/float(tt(1))/41.)*.5


   window,0
   laodct,41
   device,decomposed = 0

   plot,avprof
   oplot,fts_splined,color = 120

; polarization parameters
q_max = fltarr(tt(1),tt(3))       ; maximal Stokes Q signal
u_max = fltarr(tt(1),tt(3))       ; maximal Stokes U signal
v_max = fltarr(tt(1),tt(3))       ; maximal Stokes V signal
q_tot = fltarr(tt(1),tt(3))       ; total Stokes Q signal
u_tot = fltarr(tt(1),tt(3))       ; total Stokes U signal
v_tot = fltarr(tt(1),tt(3))       ; total Stokes V signal
poldeg= fltarr(tt(1),tt(3))       ; polarization degree
rms_poldeg= fltarr(tt(1),tt(3))   ; rms noise in polarization
rms_q = fltarr(tt(1),tt(3))       ; rms noise in Stokes Q
rms_u = fltarr(tt(1),tt(3))       ; rms noise in Stokes U
rms_v = fltarr(tt(1),tt(3))       ; rms noise in Stokes V
ncp       = fltarr(tt(1),tt(3))   ; net circular polarization
n_vlobes  = fltarr(tt(1),tt(3))   ; number of lobes in V
polarity  = fltarr(tt(1),tt(3))   ; polarity of the V signal
loverv    = fltarr(tt(1),tt(3))   ; ratio of linear and circular polarization
ampl_blue = fltarr(tt(1),tt(3))   ; amplitude of blue Stokes V lobe
ampl_red  = fltarr(tt(1),tt(3))   ; amplitude of red Stokes V lobe
v_zero    = fltarr(tt(1),tt(3))   ; zero-crossing position
pos_lobes = fltarr(tt(1),tt(3),2) ; position of the Stokes V lobes
relareaasym  = fltarr(tt(1),tt(3))   ; net circular polarization
l_phot = fltarr(tt(1),tt(3))   ; 

b_weakfield = fltarr(tt(1),tt(3)) ; magnetic flux derived from the weak-field approximation
semel_pos = fltarr(tt(1),tt(3))   ; magnetic flux derived from the Semel-method (center of gravity in I+V and I-V)


; polarization parameters
q_max_chrom = fltarr(tt(1),tt(3))       ; maximal Stokes Q signal
u_max_chrom = fltarr(tt(1),tt(3))       ; maximal Stokes U signal
v_max_chrom = fltarr(tt(1),tt(3))       ; maximal Stokes V signal
q_tot_chrom = fltarr(tt(1),tt(3))       ; total Stokes Q signal
u_tot_chrom = fltarr(tt(1),tt(3))       ; total Stokes U signal
v_tot_chrom = fltarr(tt(1),tt(3))       ; total Stokes V signal
poldeg_chrom= fltarr(tt(1),tt(3))       ; polarization degree
ncp_chrom       = fltarr(tt(1),tt(3))   ; net circular polarization
n_vlobes_chrom  = fltarr(tt(1),tt(3))   ; number of lobes in V
polarity_chrom  = fltarr(tt(1),tt(3))   ; polarity of the V signal
loverv_chrom   = fltarr(tt(1),tt(3))   ; ratio of linear and circular polarization
ampl_blue_chrom = fltarr(tt(1),tt(3))   ; amplitude of blue Stokes V lobe
ampl_red_chrom  = fltarr(tt(1),tt(3))   ; amplitude of red Stokes V lobe
v_zero_chrom    = fltarr(tt(1),tt(3))   ; zero-crossing position
pos_lobes_chrom = fltarr(tt(1),tt(3),2) ; position of the Stokes V lobes
relareaasym_chrom  = fltarr(tt(1),tt(3))   ; net circular polarization
l_chrom = fltarr(tt(1),tt(3))   ; 


b_weakfield_chrom = fltarr(tt(1),tt(3)) ; magnetic flux derived from the weak-field approximation
semel_pos_chrom = fltarr(tt(1),tt(3))   ; magnetic flux derived from the Semel-method (center of gravity in I+V and I-V)

linepos_phot = [105 , 135]
linepos_chrom = [210 ,240]
cont_wl = [235,255]

dispersion = 5.85
pollimit = .006

qcorr = total(full_spec(190:199,*,*,1),1)/10.
ucorr = total(full_spec(190:199,*,*,2),1)/10.
vcorr = total(full_spec(197:199,*,*,3),1)/3.

for k = 0,12 do begin & vcorr(*,k+97) = vcorr(*,96)+ k /12.*(vcorr(*,110) - vcorr(*,96)) & endfor
for k = 0,20 do begin & vcorr(*,k+329) = vcorr(*,328)+ k /20.*(vcorr(*,349) - vcorr(*,328)) & endfor


window,0,xs = tt(1)*2,ys = tt(3)*2

for k = 0,tt(1)-1 do begin 
   for kk = 0,tt(3)-1 do begin


      iline = smooth(reform(full_spec(k,*,kk,0)),3,/edge_truncate)
      qline = smooth(reform(full_spec(k,*,kk,1)),3,/edge_truncate)
      uline = smooth(reform(full_spec(k,*,kk,2)),3,/edge_truncate)
      vline = smooth(reform(full_spec(k,*,kk,3)),3,/edge_truncate)

      qline = qline -qcorr(*,kk)
      uline = uline -ucorr(*,kk)
      vline = vline -vcorr(*,kk)

      qline = qline - mean(qline(30:450))
      uline = uline - mean(uline(30:450))
      vline = vline - mean(vline(30:450))

; line parameters
      q_max(k,kk) = max(abs(qline(linepos_phot(0):linepos_phot(1))))
      u_max(k,kk) = max(abs(uline(linepos_phot(0):linepos_phot(1))))
      v_max(k,kk) = max(abs(vline(linepos_phot(0):linepos_phot(1))))
      q_tot(k,kk) = total(abs(qline(linepos_phot(0):linepos_phot(1))))*dispersion
      u_tot(k,kk) = total(abs(uline(linepos_phot(0):linepos_phot(1))))*dispersion
      v_tot(k,kk) = total(abs(vline(linepos_phot(0):linepos_phot(1))))*dispersion
      lll = sqrt(qline^2.+uline^2.)

      l_phot(k,kk) = max(lll(linepos_phot(0):linepos_phot(1)))

      ppol = sqrt(qline^2.+uline^2.+vline^2.) ; polarization degree with wl
      poldeg(k,kk) = max(ppol(linepos_phot(0):linepos_phot(1)))
      rms_poldeg(k,kk) = stddev(ppol(cont_wl(0):cont_wl(1)))
      rms_q(k,kk) = stddev(qline(cont_wl(0):cont_wl(1)))
      rms_u(k,kk) = stddev(uline(cont_wl(0):cont_wl(1)))
      rms_v(k,kk) = stddev(vline(cont_wl(0):cont_wl(1)))

      ncp(k,kk) = total(vline(linepos_phot(0):linepos_phot(1)))*dispersion
      relareaasym(k,kk) = total(vline(linepos_phot(0):linepos_phot(1)))/total(abs(vline(linepos_phot(0):linepos_phot(1))))

      erg = analyze_profile_type(iline,qline,uline,vline,linepos_phot,pollimit,velolimit = velolimit,intenslimit = intenslimit,veloscale = 1.95,plt = plt,winindex = 14,/no_smooth,/gfpi)  ; analysis of profile type

      if erg.polarity eq 1 then begin
         ncp(k,kk) = ncp(k,kk)*(-1.) ; change NCP to calculation of blue lobe - red lobem, when polarity is positive
           relareaasym(k,kk) = relareaasym(k,kk)*(-1.)
      endif

      n_vlobes(k,kk) = erg.lobenr(2)  ; number of lobes in V
      polarity(k,kk) = erg.polarity   ; polarity of V signal
      loverv(k,kk) = erg.lincircratio ; ratio L/V
      
; for single lobed profile, insert amplitude in blue/red lobe map,
; depending on location of zero-crossing relative to Stokes I minimum,
; and store position of lobe analogously
      if n_vlobes(k,kk) eq 1 then begin
         if erg.lobepos(0) lt erg.lobepos(3) then ampl_red(k,kk) = vline( erg.lobepos(3)) else ampl_blue(k,kk) = vline( erg.lobepos(3)) 
         if erg.lobepos(0) lt erg.lobepos(3) then pos_lobes(k,kk,1) = erg.vlobespos(0) else pos_lobes(k,kk,0) = erg.vlobespos(0)   
      endif
; for double-lobed profiles, store amplitudes, positions of both
; lobes, store zero-crossing position
      if n_vlobes(k,kk) eq 2 then begin
         ampl_blue(k,kk) = erg.vlobeint(0)
         ampl_red(k,kk) = erg.vlobeint(1)
         v_zero(k,kk) = erg.lobepos(3)
         pos_lobes(k,kk,0) = erg.vlobespos(0)
         pos_lobes(k,kk,1) = erg.vlobespos(1)
      endif

      if poldeg(k,kk) gt pollimit/2. then begin
; derivation of flux with weak-field approximation V ~ a * DI/Dl ->
; fit of a

         nn = linepos_phot(1)-linepos_phot(0)+1.
         weights = fltarr(nn)+1.
         xx = findgen(nn)
         y  = vline(linepos_phot(0):linepos_phot(1))
         a = [.1,deriv(iline(linepos_phot(0):linepos_phot(1)+10))]
       
         erg = curvefit(xx,y,weights,a,fita = [1,fltarr(41)],/noderivative,function_name='weakfield',/double)
         b_weakfield(k,kk) = a(0)      
 

; derivation with Semel method
;------------- correct ----
         i1 = iline(linepos_phot(0))-(iline(linepos_phot(0):linepos_phot(1))+vline(linepos_phot(0):linepos_phot(1)))
         i2 = iline(linepos_phot(0))-(iline(linepos_phot(0):linepos_phot(1))-vline(linepos_phot(0):linepos_phot(1)))
         rr = integrator(i1)
         rr1 = integrator((findgen(nn))*i1)
         posbary1 = rr1/float(rr)

         rr = integrator(i2)
         rr1 = integrator((findgen(nn))*i2)
         posbary2 = rr1/float(rr)
         semel_pos(k,kk) = posbary2 - posbary1
;------------- correct ----

      endif




; line parameters
      q_max_chrom(k,kk) = max(abs(qline(linepos_chrom(0):linepos_chrom(1))))
      u_max_chrom(k,kk) = max(abs(uline(linepos_chrom(0):linepos_chrom(1))))
      v_max_chrom(k,kk) = max(abs(vline(linepos_chrom(0):linepos_chrom(1))))
      q_tot_chrom(k,kk) = total(abs(qline(linepos_chrom(0):linepos_chrom(1))))*dispersion
      u_tot_chrom(k,kk) = total(abs(uline(linepos_chrom(0):linepos_chrom(1))))*dispersion
      v_tot_chrom(k,kk) = total(abs(vline(linepos_chrom(0):linepos_chrom(1))))*dispersion
      ppol = sqrt(qline^2.+uline^2.+vline^2.) ; polarization degree with wl
      poldeg_chrom(k,kk) = max(ppol(linepos_chrom(0):linepos_chrom(1)))

      l_chrom(k,kk) = max(lll(linepos_chrom(0):linepos_chrom(1)))

     
      ncp_chrom(k,kk) = total(vline(linepos_chrom(0):linepos_chrom(1)))*dispersion
      relareaasym_chrom(k,kk) = total(vline(linepos_chrom(0):linepos_chrom(1)))/total(abs(vline(linepos_chrom(0):linepos_chrom(1))))

      erg = analyze_profile_type(iline,qline,uline,vline,linepos_chrom,pollimit,velolimit = velolimit,intenslimit = intenslimit,veloscale = 1.95,plt = plt,winindex = 14,/no_smooth,/gfpi)  ; analysis of profile type

      if erg.polarity eq 1 then begin
         ncp_chrom(k,kk) = ncp_chrom(k,kk)*(-1.) ; change NCP to calculation of blue lobe - red lobem, when polarity is positive
           relareaasym_chrom(k,kk) = relareaasym_chrom(k,kk)*(-1.)
      endif

      n_vlobes_chrom(k,kk) = erg.lobenr(2)  ; number of lobes in V
      polarity_chrom(k,kk) = erg.polarity   ; polarity of V signal
      loverv_chrom(k,kk) = erg.lincircratio ; ratio L/V
      
; for single lobed profile, insert amplitude in blue/red lobe map,
; depending on location of zero-crossing relative to Stokes I minimum,
; and store position of lobe analogously
      if n_vlobes_chrom(k,kk) eq 1 then begin
         if erg.lobepos(0) lt erg.lobepos(3) then ampl_red_chrom(k,kk) = vline( erg.lobepos(3)) else ampl_blue_chrom(k,kk) = vline( erg.lobepos(3)) 
         if erg.lobepos(0) lt erg.lobepos(3) then pos_lobes_chrom(k,kk,1) = erg.vlobespos(0) else pos_lobes_chrom(k,kk,0) = erg.vlobespos(0)   
      endif
; for double-lobed profiles, store amplitudes, positions of both
; lobes, store zero-crossing position
      if n_vlobes_chrom(k,kk) eq 2 then begin
         ampl_blue_chrom(k,kk) = erg.vlobeint(0)
         ampl_red_chrom(k,kk) = erg.vlobeint(1)
         v_zero_chrom(k,kk) = erg.lobepos(3)
         pos_lobes_chrom(k,kk,0) = erg.vlobespos(0)
         pos_lobes_chrom(k,kk,1) = erg.vlobespos(1)
      endif

      if poldeg_chrom(k,kk) gt pollimit/2. then begin
; derivation of flux with weak-field approximation V ~ a * DI/Dl ->
; fit of a

         nn = linepos_chrom(1)-linepos_chrom(0)+1.
         weights = fltarr(nn)+1.
         xx = findgen(nn)
         y  = vline(linepos_chrom(0):linepos_chrom(1))
         a = [.1,deriv(iline(linepos_chrom(0):linepos_chrom(1)+10))]
       
         erg = curvefit(xx,y,weights,a,fita = [1,fltarr(nn+10)],/noderivative,function_name='weakfield',/double)
         b_weakfield_chrom(k,kk) = a(0)      
 

; derivation with Semel method
;------------- correct ----
         i1 = iline(linepos_chrom(0))-(iline(linepos_chrom(0):linepos_chrom(1))+vline(linepos_chrom(0):linepos_chrom(1)))
         i2 = iline(linepos_chrom(0))-(iline(linepos_chrom(0):linepos_chrom(1))-vline(linepos_chrom(0):linepos_chrom(1)))
         rr = integrator(i1)
         rr1 = integrator((findgen(nn))*i1)
         posbary1 = rr1/float(rr)

         rr = integrator(i2)
         rr1 = integrator((findgen(nn))*i2)
         posbary2 = rr1/float(rr)
         semel_pos_chrom(k,kk) = posbary2 - posbary1
;------------- correct ----

      endif
   endfor

print,k
tvscl,polarity,0,0
tvscl,poldeg,tt(1),0
tvscl,polarity_chrom,0,tt(3)
tvscl,poldeg_chrom,tt(1),tt(3)


endfor



; conversion to magnetic flux for weak-field approximation
;b_weakfield = abs(b_weakfield)/(4.67*10^(-13.)*2.5*6302.5^2.)*1./23.5
; conversion to magnetic flux for Semel method
;semel_pos = semel_pos/2.*23.5/1000./(4.67*10^(-13.)*2.5*6302.5^2.)

close,1

print,'Saving to: ',outfile_1

save,  q_max_chrom,u_max_chrom,v_max_chrom,q_tot_chrom,u_tot_chrom,v_tot_chrom,poldeg_chrom,ncp_chrom  ,n_vlobes_chrom ,polarity_chrom ,loverv_chrom   ,ampl_blue_chrom,ampl_red_chrom ,v_zero_chrom   ,pos_lobes_chrom,relareaasym_chrom ,b_weakfield_chrom ,semel_pos_chrom,q_max,u_max,v_max,q_tot,u_tot,v_tot,poldeg,rms_poldeg,rms_q,rms_u,rms_v,ncp  ,n_vlobes ,polarity ,loverv   ,ampl_blue,ampl_red ,v_zero   ,pos_lobes,relareaasym ,b_weakfield ,semel_pos,l_phot,l_chrom,filename = outfile_1



endfor



stop



end

