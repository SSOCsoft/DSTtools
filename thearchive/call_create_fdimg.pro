pro call_create_fdimg

date = '210814'

inpath = '/home/cbeck/obs2014/casini_judge/210814/'

;home/cbeck/work/reza/obs_july_2014/'+date+'/'

pos = [ [-400,220], [-400+5,220+5], [0,0], [-250,30], [-250+5,30+5], [-875,400]]

times = ['UT 14:30-15:01','UT 15:02-15:22','UT 15:26-15:46','UT 15:49-15:59','UT 20:08-20:36','UT 20:43-21:37']

gen_fulldisk,inpath +date+'_HMIIF.jpg',pos,fltarr(n_elements(times))+100,fltarr(n_elements(times))+100,inpath +date+'_hmiif.jpg',times=times


gen_fulldisk,inpath +date+'_HMIB.jpg',pos,fltarr(n_elements(times))+100,fltarr(n_elements(times))+100,inpath +date+'_hmib.jpg',times=times

gen_fulldisk,inpath +'20140821162954Bh.jpg',pos,fltarr(n_elements(times))+100,fltarr(n_elements(times))+100,inpath +date+'_halpha.jpg',times=times,diameter = 910.

stop


end
