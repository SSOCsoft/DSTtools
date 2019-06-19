pro loop_fulldisk



inpath = '/export/cbeck/work/the_archive/'
outpath = '/export/cbeck/THE_archive/2013/01/'


ddate = '190113'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [0.,950.],[-670,670.],[-240,270]]
times = ['UT 16:22-??','UT 17:15-??','UT 18:42-??']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times ;,/nopause
gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause

; 15:48:04 17:58:21
; 18:20:36 18:56:52

; -463,118  , -442,167

ddate = '200113'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files

erg = read_directory(inpath+ddate+'/',filter ='*Bh*')
halphafile = erg.files

pos = [ [410.,-167.],[442,-107.]]
times = ['UT 15:48-17:58','UT 18:20-18:57']
box_dimension=[100,100]

gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times,/nopause

gen_fulldisk,inpath+ddate+'/'+halphafile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_halpha.jpg',times=times,diameter = 910.

;,/nopause
gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause


ddate = '210113'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [220.,280.],[120,280.]]
times = ['UT 16:34-??','UT 17:29-??']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause

ddate = '220113'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [420.,280.],[310,280.],[350,280.],[390,280.]]
times = ['UT 15:49-??','UT 16:34-17:??','17:17-??','17:46-??']
box_dimension=[50,100]

gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause

ddate = '230113'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [520.,280.],[610,280.]]
times = ['UT 16:45-17:30','UT 17:31-17:??']
box_dimension=[75,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause


ddate = '240113'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [-600.,280.]]
times = ['UT 21:45-??']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause

outpath = '/export/cbeck/THE_archive/2013/02/'

ddate = '010213'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [530.,-80.],[-450.,260.],[610,500.]]
times = ['UT 15:41-16:07','UT 16:09-16:45','UT 16:53-??']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times
gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause


ddate = '020213'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [-70,290.]]
times = ['UT 16:00-17:45']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times


ddate = '040213'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [-560.,450.],[-500,450.]]
times = ['UT 16:36-17:00','UT 17:05-??']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause


ddate = '050213'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files


erg = read_directory(inpath+ddate+'/',filter ='*Bh*')
halphafile = erg.files

pos = [ [300.,280.],[350,300.],[-400,450]]
times = ['UT 16:02-16:39','UT 16:50-17:27','UT 18:18-18:57']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+halphafile(1),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_halpha.jpg',times=times,diameter = 910.

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause


ddate = '060213'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [-120.,460.],[550,280.],[-180.,460.]]

times = ['UT 15:22-16:23','UT 16:26-17:27','UT 18:01-18:02']
box_dimension=[100,100]

gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause

ddate = '070213'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [10.,450.],[-470,375.]]

times = ['UT 15:53-16:50','UT 16:59-??']

box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times


gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause


ddate = '110213'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [330.,400.]]
times = ['UT 16:01-16:34']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times


gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause


ddate = '130213'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files


erg = read_directory(inpath+ddate+'/',filter ='*Bh*')
halphafile = erg.files


pos = [ [-620.,320.],[-820,-505.],[-830,-505]]

times = ['UT 16:11-16:45','UT 17:50-18:41','UT 21:42-22:32']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+halphafile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_halpha.jpg',times=times,diameter = 910.

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause


ddate = '140213'
erg = read_directory(inpath+ddate+'/',filter ='*HMIB*')
magfile = erg.files
erg = read_directory(inpath+ddate+'/',filter ='*HMII*')
intfile = erg.files
pos = [ [0,925.],[-660,660.],[0,0],[0,-200]]
times = ['UT 16:17-16:43','UT 16:49-17:15','UT 17:51-18:41','UT 18:46-18:56']
box_dimension=[100,100]
gen_fulldisk,inpath+ddate+'/'+intfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmi.jpg',times=times

gen_fulldisk,inpath+ddate+'/'+magfile(0),pos,box_dimension[0],box_dimension[1],outpath+ddate+'/'+ddate+'_hmib.jpg',times=times,/nopause




end
