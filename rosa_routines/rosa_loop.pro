pro rosa_loop


pp = 0
if pp eq 1 then begin

;inpath ='/data/cbeck/obs2014/obs_mayjune_2014_kwangsu/07_june_2014/'
;outpath = '/data/cbeck/obs2014/obs_mayjune_2014_kwangsu/rosa/070614/'
;wavelen = '393'
;twice = 1.

inpath ='/data/cbeck/data1/obs_mayjune_2014_kwangsu/07_june_2014/das1/'
outpath = '/data/cbeck/obs2014/obs_mayjune_2014_kwangsu/rosa/070614/'
wavelen = '430'
twice = .5

generate_rosa_movies_multiscan,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,ssampl = 30.,rrange= rrange,ssmooth_width = ssmooth_width ;,/single_fits, start_scan =0.


stop

;rrange = [250,750]
;ssmooth_width = 5.

endif

wavelen = '417'

;wavelen = '430'

wavelen = '350'

dday1 = ['1/03','1/04','1/06','1/07','1/08','1/10','2/11','2/14','2/16','2/17','3/22','3/23','3/24','3/25','4/26','4/28','4/29']

;dday1 = ['1/3','1/4','1/6','1/7','1/8','1/10','2/11','2/14','2/16','2/17','3/22','3/23','3/24','3/25','4/26','4/28','4/29']

dday2 = ['3','4','6','7','08','10','11','14','16','17','22','23','24','25','26','28','29']

dday = ['03','04','06','07','08','10','11','14','16','17','22','23','24','25','26','28','29']


;day = '03'
;ddas = 'das1/'

;wavelen = 'Halpha'
;inpath = '/net/koa/export/data/cbeck/obs2017/obs_may2017/23_may_2017/rosa/t1113_halpha_may23_2017/'

wavelen = 'Ca II K'

;wavelen = 'G-Band'

inpath = '/net/koa/export/data/cbeck/obs2017/obs_may2017/01_jun_2017/rosa/t1113_cak_jun01_2017/'
outpath = '/net/koa/export/data/cbeck/obs2017/obs_may2017/ROSA_anim/010617/'

twice = 1.
rev = 1
rrange = [0.3,2.4]  ; [0.3,1.4]

generate_rosa_movies_multiscan,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,ssampl = 30.,rrange= rrange,ssmooth_width = ssmooth_width,/single_fits ;,start_scan =0.,/single_fits

stop

for k = 15,n_elements(dday)-1 do begin ; 7,n_elements(dday)-1  do begin ; n_elements(dday)-1 do begin8,9 do begin  ; 

day1 = dday1(k)
day = dday(k)
day2 = dday2(k)

inpath ='/data/cbeck/data1/obs2014/servicemode_cycle3/batch'+day1+'_october_2014/oct_'+day2+'_350nm/'

outpath = '/data/cbeck/data1/obs2014/rosa_movies/'+day+'1014/'
spawn,'mkdir '+outpath

;outpath = '/data/cbeck/obs2014/obs_mayjune_2014_kwangsu/rosa/070614/'

;wavelen = '417'
;wavelen = '430'

wavelen = '350'

twice = .5
rev = 1
rrange = [0.3,2.4]  ; [0.3,1.4]

generate_rosa_movies_multiscan,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,ssampl = 30.,rrange= rrange,ssmooth_width = ssmooth_width,/single_fits ;,start_scan =0.

endfor

stop



twice = 1.
oof = 1.
rev = 1

inpath = '/net/koa/export/data/cbeck/obs2017/obs_may2017/01_jun_2017/rosa/t1113_gband_jun01_2017/'
wavelen = 'G-band'


;inpath = '/net/koa/export/data/cbeck/obs2017/obs_may2017/30_may_2017/rosa/t1113_halpha_may30_2017/'
;wavelen = 'Halpha'
;a = intarr(2060,2050)
;openr,1,inpath+'20170530_1515/0085000000spool.dat'
;readu,1,a
;close,1
;window,0,xs = 2048/4.,ys = 2048/4.
;tvscl,congrid(a(0:2047,0:2047),512,512,/interp)
;xyouts,.01,.01,wavelen,/normal,color = 0,charsize = 2.5
;a = tvrd()
;outpath = '/export/raid2/cbeck/work/ROSA_archive/2017/300517/'
;write_gif,outpath+'HARDcam_data_201705230_1515_ha.gif',a

inpath = '/net/koa/export/data/cbeck/obs2017/obs_may2017/01_jun_2017/rosa/t1113_cak_jun01_2017/'
wavelen = 'Ca II K'

outpath = '/export/raid2/cbeck/work/ROSA_archive/2017/010617/'

generate_rosa_archive_files,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,oof = oof,/single_fits



filepath = outpath
rosa_create_html,filepath = filepath,target = target, comments = comments, help = help


;endfor
rosa_create_mainhtml



stop

inpath ='/data/cbeck/data1/obs_mayjune_2014_kwangsu/02_june_2014/'+ddas
outpath = '/export/cbeck/ROSA_archive/2014/020614/'
spawn,'mkdir '+outpath

generate_rosa_archive_files,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,oof = oof

filepath = outpath
rosa_create_html,filepath = filepath,target = target, comments = comments, help = help



inpath ='/data/cbeck/data1/obs_mayjune_2014_kwangsu/03_june_2014/'+ddas
outpath = '/export/cbeck/ROSA_archive/2014/030614/'
spawn,'mkdir '+outpath

generate_rosa_archive_files,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,oof = oof

filepath = outpath
rosa_create_html,filepath = filepath,target = target, comments = comments, help = help


inpath ='/data/cbeck/data1/obs_mayjune_2014_kwangsu/04_june_2014/'+ddas
outpath = '/export/cbeck/ROSA_archive/2014/040614/'
spawn,'mkdir '+outpath

generate_rosa_archive_files,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,oof = oof

filepath = outpath
rosa_create_html,filepath = filepath,target = target, comments = comments, help = help


inpath ='/data/cbeck/data1/obs_mayjune_2014_kwangsu/05_june_2014/'+ddas
outpath = '/export/cbeck/ROSA_archive/2014/050614/'
spawn,'mkdir '+outpath

generate_rosa_archive_files,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,oof = oof

filepath = outpath
rosa_create_html,filepath = filepath,target = target, comments = comments, help = help


inpath ='/data/cbeck/data1/obs_mayjune_2014_kwangsu/06_june_2014/'+ddas
outpath = '/export/cbeck/ROSA_archive/2014/060614/'
spawn,'mkdir '+outpath

generate_rosa_archive_files,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,oof = oof

filepath = outpath
rosa_create_html,filepath = filepath,target = target, comments = comments, help = help


;inpath ='/data/cbeck/data1/obs_mayjune_2014_kwangsu/07_june_2014/'+ddas
;outpath = '/export/cbeck/ROSA_archive/2014/070614/'
;spawn,'mkdir '+outpath

;generate_rosa_archive_files,inpath=inpath,outpath=outpath, no_swap = no_swap,fast = fast, pp1 = pp1,target = target, comments = comments,help = help,tip2 = tip2,twice = twice,ps = ps,swap= swap,wavelen= wavelen,rev = rev,oof = oof 

;filepath = outpath
;rosa_create_html,filepath = filepath,target = target, comments = comments, help = help


rosa_create_mainhtml

end


