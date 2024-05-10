pro time

set_plot,'ps'
!P.FONT=0

loadct,0
tvlct,r_0,g_0,b_0,/get

loadct,39
tvlct,r_39,g_39,b_39,/get

Aaa = FINDGEN(17) * (!PI*2/16.)  
USERSYM, COS(Aaa), SIN(Aaa), /FILL 

; times
read_all_times=0 ; if 0 [1=default] then only read in more recent simulations 
           ;   (e.g. tfke,tfks), for testing or gmst
do_times=0 ; read/write timeseries files
do_timeseries_plot=0 ; plot global mean SST timeseries of each simulation
do_gmst_plot=0 ; plot last navy years of SST through phanerozoic

; gregory plots
read_all_greg=0 ; if 0 [0=default] then only read in more recent simulations 
           ;   (e.g. tfke,tfks), for speed
do_greg=0 ; read gregory data
do_greg_plot=0 ; , make gregory plots (requires do_greg and do_clims)

;means
read_all_clims=0 ; if 0 [0=default] then only read in more recent simulations 
           ;   (e.g. tfke,tfks), for speed
do_clims=1 ; read in model output
do_readbounds=1 ; read in mask and ice
do_readsolar=1 ; read solar forcing and albedo
  do_ff_model=1 ; forcing/feedback model               
  do_temp_plot=1 ; global mean from proxies
  do_co2_plot=0 ; prescribed co2 (requires do_ff_model)
  do_lsm_plot=0 ; prescribed land area
  do_solar_plot=0 ; prescribed solar forcing
  do_ice_plot=0 ; prescribed ice sheets
  do_forcings_plot=1 ; prescribed forcings in Wm-2
  do_forctemps_plot=1 ; prescribed forcings in oC
  do_polamp_plot=1 ;  plot polamp
  do_clim_plot=1 ;  plot new vs old, EBM, MDC, and resid
                 ;  (requires ff_model) 
  do_scattemp_plot=0
  do_climsens_plot=0
  do_ess_plot=0
  do_grads_plot=1

do_textfile1=0 ; textfile of proxies for Emily
do_textfile2=0 ; textfile of proxies for Chris
do_textfile3=0 ; textfile of fluxes for Emily
do_textfile4=0 ; textfile of forcings for Emily

check_names=1 ; check names

;;;;
; Total number of time snapshots
ndates=109
nexp=10
tmax=4000
nstart=0
;;;;

;;;;
; for timeseries to save time
writing=intarr(ndates,nexp)
writing(*,*)=0
;writing(*,4)=1
;writing(*,5)=1
reading=intarr(ndates,nexp)
for e=0,nexp-1 do begin
reading(*,e)=1-writing(*,e)
endfor
; does time data exist for this simulation?
readfile_t=intarr(ndates,nexp) 
if (read_all_times eq 1) then begin
readfile_t(*,*)=1
endif else begin
;readfile_t(0:1,4)=1
;readfile_t(0:1,5)=1
readfile_t(*,4)=1
readfile_t(*,5)=1
endelse

; for gregory to save time
writing_g=intarr(ndates,nexp)
writing_g(*,*)=0
;writing_g(*,4:5)=1
reading_g=intarr(ndates,nexp)
for e=0,nexp-1 do begin
reading_g(*,e)=1-writing_g(*,e)
endfor
; does gregory data exist for this simulation?
readfile_g=intarr(ndates,nexp)
if (read_all_greg eq 1) then begin
readfile_g(*,*)=1
endif else begin
readfile_g(*,4)=1
readfile_g(*,5)=1
endelse


 ; does clim data exist for this simulation?
readfile=intarr(ndates,nexp)
if (read_all_clims eq 1) then begin
readfile(*,*)=1
readfile(*,6)=0 ; tflm for Shufeng no longer stored
endif else begin
readfile(*,4)=1
;readfile(*,4:5)=1
;readfile(*,9)=1 ; add this back if Vadles (2021) needed.
;;;;;;;; *******************************
; missing tfks files
;tfks_missing=[21,49,51]-1
;readfile(tfks_missing,5)=0
;;;;;;;; *******************************
endelse



readtype=intarr(ndates,nexp) ; um_climates [0] or ummodel [1] for clims
readtype(*,0)=1
readtype(*,1)=1
readtype(*,2)=1
readtype(*,3)=1
readtype(*,4)=1
readtype(*,5)=1
readtype(*,6)=0
readtype(*,7)=1
readtype(*,8)=1
readtype(*,9)=1


;;;;;;;; *******************************
;readtype([20,48,50],5)=0
;;;;;;;; *******************************

locdata=intarr(ndates,nexp) ; um_climates [1] or ummodel [0] for timeseries
locdata(*,0)=0
locdata(*,1)=0
locdata(*,2)=0
;;;;;;;; *******************************
locdata([16,39,50,59,66,68],2)=1 ; jaq,jAn,jAy,Jah,Jao,Jaq ; CHECK THIS!!!
;;;;;;;; *******************************
locdata(*,3)=0
locdata(*,4)=0
locdata(*,5)=0
locdata(*,6)=1
locdata(*,7)=0
locdata(*,8)=0
locdata(*,9)=0



co2file=strarr(nexp)
co2file(0)='co2_all_02'
co2file(1)='co2_all_02'
co2file(2)='co2_all_03_nt'
co2file(3)='co2_all_02'
co2file(4)='co2_all_03_nt'
co2file(5)='co2_all_04_nt'
co2file(6)='co2_all_04_nt'
co2file(7)='co2_all_02'
co2file(8)='co2_all_02'
co2file(9)='co2_all_xx'


colexp=intarr(nexp)
colexp(0)=50
colexp(1)=100
colexp(2)=150
colexp(3)=200
colexp(4)=0
colexp(5)=250
colexp(6)=220
colexp(7)=130
colexp(8)=80
colexp(9)=180


ndepth=3
my_missing=intarr(nexp,ndates,tmax,ndepth)
my_missing(*,*,*,*)=1
;my_missing(2,59,[252,328,340,400,434,443,503,505,536,653,664,678,684,686,711,718,747,752,782,786],*)=0 ; tfJah
;my_missing(2,68,[834,1927,1932],*)=0 ; tfJaq
;my_missing(2,16,[323],*)=0 ; tfjaq
;my_missing(2,16,[318,320,324,327,328,329,330,333,366,367,398,399,401,405,410,412,416,447,448,451,452,500,503,507,510,514,515,516,517,519,520,521,524,747,757,758,759,760,813,884,885,888,891,892,974,976,977,979,981,982],*)=0 ; tfjaq

exproot=strarr(ndates,nexp)
exptail=strarr(ndates,nexp)
exptail2=strarr(ndates,nexp)

; Paul's teye 
exproot(0:25,0)=['teye']
exptail(0:25,0)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
exproot(26:51,0)=['teyE']
exptail(26:51,0)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
exproot(52:77,0)=['teYe']
exptail(52:77,0)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
exproot(78:103,0)=['teYE']
exptail(78:103,0)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
exproot(104:108,0)=['tEye']
exptail(104:108,0)=['a','b','c','d','e']

; My tfgw
exproot(0:25,1)=['tfgw']
exproot(26:51,1)=['tfgW']
exproot(52:77,1)=['tfGw']
exproot(78:103,1)=['tfGW']
exproot(104:108,1)=['tFgw']

; My tfja
exproot(0:25,2)=['tfja']
exproot(26:51,2)=['tfjA']
exproot(52:77,2)=['tfJa']
exproot(78:103,2)=['tfJA']
exproot(104:108,2)=['tFja']

; Paul's teyf 
exproot(0:25,3)=['teyf']
exproot(26:51,3)=['teyF']
exproot(52:77,3)=['teYf']
exproot(78:103,3)=['teYF']
exproot(104:108,3)=['tEyf']

; My tfke
exproot(0:25,4)=['tfke']
exproot(26:51,4)=['tfkE']
exproot(52:77,4)=['tfKe']
exproot(78:103,4)=['tfKE']
exproot(104:108,4)=['tFke']

; My tfks
exproot(0:25,5)=['tfks']
exproot(26:51,5)=['tfkS']
exproot(52:77,5)=['tfKs']
exproot(78:103,5)=['tfKS']
exproot(104:108,5)=['tFks']

; My tflm
exproot(0:25,6)=['tflm']
exproot(26:51,6)=['tflM']
exproot(52:77,6)=['tfLm']
exproot(78:103,6)=['tfLM']
exproot(104:108,6)=['tFlm']

; Paul's teyd
exproot(0:25,7)=['teyd']
exproot(26:51,7)=['teyD']
exproot(52:77,7)=['teYd']
exproot(78:103,7)=['teYD']
exproot(104:108,7)=['tEyd']

; Paul's teyd
exproot(0:25,8)=['teyd']
exproot(26:51,8)=['teyD']
exproot(52:77,8)=['teYd']
exproot(78:103,8)=['teYD']
exproot(104:108,8)=['tEyd']

; Paul's Scotese02
exproot(0:25,9)=['texp']
exproot(26:51,9)=['texP']
exproot(52:77,9)=['teXp']
exproot(78:103,9)=['teXP']
exproot(104:108,9)=['texq']

for e=1,nexp-1 do begin
exptail(*,e)=exptail(*,0)
endfor
exptail2(*,0)=''
exptail2(*,1)=''
exptail2(*,2)=''
exptail2(*,3)='3'
exptail2(*,4)=''
exptail2(*,5)=''
exptail2(*,6)=''
exptail2(*,7)=''
exptail2(*,8)='1'
; Scotese02:
exptail2(*,9)=''
exptail2([0,6,7,8,11,12,13,14,20,21,24,25,31,32,34,35,36,37,38,39,40,41,42,43,44,45,46,47],9)='1'
exptail2([9,10,17,18,19,22,23,26,27,28,29,30,33,48],9)='2'

nexp_g=2
ppt=intarr(nexp_g)
ppt(*)=[4,5]
; which set of simulations to plot and analyse?
; pe = final untuned simulations
pe=ppt(0)
; pt = tuned simulations
pt=ppt(1)
; ps = Scotese02 simulations
ps=9


varname=strarr(ndates,nexp)
varname(*,0)='temp_ym_dpth'
varname(*,1)='temp_ym_dpth'
varname(*,2)='temp_ym_dpth'
varname(*,3)='temp_ym_dpth'
varname(*,4)='temp_ym_dpth'
varname(*,5)='temp_ym_dpth'
varname(*,6)='temp_ym_dpth'
varname(*,7)='temp_ym_dpth'
varname(*,8)='temp_ym_dpth'
varname(*,9)='temp_ym_dpth'


nyear=intarr(nexp)
nyear(*)=[2000,1050,3000,-1,3000,3000,110,2000,2000,-1]
torder=intarr(nexp)
torder(*)=[2,3,4,-1,5,6,7,0,1,-1]
check_cont=intarr(nexp)
check_cont(*)=[1,1,1,-1,1,1,1,0,1,-1]
xmint=0
xmaxt=21000
times=indgen(xmaxt)
explab=5 ; final simulation that will be labelled

; plot_times: do we want to plot the timeseries?
plot_tims=intarr(nexp)
plot_tims(*)=[1,1,1,0,1,1,0,1,1,0]

; navy = how many years for averaging means
navy=intarr(nexp)
navy(*)=[20,20,20,20,20,20,20,20,20,20]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;No more EXP edits needed beyond here ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

nexp2=total(torder ne -1)
myshift=intarr(nexp)
myshift(*)=-1
run=0
for tt=0,nexp2-1 do begin
ttt=where(torder(*) eq tt)
myshift(ttt)=run
run=run+nyear(ttt)+100
endfor
print,'myshift: '
print,myshift


;;;;

depthname2=strarr(ndepth)
depthname2=['5','666','2731']
depthname3=strarr(ndepth)
depthname3=['1','12','16']
depth=strarr(ndepth)
depth=['L01','L12','L16']
depthname=['5m','670m','2700m']
ymina=fltarr(ndepth)
ymaxa=fltarr(ndepth)
ymina=[13,2,-2]
ymaxa=[30,16,16]

lim=fltarr(ndepth,2)
lim(0,0)=10.0
lim(1,0)=2.0
lim(2,0)=-2
lim(0,1)=28.0
lim(1,1)=15.5
lim(2,1)=16


root=strarr(ndates,nexp)
roottim=strarr(ndates,nexp)
for n=nstart,ndates-1 do begin
for e=0,nexp-1 do begin

if (locdata(n,e) eq 0) then begin
roottim(n,e)='/home/bridge/ggdjl/ummodel/data'
endif
if (locdata(n,e) eq 1) then begin
roottim(n,e)='/home/bridge/ggdjl/um_climates'
endif

if (readtype(n,e) eq 1) then begin
root(n,e)='/home/bridge/ggdjl/ummodel/data'
endif
if (readtype(n,e) eq 0) then begin
root(n,e)='/home/bridge/ggdjl/um_climates'
endif

endfor
endfor


sim_names=strarr(ndates)
sim_names_long=strarr(ndates)
sim_tail=strarr(ndates)
sim_ext=strarr(ndates,nexp)




expname=strarr(ndates,nexp)
expnamel=strarr(ndates,nexp)
dates=fltarr(ndates,nexp)
names=strarr(ndates,nexp)
dates2=fltarr(ndates)
dates2edge=fltarr(ndates+1)

dates3=strarr(ndates)
co2=fltarr(ndates)
solar=fltarr(ndates)

for e=0,nexp-1 do begin
for n=nstart,ndates-1 do begin
expnamel(n,e)=exproot(n,e)+exptail(n,e)+exptail2(n,e)
endfor
endfor

nx=96
ny=73
lats=fltarr(ny)
latsedge=fltarr(ny+1)
dlat=2.5
latsedge(1:ny-1)=90.0-1.25-dlat*findgen(ny-1)
latsedge(0)=90.0
latsedge(ny)=-90.0


weight_lat=fltarr(ny)
for j=0,ny-1 do begin
weight_lat(j)=-0.5*(sin(latsedge(j+1)*2*!pi/360.0)-sin(latsedge(j)*2*!pi/360.0))
lats(j)=0.5*(latsedge(j+1)+latsedge(j))
endfor
; Note - weighting above is correct as weighted half for northern
;        and southern boxes. 

weight=fltarr(nx,ny)
newweight=fltarr(nx,ny)

mytemp=fltarr(tmax,ndates,ndepth,nexp)
ntimes=intarr(ndates,nexp)
gmst=fltarr(ndates,ndepth,nexp)
trend=fltarr(ndates,ndepth,nexp)

nxmax=96
nymax=73

nvar=2
nxc=intarr(nvar)
nyc=intarr(nvar)
nxc(*)=[96,96]
nyc(*)=[73,73]

latsedgec=fltarr(nymax+1,nvar)
dlat=2.5
for v=0,nvar-1 do begin
latsedgec(1:nyc(v)-1,v)=90.0-1.25-dlat*findgen(nyc(v)-1)
latsedgec(0,v)=90.0
latsedgec(nyc(v),v)=-90.0
endfor



nfl=3
nflr=2
flname=strarr(nflr)
flname(*)=['downSol_mm_TOA','upSol_mm_s3_TOA']


if (check_names eq 1) then begin

my_line=''
dum=''
my_date=''
my_name=''

close,1
openr,1,'/home/bridge/swsvalde/ummodel/scripts/html_list/movies/scotese_04.dat'
readf,1,my_line
readf,1,dum
readf,1,my_date
readf,1,my_name
close,1

my_lines=strsplit(my_line,' ',/EXTRACT)
my_dates=strsplit(my_date,' ',/EXTRACT)
my_names=strsplit(my_name,' ',/EXTRACT)

size_check_1=size(my_lines)
size_check_2=size(my_dates)
size_check_3=size(my_names)

print,'size checks:'
print,size_check_1
print,size_check_2
print,size_check_3

if (size_check_1(1) ne ndates or size_check_2(1) ne ndates or size_check_3(1) ne ndates) then begin
print,'unexpected length'
print,size_check_1(1),size_check_2(1),size_check_3(1)
stop
endif

my_lines(0)=strmid(my_lines(0),13)
str=my_lines(ndates-1)
my_lines(ndates-1)=str.Remove(-1)
expname(*,0)=my_lines(*)

my_dates(0)=strmid(my_dates(0),13)
str=my_dates(nexp-1)
my_dates(nexp-1)=str.Remove(-1)
dates(*,0)=my_dates(*)

my_names(0)=strmid(my_names(0),13)
str=my_names(nexp-1)
my_names(nexp-1)=str.Remove(-1)
names(*,0)=my_names(*)

sim_names_long(*)=reverse(my_names(*))

endif ; end if check_names


if (do_times eq 1) then begin

for e=0,nexp-1 do begin

for d=0,ndepth-1 do begin

for n=nstart,ndates-1 do begin


if (writing(n,e) eq 1) then begin

if (readfile_t(n,e) eq 1) then begin

if (locdata(n,e) eq 0) then begin
data_filename=roottim(n,e)+'/'+expnamel(n,e)+'/monthly/'+expnamel(n,e)+'.temp_ym_dpth_'+depthname2(d)+'.annual.nc'
endif

if (locdata(n,e) eq 1) then begin
data_filename=roottim(n,e)+'/'+expnamel(n,e)+'/'+expnamel(n,e)+'.oceantemppg'+depthname3(d)+'.monthly.nc'
endif

print,n,'Reading: '+data_filename
id1=ncdf_open(data_filename)
ncdf_varget,id1,varname(n,e),dummy
ncdf_close,id1
a=size(dummy)
ntimes(n,e)=a(4)

for t=0,ntimes(n,e)-1 do begin

weight(*,*)=dummy(*,*,0,t) lt 1e20

for j=0,ny-1 do begin
for i=0,nx-1 do begin
newweight(i,j)=weight_lat(j)*weight(i,j)
endfor
endfor

mytemp(t,n,d,e)=total(dummy(*,*,0,t)*newweight(*,*)/total(newweight(*,*)))
if (my_missing(e,n,t,d) eq 0) then begin
mytemp(t,n,d,e)=!VALUES.F_NAN
endif

if (n ge nstart) then begin
if (mytemp(t,n,d,e) lt lim(d,0)) then begin
print,'PROBLEM',n,t,d,e,mytemp(t,n,d,e)
endif
if (mytemp(t,n,d,e) gt lim(d,1)) then begin
print,'PROBLEM',n,t,d,e,mytemp(t,n,d,e)
endif
endif


endfor ; end t (ntimes)

my_filename='my_data/temp_'+expnamel(n,e)+'_'+depth(d)+'.dat'
openw,1,my_filename
printf,1,ntimes(n,e)
printf,1,mytemp(*,n,d,e)
close,1

endif ; end readfile_t

endif ; end writing(e)

endfor ; end n (nstart)

endfor ; end d (depth)

endfor ; end e (nexp)





for e=0,nexp-1 do begin
for d=0,ndepth-1 do begin
for n=nstart,ndates-1 do begin
if (reading(n,e) eq 1) then begin

if (readfile_t(n,e) eq 1) then begin

my_filename='my_data/temp_'+expnamel(n,e)+'_'+depth(d)+'.dat'
print,'Reading: '+my_filename
openr,1,my_filename
readf,1,aa
ntimes(n,e)=aa
aaaa=fltarr(aa)
readf,1,aaaa
mytemp(0:aa-1,n,d,e)=aaaa
close,1

for t=0,ntimes(n,e)-1 do begin
if (my_missing(e,n,t,d) eq 0) then begin
mytemp(t,n,d,e)=!VALUES.F_NAN
endif
endfor

for t=0,ntimes(n,e)-1 do begin
if (mytemp(t,n,d,e) lt lim(d,0)) then begin
print,'PROBLEM',n,t,d,e,mytemp(t,n,d,e)
mytemp(t,n,d,e)=!VALUES.F_NAN
endif
if (mytemp(t,n,d,e) gt lim(d,1)) then begin
print,'PROBLEM',n,t,d,e,mytemp(t,n,d,e)
mytemp(t,n,d,e)=!VALUES.F_NAN
endif
endfor


endif
endif ; end reading(e)
endfor ; end n (nstart)
endfor ; end d (depth)
endfor ; end e (nexp)


; check for continuity across experiments

print,'CONTINUITY CHECK'
for tt=0,nexp2-1 do begin
ttt=where(torder(*) eq tt)
print,ttt,exproot(0,ttt)
if (torder(ttt) ne -1 and torder(ttt) ne 0 and check_cont(ttt) eq 1) then begin
tttm=where(torder(*) eq tt-1)
for n=nstart,ndates-1 do begin
if (readfile_t(n,ttt) eq 1) then begin
;print,'checking continuity for: '+expnamel(n,ttt)
diff=mytemp(ntimes(n,tttm)-1,n,2,tttm)-mytemp(0,n,2,ttt)
;print,mytemp(ntimes(n,tttm)-1,n,2,tttm),mytemp(0,n,2,ttt),diff
if (abs(diff) gt 0.02) then begin
print,'OWCH - non-continuity', ttt,tttm,n,expnamel(n,ttt),expnamel(n,tttm),diff
endif
endif
endfor
endif
endfor

; check for continuity within experiment

cclim=fltarr(ndepth)
cclim(*)=[1,0.5,0.2]

for e=1,nexp-1 do begin
for d=0,ndepth-1 do begin
for n=nstart,ndates-1 do begin

corr_count=0

if (readfile_t(n,e) eq 1) then begin

for t=1,ntimes(n,e)-1 do begin
diff=mytemp(t,n,d,e)-mytemp(t-1,n,d,e)
if (abs(diff) gt cclim(d)) then begin
;print,'problem - correcting!'
;print,expnamel(n,e),diff,n,e,t
mytemp(t,n,d,e)=mytemp(t-1,n,d,e)
corr_count=corr_count+1
endif
endfor

if (corr_count ne 0) then begin
print,'corrected:'
print,expnamel(n,e),d,corr_count
endif

endif

endfor
endfor
endfor


; check for expected length
for e=1,nexp-1 do begin
for n=nstart,ndates-1 do begin
if (readfile_t(n,e) eq 1) then begin
if (nyear(e) ne -1) then begin
if (abs(ntimes(n,e)-nyear(e)) gt 0) then begin
print,'PROBLEM in expected length!!'
print,expnamel(n,e),ntimes(n,e),nyear(e)
endif
endif
endif
endfor
endfor

; calculate trends for paper

ntrend=500
for e=1,nexp-1 do begin
for d=0,ndepth-1 do begin
for n=nstart,ndates-1 do begin
if (readfile_t(n,e) eq 1) then begin
if (ntimes(n,e) ge ntrend) then begin

lfit=linfit(findgen(ntrend), mytemp(ntimes(n,e)-ntrend:ntimes(n,e)-1,n,d,e) )
trend(n,d,e)=lfit(1)*1000.0
;print,expnamel(n,e)+' '+depthname(d)+' '+strtrim(trend(n,d,e),2)

endif
endif
endfor

if (readfile_t(0,e) eq 1) then begin
if (ntimes(0,e) ge ntrend) then begin
print,'** FOR PAPER**  BIGGEST ABS TREND IS: '+depthname(d)
print,e
print,max(abs(trend(*,d,e)),nn)
print,expnamel(nn,e),nn,e

print,'**FOR PAPER** MEAN ABS TREND IS: '+depthname(d)
print,mean(abs(trend(*,d,e)))
endif
endif


endfor
endfor

endif ; end times



if (do_greg eq 1) then begin
print,'reading/writing gregory data'

; set up vars:
nav=500
tmax_g=3000*12.0
t1max=tmax_g/12.0
t2max=tmax_g/(12.0*nav)
nvar_g=4
varname_g=strarr(nvar)
varname_g=['downSol_mm_TOA','upSol_mm_s3_TOA','olr_mm_s3_TOA','temp_mm_1_5m']

mytemp_g=dblarr(tmax_g,ndates,nexp_g,nvar_g)
mytemp1=fltarr(t1max,ndates,nexp_g,nvar_g)
mytemp2=fltarr(t2max,ndates,nexp_g,nvar_g)
mytempsur1=fltarr(t1max,ndates,nexp_g)
mytemptoa1=fltarr(t1max,ndates,nexp_g)
mytempsur2=fltarr(t2max,ndates,nexp_g)
mytemptoa2=fltarr(t2max,ndates,nexp_g)

ntimes_g=lonarr(ndates,nexp_g,nvar_g)
ntimes1=lonarr(ndates,nexp_g,nvar_g)
ntimes2=lonarr(ndates,nexp_g,nvar_g)

gmst_g=fltarr(ndates,nexp_g)
tempsur_g=fltarr(ndates,nexp_g)


; weights:
newweight_g=fltarr(nx,ny)
for j=0,ny-1 do begin
for i=0,nx-1 do begin
newweight_g(i,j)=weight_lat(j)
endfor
endfor
totweight_g=total(newweight_g(*,*))


; ****
; main loop for writing

print,'writing Gregory fluxes if required'

for ee=0,nexp_g-1 do begin
e=ppt(ee)
for n=nstart,ndates-1 do begin

if (writing_g(n,e) eq 1) then begin
if (readfile_g(n,e) eq 1) then begin

for v=0,nvar_g-1 do begin

if (locdata(n,e) eq 0) then begin
data_filename=roottim(n,e)+'/'+expnamel(n,e)+'/monthly/'+expnamel(n,e)+'.'+varname_g(v)+'.monthly.nc'
endif

if (locdata(n,e) eq 1) then begin
print,'Gregory for temporary data not yet coded'
stop
endif

print,n,ee,e,data_filename

id1=ncdf_open(data_filename)
ncdf_varget,id1,varname_g(v),dummy
ncdf_close,id1
a=size(dummy)
ntimes_g(n,ee,v)=a(4)

for t=0,ntimes_g(n,ee,v)-1 do begin

mytemp_g(t,n,ee,v)=total(dummy(*,*,0,t)*newweight_g(*,*))/totweight_g

endfor ; end t (ntimes)

my_filename='my_data/'+varname_g(v)+'_'+expnamel(n,e)+'.dat'
print,my_filename
openw,1,my_filename
printf,1,ntimes_g(n,ee,v)
printf,1,mytemp_g(*,n,ee,v)
close,1

endfor

endif
endif ; end if writing

endfor
endfor



; ****
; main loop for reading

print,'reading Gregory fluxes if required'
for ee=0,nexp_g-1 do begin
e=ppt(ee)
for n=nstart,ndates-1 do begin

if (writing_g(n,e) eq 0) then begin
if (readfile_g(n,e) eq 1) then begin

for v=0,nvar_g-1 do begin

my_filename='my_data/'+varname_g(v)+'_'+expnamel(n,e)+'.dat'
;print,my_filename
openr,1,my_filename
readf,1,aa
ntimes_g(n,ee,v)=aa
aaaa=fltarr(aa)
readf,1,aaaa
mytemp_g(*,n,ee,v)=aaaa
close,1

endfor ; end v
endif ; end readfile_g
endif ; end if reading
endfor ; end n
endfor ; end ee


;;; now work out averages...

ntimes1(*,*,*)=ntimes_g(*,*,*)/12.0
ntimes2(*,*,*)=ntimes_g(*,*,*)/(12.0*nav)

for ee=0,nexp_g-1 do begin
e=ppt(ee)

for v=0,nvar_g-1 do begin
for n=nstart,ndates-1 do begin

if (readfile_g(n,e) eq 1) then begin

for t=0,ntimes1(n,ee,v)-1 do begin
mytemp1(t,n,ee,v)=mean(mytemp_g(t*12L:t*12L+11L,n,ee,v))
endfor

for t=0,ntimes2(n,ee,v)-1 do begin
mytemp2(t,n,ee,v)=mean(mytemp_g(t*12L*nav:t*12L*nav+12L*nav-1,n,ee,v))
endfor

endif ; end readfile

endfor ; end n (nstart)
endfor ; end e (nexp)
endfor ; end v 

mytempsur1(*,*,*)=mytemp1(*,*,*,3)-273.15
mytemptoa1(*,*,*)=mytemp1(*,*,*,0)-mytemp1(*,*,*,1)-mytemp1(*,*,*,2)
mytempsur2(*,*,*)=mytemp2(*,*,*,3)-273.15
mytemptoa2(*,*,*)=mytemp2(*,*,*,0)-mytemp2(*,*,*,1)-mytemp2(*,*,*,2)

for ee=0,nexp_g-1 do begin
e=ppt(ee)
for n=nstart,ndates-1 do begin

;print,'simulation:',expnamel(n,e)
;print,'FINAL TOA INBALANCE:',mytemptoa2(*,n,ee)

; linear fit
lfit=linfit(mytempsur2(*,n,ee),mytemptoa2(*,n,ee))
gmst_g(n,ee)=-1*lfit(0)/lfit(1)
tempsur_g(n,ee)=lfit(0)+lfit(1)*mytempsur2(0,n,ee)

endfor

print,'** FOR PAPER**  BIGGEST TOA INBALANCE IS:'
print,e,ee
print,max(abs(mytemptoa2(t2max-1,*,ee)),nn)
print,expnamel(nn,e)

print,'**FOR PAPER** MEAN ABS TOA INBALANCE IS:'
print,mean(abs(mytemptoa2(t2max-1,*,ee)))

endfor


endif ; end do gregory



line=''
dum=''
nrows_scot=120
dates_scot=fltarr(nrows_scot)
temp_scot=fltarr(nrows_scot)
close,1
openr,1,'pal_data/Phanerozoic_Paleotemperature_Summaryv4_Master.csv'
readf,1,dum
readf,1,dum
for n=0,nrows_scot-1 do begin
;print,n
readf,1,line
;print,line
my_line=strsplit(line,',',/EXTRACT,/PRESERVE_NULL)
dates_scot(n)=my_line(0)
temp_scot(n)=my_line(10)
;print,my_line(0)+' '+my_line(2)+' '+my_line(5)+' '+my_line(9)+' '+my_line(10)
endfor
close,1
dates_scot=dates_scot*(-1.0)

line=''
dum=''
nrows_scot1m=541
dates_scot1m=fltarr(nrows_scot1m)
temp_scot1m=fltarr(nrows_scot1m)
temp_scot1morig=fltarr(nrows_scot1m)
close,1
openr,1,'pal_data/Phanerozoic_Paleotemperature_Summaryv4_1myr.csv'
readf,1,dum
for n=0,nrows_scot1m-1 do begin
;print,n
readf,1,line
;print,line
my_line=strsplit(line,',',/EXTRACT,/PRESERVE_NULL)
dates_scot1m(n)=my_line(0)
temp_scot1morig(n)=my_line(1)
;print,my_line(0)+' '+my_line(1)+' '+my_line(2)+' '+my_line(3)+' '+my_line(4)
endfor
close,1
dates_scot1m=dates_scot1m*(-1.0)


print,'editing scot_1m orig'
temp_scot1m=temp_scot1morig
; remove K-Pg
temp_scot1m(66)=mean([temp_scot1m(65),temp_scot1m(67)])
templim=28.0
; remove max temps > 28.0 in P-T
for t=1,nrows_scot1m-1 do begin
if (temp_scot1m(t) gt templim) then begin
  temp_scot1m(t)=templim
endif
endfor
; 5-point running mean
temp_scot1m=smooth(temp_scot1m,5,/EDGE_TRUNCATE)




line=''
dum=''
nrows_wing0=151
dates_wing0=fltarr(nrows_wing0)
temp_wing0=fltarr(nrows_wing0)
close,1
openr,1,'pal_data/Final_temp_curve_400_ma_-_present_djl.csv'
readf,1,dum
readf,1,dum
for n=0,nrows_wing0-1 do begin
;print,n
readf,1,line
;print,line
my_line=strsplit(line,',',/EXTRACT,/PRESERVE_NULL)
if (n eq 0 or my_line(1) ne '') then begin
dates_wing0(n)=my_line(1)
temp_wing0(n)=my_line(2)
endif
;print,my_line(0)+' '+my_line(2)+' '+my_line(5)+' '+my_line(9)+' '+my_line(10)
endfor
close,1


line=''
dum=''
nrows_wing1=21
dates_wing1=fltarr(nrows_wing1)
temp_wing1=fltarr(nrows_wing1)
close,1
openr,1,'pal_data/2.5.1-G5.P1_G2-C_TemperatureGraph_20180226_mod_Kensversion_new_final.txt'
readf,1,dum
for n=0,nrows_wing1-1 do begin
;print,n
readf,1,line
;print,line
my_line=strsplit(line,',',/EXTRACT,/PRESERVE_NULL)
dates_wing1(n)=my_line(0)
temp_wing1(n)=my_line(1)
;print,my_line(0)+' '+my_line(2)+' '+my_line(5)+' '+my_line(9)+' '+my_line(10)
endfor
close,1
my_ind=reverse(sort(dates_wing1))
dates_wing1=dates_wing1(my_ind)
temp_wing1=(temp_wing1(my_ind)-32.0)*5.0/9.0

nrows_wing=nrows_wing0+nrows_wing1
dates_wing=[dates_wing0,dates_wing1]
temp_wing=[temp_wing0,temp_wing1]


line=''
dum=''
nrows_judd=85
dates_judd=fltarr(nrows_judd)
close,1
openr,1,'pal_data/GTS.csv'
readf,1,dum
for n=0,nrows_judd-1 do begin
;print,n
readf,1,line
;print,line
my_line=strsplit(line,',',/EXTRACT,/PRESERVE_NULL)
dates_judd(n)=my_line(5)
endfor
close,1
dates_judd=dates_judd*(-1.0)

line=''
dum=''
nrows_judd=85
temp_judd=fltarr(nrows_judd)
close,1
openr,1,'pal_data/GMST.csv'
readf,1,dum
for n=0,nrows_judd-1 do begin
;print,n
readf,1,line
;print,line
my_line=strsplit(line,',',/EXTRACT,/PRESERVE_NULL)
temp_judd(n)=my_line(2)
endfor
close,1


line=''
close,1
openr,1,'../islands/'+co2file(pe)+'.dat'
for n=nstart,ndates-1 do begin
readf,1,line
my_line=strsplit(line,' ',/EXTRACT)
dates2(n)=my_line(1)
co2(n)=my_line(2)
endfor
close,1
dates2=dates2*(-1.0)
for n=nstart+1,ndates-1 do begin
dates2edge(n)=(dates2(n-1)+dates2(n))/2.0
endfor
dates2edge(nstart)=0
dates2edge(ndates)=dates2(ndates-1)-1
;print,'dates2:'
;print,dates2
;print,'dates2edge:'
;print,dates2edge


temp_judd_interp=interpol(temp_judd,dates_judd,dates2)
temp_scot_interp=interpol(temp_scot,dates_scot,dates2)
temp_scot1m_interp=interpol(temp_scot1m,dates_scot1m,dates2)
temp_wing_interp=interpol(temp_wing,dates_wing,dates2)

line=''
close,1
openr,1,'solar_all.dat'
readf,1,line
for n=nstart,ndates-1 do begin
readf,1,line
my_line=strsplit(line,' ',/EXTRACT)
dates3(n)=my_line(1)
solar(n)=my_line(2)
endfor
close,1




for e=0,nexp-1 do begin
for d=0,ndepth-1 do begin
for n=nstart,ndates-1 do begin
gmst(n,d,e)=mean(mytemp(ntimes(n,e)-(1+navy(e)):ntimes(n,e)-1,n,d,e))
endfor
endfor
endfor




nreg=8
regname=strarr(nreg)
xs=intarr(nreg)
xf=intarr(nreg)
ys=intarr(nreg)
yf=intarr(nreg)
regname(*)=['nh-hl','nh-ml','nh-ll','sh-ll','sh-ml','sh-hl','gl','tr']
xs(*)=[0,0,0,0,0,0,0,0]
xf(*)=[95,95,95,95,95,95,95,95]
ys(*)=[0,12,24,37,49,61,0,24]
yf(*)=[11,23,35,48,60,72,72,48]


print,'latitude ranges are: '
for r=0,nreg-1 do begin
print,r,ys(r),yf(r),latsedge(ys(r)),latsedge(yf(r)+1)
endfor

;stop

climtag=strarr(nvar)
climtag(*)=['a.pd','o.pf']
climname=strarr(nvar)
climname(*)=['temp_mm_1_5m','temp_mm_uo']

climnamelong=strarr(nvar)
climnamelong(*)=['temp','sst']
climnamelongx=strarr(nvar*2+1)
climnamelongx(*)=['temp-tempp','sst-sstp','temp-sst','tempp-sstp','all']
climnametitle=strarr(nvar)
climnametitle(*)=['SAT','SST']
climnametitlex=strarr(nvar*2+1)
climnametitlex(*)=['SAT vs. SAT-polamp','SST vs. SST-polamp','SAT vs. SST','SAT-polamp vs. SST-polamp','all']

climoff=fltarr(nvar)
climoff(*)=[-273.15,0]

yminc=fltarr(nvar)
ymaxc=fltarr(nvar)
yminc=[8,14]
ymaxc=[28,27]

yminr=fltarr(nvar)
ymaxr=fltarr(nvar)
yminr=[-4,-5]
ymaxr=[4,5]

yminm=fltarr(nvar)
ymaxm=fltarr(nvar)
yminm=[18,17]
ymaxm=[45,26]

yminp=fltarr(nvar)
ymaxp=fltarr(nvar)
yminp=[18,17]
ymaxp=[45,26]




climweight=fltarr(nxmax,nymax,ndates,nvar)
climweight_lat=fltarr(nymax,nvar)

for v=0,nvar-1 do begin
for j=0,nyc(v)-1 do begin
climweight_lat(j,v)=-0.5*(sin(latsedgec(j+1,v)*2*!pi/360.0)-sin(latsedgec(j,v)*2*!pi/360.0))
endfor
endfor

; read in bounds


if (do_readbounds eq 1) then begin

masks=fltarr(nx,ny,ndates)
masks_mean=fltarr(ndates)
ice=fltarr(nx,ny,ndates)
ice_mean=fltarr(ndates)

for n=nstart,ndates-1 do begin
; read in lsm
filename=root(0,0)+'/'+expnamel(n,0)+'/inidata/'+expnamel(n,0)+'.qrparm.mask.nc'
print,'Reading: '+filename
id1=ncdf_open(filename)
ncdf_varget,id1,'lsm',dummy
masks(*,*,n)=dummy
ncdf_close,id1
for j=0,ny-1 do begin
masks_mean(n)=masks_mean(n)+weight_lat(j)*mean(masks(*,j,n))
endfor
endfor

for n=nstart,ndates-1 do begin
; read in ice
filename=root(0,0)+'/'+expnamel(n,0)+'/inidata/'+expnamel(n,0)+'.qrfrac.type.nc'
print,'Reading: '+filename
id1=ncdf_open(filename)
ncdf_varget,id1,'field1391',dummy
;print,size(dummy)
ice(*,*,n)=dummy(*,*,8)
ice(*,*,n)=ice(*,*,n)*(ice(*,*,n) gt -1)
ncdf_close,id1
for j=0,ny-1 do begin
ice_mean(n)=ice_mean(n)+weight_lat(j)*mean(ice(*,j,n))
endfor
endfor

endif

; read solar

if (do_readsolar eq 1) then begin

flsol=fltarr(nx,ny,ndates,nfl)
flsol_mean=fltarr(ndates,nfl)

for n=nstart,ndates-1 do begin

for f=0,nflr-1 do begin
; read in fluxes
filename=root(0,0)+'/'+expnamel(n,0)+'/climate/'+expnamel(n,0)+'a.pdclann.nc'
print,'Reading: '+filename
id1=ncdf_open(filename)
ncdf_varget,id1,flname(f),dummy
flsol(*,*,n,f)=dummy
ncdf_close,id1
for j=0,ny-1 do begin
flsol_mean(n,f)=flsol_mean(n,f)+weight_lat(j)*mean(flsol(*,j,n,f))
endfor
endfor ; end f

; planetary albedo
flsol(*,*,n,nfl-1)=flsol(*,*,n,1)/flsol(*,*,n,0)
for j=0,ny-1 do begin
flsol_mean(n,nfl-1)=flsol_mean(n,nfl-1)+weight_lat(j)*mean(flsol(*,j,n,nfl-1))
endfor

endfor


endif


if (do_clims eq 1) then begin

clims=fltarr(nxmax,nymax,ndates,nexp,nvar)
grads=fltarr(nymax,ndates,nexp,nvar)
climav=fltarr(ndates,nexp,nvar)
climav_r=fltarr(ndates,nexp,nvar,nreg)
climnewweight=fltarr(nxmax,nymax)
polamp=fltarr(ndates,nexp,nvar)

for e=0,nexp-1 do begin
for n=nstart,ndates-1 do begin
for v=0,nvar-1 do begin

if (readfile(n,e) eq 1) then begin

if (readtype(n,e) eq 1) then begin
data_filename=root(n,e)+'/'+expnamel(n,e)+'/climate/'+expnamel(n,e)+climtag(v)+'clann.nc'
endif
if (readtype(n,e) eq 0) then begin
data_filename=root(n,e)+'/'+expnamel(n,e)+'/'+expnamel(n,e)+climtag(v)+'clann.nc'
endif

print,readtype(n,e),n,data_filename
id1=ncdf_open(data_filename)
ncdf_varget,id1,climname(v),dummy
ncdf_close,id1
clims(0:nxc(v)-1,0:nyc(v)-1,n,e,v)=dummy

weight=dummy(*,*,0,0) lt 1e20
for j=0,nyc(v)-1 do begin
for i=0,nxc(v)-1 do begin
climnewweight(i,j)=climweight_lat(j,v)*weight(i,j)
endfor
endfor
climav(n,e,v)=total(dummy(*,*,0,0)*climnewweight(*,*)/total(climnewweight(*,*)))+climoff(v)

for r=0,nreg-1 do begin

weight(xs(r):xf(r),ys(r):yf(r))=dummy(xs(r):xf(r),ys(r):yf(r),0,0) lt 1e20
for j=ys(r),yf(r)-1 do begin
for i=xs(r),xf(r)-1 do begin
climnewweight(i,j)=climweight_lat(j,v)*weight(i,j)
endfor
endfor
climav_r(n,e,v,r)=total(dummy(xs(r):xf(r),ys(r):yf(r),0,0)*climnewweight(xs(r):xf(r),ys(r):yf(r))/total(climnewweight(xs(r):xf(r),ys(r):yf(r))))+climoff(v)

endfor

; regname(*)=['nh-hl','nh-ml','nh-ll','sh-ll','sh-ml','sh-hl','gl','tr']
polamp(n,e,v)= ( climav_r(n,e,v,7) - (climav_r(n,e,v,0)+climav_r(n,e,v,5))/2.0 )

for j=0,nyc(v)-1 do begin
grads(j,n,e,v) = mean(clims(0:nxc(v)-1,j,n,e,v),/nan)
endfor

endif

endfor
endfor
endfor

endif ; end do_clims






;;;;;;;;;;;;;;;;;;;;;;;;;;
; Forcing/feedback model

if (do_ff_model eq 1) then begin 

c_alb=0.27
c_co2=3.7

c_dalb=0.14-0.06
c_dalb_jud=0.14-0.06
;c_dalb_jud=0.2-0.02

c_dice=0.9-0.14


t_co2=1.0
t_co2_lin=1.0

baseline=0

;;;;;;
; ORIG SET OF PARAMS:
;t_solar=1.0
;t_area=0.8
;t_ice=0.2
;c_a=0.001
;lambda=-1.1

;t_solar_lin=1.0
;t_area_lin=0.8
;t_ice_lin=0.2
;lambda_lin=-1.1

; NEW SET OF PARAMS:
t_solar=1.0
t_area=0.8
t_ice=0.2
c_a=0.001
lambda=-0.9

t_solar_lin=t_solar
t_area_lin=t_area
t_ice_lin=t_ice
lambda_lin=lambda


;;;;;;



f_solar=fltarr(ndates)
f_solar_lin=fltarr(ndates)
f_solar_jud=fltarr(ndates)

f_area=fltarr(ndates)
f_area_lin=fltarr(ndates)
f_area_jud=fltarr(ndates)

f_ice=fltarr(ndates)
f_ice_lin=fltarr(ndates)

f_co2=fltarr(ndates)
f_co2_lin=fltarr(ndates)
f_co2_jud=fltarr(ndates)

f_solararea_jud=fltarr(ndates)

f_all=fltarr(ndates)
f_all_lin=fltarr(ndates)
f_all_jud=fltarr(ndates)

c_alb_time_jud=fltarr(ndates)
c_alb_time_jud=c_alb-(-1)*(masks_mean-masks_mean(baseline))*c_dalb_jud

temp_all=fltarr(ndates)
temp_all_lin=fltarr(ndates)


; units of f_co2 and f_solar are w/m2
f_co2(*)=t_co2*c_co2*alog(co2/co2(baseline))/alog(2.0)
f_solar(*)=t_solar*(1.0-c_alb)*(solar-solar(baseline))/4.0
f_area(*)=t_area*solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0
f_ice(*)=t_ice*solar*(-1.0)*(ice_mean-ice_mean(baseline))*c_dice/4.0

f_co2_jud(*)=1.0*c_co2*alog(co2/co2(baseline))/alog(2.0)
f_solar_jud(*)=1.0*(1.0-c_alb)*(solar-solar(baseline))/4.0
f_area_jud(*)=1.0*solar(0)*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb_jud/4.0

f_solararea_jud=solar*(1-c_alb_time_jud)/4.0 - solar(0)*(1-c_alb_time_jud(0))/4.0


f_co2_lin(*)=t_co2_lin*c_co2*alog(co2/co2(baseline))/alog(2.0)
f_solar_lin(*)=t_solar_lin*(1.0-c_alb)*(solar-solar(baseline))/4.0
f_area_lin(*)=t_area_lin*solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0
f_ice_lin(*)=t_ice*solar*(-1.0)*(ice_mean-ice_mean(baseline))*c_dice/4.0

f_all=f_co2+f_solar+f_area+f_ice
f_all_jud=f_co2_jud+f_solar_jud+f_area_jud
f_all_lin=f_co2_lin+f_solar_lin+f_area_lin+f_ice_lin


temp_all_lin=climav(baseline,pe,0) - 1.0*f_all_lin/lambda_lin 
temp_all= climav(baseline,pe,0) + (-1.0*lambda-sqrt(lambda*lambda-4.0*c_a*f_all))/(2.0*c_a)




;;;;;;;;;;;;;;;;;;;;;;;;;;
r_co2=c_co2*alog(co2/co2(baseline))/alog(2.0)
r_solar=(1.0-c_alb)*(solar-solar(baseline))/4.0
r_area=solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0
r_ice=solar*(-1.0)*(ice_mean-ice_mean(baseline))*c_dice/4.0

rr = [TRANSPOSE(r_co2), TRANSPOSE(r_solar), TRANSPOSE(r_area), TRANSPOSE(r_ice)]

myresult = REGRESS(rr, climav(*,pe,0), SIGMA=mysigma, CONST=myconst)
PRINT, 'Constant: ', myconst
PRINT, 'Coefficients: ', myresult[*]
PRINT, 'Standard errors: ', mysigma

t_co2_tun=1.0
t_solar_tun=myresult(1)/myresult(0)
t_area_tun=myresult(2)/myresult(0)
t_ice_tun=myresult(3)/myresult(0)
lambda_tun=-1.0/myresult(0)

print,'tuned vales for paper are: '
print,'t_solar_tun= ',t_solar_tun
print,'t_area_tun= ',t_area_tun
print,'t_ice_tun= ',t_ice_tun
print,'lambda_tun= ',lambda_tun
print,'sensitivity= ',-1*c_co2/lambda_tun

f_co2_tun=t_co2_tun*r_co2
f_solar_tun=t_solar_tun*r_solar
f_area_tun=t_area_tun*r_area
f_ice_tun=t_ice_tun*r_ice

f_all_tun=f_co2_tun+f_solar_tun+f_area_tun+f_ice_tun

temp_all_tun=myconst - 1.0*f_all_tun/lambda_tun 
temp_co2=myconst - 1.0*f_co2_tun/lambda_tun 
temp_solar=myconst - 1.0*f_solar_tun/lambda_tun 
temp_area=myconst - 1.0*f_area_tun/lambda_tun 
temp_ice=myconst - 1.0*f_ice_tun/lambda_tun 

; for paper:
print,'variances:'
print,'temp_all_tuin = ',variance(temp_all_tun)
print,'temp_co2 = ',variance(temp_co2)
print,'temp_solar = ',variance(temp_solar)
print,'temp_area = ',variance(temp_area)
print,'temp_ice = ',variance(temp_ice)
variance_sum=variance(temp_co2)+variance(temp_solar)+variance(temp_area)+variance(temp_ice)
print,'sum = ',variance_sum
print,'co2 and solar %: ',100*variance(temp_co2)/variance_sum, 100*variance(temp_solar)/variance_sum

myconst2=0.0
temp_all_tun_anom=myconst2 - 1.0*f_all_tun/lambda_tun 
temp_co2_anom=myconst2 - 1.0*f_co2_tun/lambda_tun 
temp_solar_anom=myconst2 - 1.0*f_solar_tun/lambda_tun 
temp_area_anom=myconst2 - 1.0*f_area_tun/lambda_tun 
temp_ice_anom=myconst2 - 1.0*f_ice_tun/lambda_tun 

resid=climav(*,pe,0)-temp_all_tun(*)
temp_resid=myconst + resid
resid_anom=climav(*,pe,0)-climav(0,pe,0)-temp_all_tun_anom(*)
temp_resid_anom=myconst2 + resid_anom


temp_all_tun2=myconst+myresult(0)*r_co2 + myresult(1)*r_solar + myresult(2)*r_area +myresult(3)*r_ice

testing=temp_all_tun-temp_all_tun2
myerr=sqrt(total(testing*testing)/(ndates*1.0))
if (myerr gt 1e-5) then begin
print,'Problem!!  temp_all_tun and temp_all_tun2'
stop
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;


; INFERRED CO2:

; old method
;f_co2_inf = lambda_lin*(climav(baseline,pe,0)-temp_scot_interp)-(f_solar_lin+f_area_lin+f_ice_lin)

; new method 1: 
f_co2_inf = lambda_tun*(resid+myconst-temp_scot_interp)-(f_solar_tun+f_area_tun+f_ice_tun)

; new method 2
f_co2_inf2 = f_co2_tun + lambda_tun * (climav(*,pe,0) - temp_scot_interp)
f_co2_inf2_1m = f_co2_tun + lambda_tun * (climav(*,pe,0) - temp_scot1m_interp)


; methods 1 and 2 should be the same
testing=f_co2_inf-f_co2_inf2
myerr=sqrt(total(testing*testing)/(ndates*1.0))
if (myerr gt 1e-5) then begin
print,'Problem!!  f_co2_inf and f_co2_inf2'
stop
endif

; raw co2
co2_inf=co2(baseline)*exp(f_co2_inf*alog(2)/(t_co2*c_co2))
co2_inf_1m=co2(baseline)*exp(f_co2_inf2_1m*alog(2)/(t_co2*c_co2))


; totally different method....

co2_inf_1m2=co2*exp(-1.0*alog(2.0)*lambda_tun*(temp_scot1m_interp-climav(*,pe,0))/(c_co2))
; methods should be the same
testing=co2_inf_1m2-co2_inf_1m
myerr=sqrt(total(testing*testing)/(ndates*1.0))
if (myerr gt 1e-2) then begin
print,'Problem!!  co2_inf_1m2 and co2_inf_1m'
stop
endif


; final check that inferred inferred temp is OK!

temp_all_tun3=resid+myconst+myresult(0)*c_co2*alog(co2_inf_1m/co2(baseline))/alog(2.0) + myresult(1)*r_solar + myresult(2)*r_area +myresult(3)*r_ice

testing=temp_all_tun3-temp_scot1m_interp
myerr=sqrt(total(testing*testing)/(ndates*1.0))
if (myerr gt 1e-5) then begin
print,'Problem!! temp_all_tun3 and temp_scot1m_interp'
stop
endif

; now print out inferred co2 

openw,1,'co2_inferred.dat'
printf,1,dates2
printf,1,co2_inf_1m
close,1


;;;;;;;;;;;;;;;;;;;;;;;;;;
endif



if (do_timeseries_plot eq 1) then begin

; TIMESERIES PLOT
for d=0,ndepth-1 do begin 


device,filename='timeseries_'+depth(d)+'_new4.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

; where individual names on lines are
labelx=18000
; where all naems are listed in relation to this
ddx=900

ymin=ymina(d)
ymax=ymaxa(d)


plot,times(0:ntimes(0,0)-1),mytemp(0:ntimes(0,0)-1,0,0,0),yrange=[ymin,ymax],xrange=[xmint,xmaxt],xtitle='Year of simulation',psym=2,/nodata,ytitle='Temperature [degrees C]',title='Global mean ocean temperature at '+depthname(d),ystyle=1,xstyle=1

;plot,times(0:ntimes(0,0)-1),mytemp(0:ntimes(0,0)-1,0,0,0),yrange=[ymin,ymax],xrange=[xmint,xmaxt],xtitle='Year of simulation',psym=2,/nodata,ytitle='Temperature [degrees C]',title='Global mean ocean temperature at '+depthname(d),ystyle=1,xtickname=['0','500','1000','1500','2000','2500','3000','3500','4000'],xtickv=[0,500,1000,1500,2000,2500,3000,3500,4000],xticks=8,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)

if (total(mytemp(0:ntimes(n,0)-1,n,d,0) eq 0) gt 0) then begin
print,mytemp(0:ntimes(n,0)-1,n,d,0)
print,'problem!!!'
print,total(mytemp(0:ntimes(n,0)-1,n,d,0) le 0)
print,n,sim_names_long(n),d
stop
endif

; plot each line
for e=0,nexp-1 do begin
if (plot_tims(e) eq 1) then begin
if (readfile_t(n,e) eq 1) then begin
xxx=myshift(e)
oplot,times(xxx:xxx+ntimes(n,e)-1),mytemp(0:ntimes(n,e)-1,n,d,e),color=mycol
if (e eq explab) then begin
xyouts,labelx,mytemp(ntimes(n,e)-1,n,d,e),expnamel(n,e)+' '+strtrim(ntimes(n,e),2),charsize=0.25,color=mycol
endif
endif
endif
endfor

z=ymin+0.9*(ymax-ymin)-0.8*(ymax-ymin)*x/(xx-1)
oplot,[labelx+ddx,labelx+ddx+70],[z,z],color=(n-nstart)*250.0/(ndates-nstart-1)
xyouts,labelx+ddx+100,z,sim_names_long(n)+' '+expnamel(n,explab)+' '+strtrim(ntimes(n,explab),2),charsize=0.25,color=(n-nstart)*250.0/(ndates-nstart-1)

endfor

; plot main experiment family label
for e=0,nexp-1 do begin
if (plot_tims(e) eq 1) then begin
z=ymin+0.97*(ymax-ymin)
xyouts,myshift(e)+nyear(e),z,exproot(0,e)+exptail2(0,e),alignment=1
endif
endfor

device,/close


endfor

endif


if (do_greg_plot eq 1) then begin

ngg=2

for ee=0,nexp_g-1 do begin
e=ppt(ee)

for n=nstart,ndates-1 do begin

if (readfile_g(n,e) eq 1) then begin


set_plot,'ps'
!P.FONT=0

for gg=0,ngg-1 do begin

if (gg eq 0) then begin
xmin=10
xmax=30
ymin=-1.5
ymax=1.5
endif
if (gg eq 1) then begin
myincx=1
myincy=1.5
xmint=min(mytempsur2(*,n,ee))
xmaxt=max(mytempsur2(*,n,ee))
xmin=xmint-(xmaxt-xmint)*myincx
xmax=xmaxt+(xmaxt-xmint)*myincx
ymax=max([max(mytemptoa2(*,n,ee)),abs(min(mytemptoa2(*,n,ee)))])*myincy
ymin=-1*ymax

endif

device,filename='plots/gregory_'+expnamel(n,e)+'_'+strtrim(gg,2)+'.eps',/encapsulate,/color,set_font='Helvetica'

tvlct,r_0,g_0,b_0

plot,[0],[0],yrange=[ymin,ymax],xrange=[xmin,xmax],psym=2,/nodata,xtitle='Global Mean Surface Temperature [!Uo!NC]',ytitle='TOA energy inbalance [W/m!U2!N]',title='Gregory Plot '+expnamel(n,e),xstyle=1,ystyle=1

oplot,mytempsur1(*,n,ee),mytemptoa1(*,n,ee),psym=8,symsize=0.2,color=200

oplot,mytempsur2(*,n,ee),mytemptoa2(*,n,ee),psym=8,symsize=1.5,color=0

oplot,mytempsur2(*,n,ee),mytemptoa2(*,n,ee),psym=8,symsize=0.5,color=250

oplot,mytempsur2(*,n,ee),mytemptoa2(*,n,ee),psym=8,symsize=0.1,color=0

xyouts,mytempsur2(*,n,ee)+(xmax-xmin)*0.02,mytemptoa2(*,n,ee)+(ymax-ymin)*0.02,strtrim(nint([1:t2max]),2),charsize=0.7,charthick=2

oplot,[-20,100],[0,0],color=0

oplot,[gmst_g(n,ee),mytempsur2(0,n,ee)],[0,tempsur_g(n,ee)],linestyle=2

dx1=0.7 ; point x
dy1=0.1 ; start point y
dx2=0.03 ; delta text x
dy2=0.05 ; delta y 
dy3=0.01 ; deta text y


; legend for gregory points
y1=ymax-(ymax-ymin)*(dy1+0*dy2)
y2=ymax-(ymax-ymin)*(dy1+1*dy2)
x1=xmin+(xmax-xmin)*(dx1)
x2=xmin+(xmax-xmin)*(dx1+dx2)
plots,x1,y1,psym=8,symsize=0.5,color=200
plots,x1,y2,psym=8,symsize=1.5,color=0
plots,x1,y2,psym=8,symsize=0.5,color=250
plots,x1,y2,psym=8,symsize=0.1,color=0
xyouts,x2,y1-(ymax-ymin)*dy3,'yearly'
xyouts,x2,y2-(ymax-ymin)*dy3,'500-year mean'

; plot inferred point and mean
;loadct,39
tvlct,r_39,g_39,b_39
plots,[gmst_g(n,ee),0],psym=8,symsize=1,color=250
plots,[climav(n,e,0),0],psym=8,symsize=1,color=70

; legend for above
y3=ymax-(ymax-ymin)*(dy1+2*dy2)
y4=ymax-(ymax-ymin)*(dy1+3*dy2)
plots,x1,y3,psym=8,symsize=1,color=250
plots,x1,y4,psym=8,symsize=1,color=70
xyouts,x2,y3-(ymax-ymin)*dy3,'regressed'
xyouts,x2,y4-(ymax-ymin)*dy3,'final 50-year mean'

device,/close

endfor

endif ; end readfile

endfor ; end dates

endfor ; end e

endif ; end do gregory plot



nstage=10
stageb=fltarr(nstage+1)
stageb(*)=-1.0*[0,66.0,145.0,201.3,251.902,298.9,358.9,419.2,443.8,485.4,541.0]
stagen=strarr(nstage)
stagen(*)=['Cenozoic','Cretaceous','Jurassic','Triassic','Permian','Carb.','Devonian','Sil.','Ord.','Cambrian']

r_cgmw=r_39
g_cgmw=g_39
b_cgmw=b_39
r_cgmw(0:nstage-1)=[242,127,52,129,240,103,203,179,0,127]
g_cgmw(0:nstage-1)=[249,198,178,43,64,165,140,225,146,160]
b_cgmw(0:nstage-1)=[29,78,201,146,40,153,55,182,112,86]


if (do_gmst_plot eq 1) then begin

; GMST PLOT
for d=0,0 do begin

device,filename='gmst_time_'+depth(d)+'.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0


ymin=ymina(d)
ymax=ymaxa(d)


plot,dates2,gmst(*,d,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',psym=2,/nodata,ytitle='Temperature [degrees C]',title='Global mean ocean temperature at '+depthname(d),ystyle=1,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)

if (readfile_t(n,0) eq 1) then begin
plots,dates2(n),gmst(n,d,0),color=mycol,psym=5
endif

if (readfile_t(n,1) eq 1) then begin
plots,dates2(n),gmst(n,d,1),color=mycol,psym=6
;xyouts,dates2(n)+5,gmst(n,d,1)+0.1,exproot(n,1)+exptail(n,1),charsize=0.2
endif

if (readfile_t(n,2) eq 1) then begin
plots,dates2(n),gmst(n,d,2),color=mycol,psym=7
xyouts,dates2(n)+5,gmst(n,d,2)+0.1,expnamel(n,2),charsize=0.2
endif

if (readfile_t(n,3) eq 1) then begin
plots,dates2(n),gmst(n,d,3),color=mycol,psym=4
xyouts,dates2(n)+5,gmst(n,d,3)+0.1,expnamel(n,3),charsize=0.2
endif

endfor ; end n


oplot,dates2(*),gmst(*,d,0)
oplot,dates2(*),gmst(*,d,1)
oplot,dates2(*),gmst(*,d,2)
oplot,dates2(*),gmst(*,d,3)




xyouts,-500,18,exproot(0,0)
plots,-520,18,psym=5

xyouts,-500,17,exproot(0,1)
plots,-520,17,psym=6

xyouts,-500,16,exproot(0,2)
plots,-520,16,psym=7

xyouts,-500,15,exproot(0,3)
plots,-520,15,psym=4

device,/close


endfor ; end d

endif ; end gmst plot





if (do_temp_plot eq 1) then begin

; 01 is Scotese[A] and WingHuber
; 02 is Scotese[A] and Scotese[B] and WingHuber
; 03 is Scotese[B]smoothed and WingHuber
; 04 is Scotese[B]smoothed and WingHuber and Judd

npp=4
ppname=strarr(npp)
ppname(*)=['01','02','03','04']
for p=0,npp-1 do begin

device,filename='temp_scotese_time_'+ppname(p)+'.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0


ymin=5
ymax=40

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0


plot,dates2,co2,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='Global Mean Temperature [oC]',ystyle=1,xstyle=1,/nodata

; Plot Wing and Huber in blue
;plots,dates_wing,temp_wing,psym=8,symsize=0.5,color=80
oplot,dates_wing,temp_wing,color=80,thick=3


if (p eq 0 or p eq 1) then begin
; Plot raw Scotese Master in dark blue
;plots,dates_scot,temp_scot,psym=8,symsize=0.5,color=100
oplot,dates_scot,temp_scot,color=120,thick=3
endif

if (p eq 1) then begin
; Plot raw Scotese 1m in green
oplot,dates_scot1m,temp_scot1morig,color=180,thick=3
endif

if (p eq 2 or p eq 3) then begin
; Plot final Scotese 1m in red
oplot,dates_scot1m,temp_scot1m,color=250,thick=3
;plots,dates2,temp_scot1m_interp,psym=6,symsize=0.5,color=250
endif

if (p eq 3) then begin
; Plot Judd in orange
oplot,dates_judd,temp_judd,color=200,thick=3
;oplot,dates2,temp_judd_interp,color=225,thick=3,linestyle=1

endif


oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

x1=-300
dx1=40
dx2=50
y1=8
dy1=1.5
dy2=0.5

if (p eq 0 or p eq 1) then begin
oplot,[x1,x1+dx1],[y1,y1],color=120,thick=3
xyouts,x1+dx2,y1-dy2,'Scotese et al (2021) [A]',color=120
endif

oplot,[x1,x1+dx1],[y1-dy1,y1-dy1],color=80,thick=3
xyouts,x1+dx2,y1-dy1-dy2,'Wing and Huber (2020)',color=80

if (p eq 1) then begin
oplot,[x1,x1+dx1],[y1+dy1,y1+dy1],color=180,thick=3
xyouts,x1+dx2,y1+dy1-dy2,'Scotese et al (2021) [B]',color=180
endif

if (p eq 2 or p eq 3) then begin
oplot,[x1,x1+dx1],[y1,y1],color=250,thick=3
xyouts,x1+dx2,y1-dy2,'Scotese et al (2021) [smoothed]',color=250
endif

if (p eq 3) then begin
oplot,[x1,x1+dx1],[y1+dy1,y1+dy1],color=200,thick=3
xyouts,x1+dx2,y1+dy1-dy2,'Judd et al (in press)',color=200
endif


device,/close

endfor

endif ; end if temp plot


if (do_co2_plot eq 1) then begin

for t=0,2 do begin

device,filename='co2_time_'+strtrim(t,2)+'.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0

ymin=0
ymax=4000

if (t eq 1 or t eq 2) then begin
ymin=0
ymax=12000
endif

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0

plot,dates2,co2,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='CO!D2!N [ppmv]',ystyle=1,xstyle=1,color=0,/nodata,YTICKFORMAT='(F6.0)'
oplot,dates2,co2,color=50
plots,dates2,co2,psym=8,symsize=0.5,color=50

if (t eq 1) then begin
oplot,dates2,co2_inf,color=250
oplot,dates2,co2_inf_1m,color=0,thick=5
plots,dates2,co2_inf_1m,color=0,psym=8,symsize=0.5
endif

if (t eq 2) then begin
oplot,dates2,co2_inf_1m,color=0,thick=5
plots,dates2,co2_inf_1m,color=0,psym=8,symsize=0.5
endif

oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

corr1=-50
myy=ymin+(ymax-ymin)*0.9
dy1=(ymax-ymin)/200
dy2=(ymax-ymin)/20
oplot,[-150,-120]+corr1,[myy,myy],color=50
xyouts,-100+corr1,myy-dy1,'prescribed CO!D2', charsize=0.7
if (t eq 1 or t eq 2) then begin
oplot,[-150,-120]+corr1,[myy-dy2,myy-dy2], color=0,thick=5
xyouts,-100+corr1,myy-dy2-dy1,'inferred CO!D2', charsize=0.7
endif
if (t eq 1) then begin
oplot,[-150,-120]+corr1,[myy-dy2*2,myy-dy2*2], color=250
xyouts,-100+corr1,myy-dy2*2-dy1,'inferred CO!D2!N (alternate)', charsize=0.7
endif

device,/close

endfor

endif ; end if co2 plot



if (do_lsm_plot eq 1) then begin

device,filename='lsm_time.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0


ymin=0
ymax=0.5

plot,dates2,masks_mean,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='land area',ystyle=1,xstyle=1
plots,dates2,masks_mean,psym=5

device,/close

endif ; end if co2 plot


if (do_solar_plot eq 1) then begin

for dd=0,1 do begin

device,filename='solar_time_'+strtrim(dd,2)+'.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0


ymin=1280
ymax=1380

plot,dates2,solar,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='S0 [W/m2]',ystyle=1,xstyle=1,/nodata

oplot,dates2,solar,color=0

plots,dates2,solar,psym=8,symsize=0.5,color=0

if (dd eq 1) then begin
oplot,dates2,flsol_mean(*,0)*4,color=250
endif

device,/close

endfor

endif ; end if solar plot

if (do_ice_plot eq 1) then begin

device,filename='ice_time.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0


ymin=0
ymax=0.07

plot,dates2,ice_mean,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='ice fraction',ystyle=1,xstyle=1
plots,dates2,ice_mean,psym=5

device,/close

endif ; end if ice plot


if (do_forcings_plot eq 1) then begin



for t=0,3 do begin

; t=0; individual forcings and all forcings.
; t=1; individual forcings and all forcings and inferred CO2.
; t=2; individual forcings and all forcings, for tuned parameters.
; t=3; judd partitioning

device,filename='forcings_time_'+strtrim(t,2)+'.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0


ymin=-15
ymax=15

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0

plot,dates2,f_all,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='Global Mean Forcings [W/m2]',ystyle=1,xstyle=1,/nodata


if (t eq 0 or t eq 1) then begin
oplot,dates2,f_solar,color=50,thick=3
oplot,dates2,f_co2,color=100,thick=3
oplot,dates2,f_area,color=150,thick=3
oplot,dates2,f_ice,color=200,thick=3
;loadct,0
tvlct,r_0,g_0,b_0
oplot,dates2,f_all,color=150,thick=3
plots,dates2,f_all,color=150,psym=8,symsize=0.5
;loadct,39
tvlct,r_39,g_39,b_39
endif

if (t eq 2) then begin
oplot,dates2,f_solar_tun,color=50,thick=3
oplot,dates2,f_co2_tun,color=100,thick=3
oplot,dates2,f_area_tun,color=150,thick=3
oplot,dates2,f_ice_tun,color=200,thick=3
;loadct,0
tvlct,r_0,g_0,b_0
oplot,dates2,f_all_tun,color=150,thick=3
plots,dates2,f_all_tun,color=150,psym=8,symsize=0.5
;loadct,39
tvlct,r_39,g_39,b_39
endif

if (t eq 1) then begin
oplot,dates2,f_co2_inf,color=100,thick=3,linestyle=1
endif


if (t eq 3) then begin
oplot,dates2,f_solar_jud,color=50,thick=3
oplot,dates2,f_co2_jud,color=100,thick=3
oplot,dates2,f_area_jud,color=150,thick=3
oplot,dates2,f_area_jud+f_solar_jud,color=250,thick=1,linestyle=1
oplot,dates2,f_solararea_jud,color=200,thick=1,linestyle=2

;loadct,0
tvlct,r_0,g_0,b_0
oplot,dates2,f_all_jud,color=150,thick=3
plots,dates2,f_all_jud,color=150,psym=8,symsize=0.5
;loadct,39
tvlct,r_39,g_39,b_39
endif



y1=-8
dy1=1.2
x1=-220
dx1=30
dx2=50
cs=1.0

oplot,[x1,x1+dx1],[y1,y1],color=50,thick=3
oplot,[x1,x1+dx1],[y1-(1*dy1),y1-(1*dy1)],color=100,thick=3
oplot,[x1,x1+dx1],[y1-(2*dy1),y1-(2*dy1)],color=150,thick=3
if (t ne 3) then begin
oplot,[x1,x1+dx1],[y1-(3*dy1),y1-(3*dy1)],color=200,thick=3
endif else begin
oplot,[x1,x1+dx1],[y1-(3*dy1),y1-(3*dy1)],color=250,thick=1,linestyle=1
oplot,[x1,x1+dx1],[y1-(3*dy1),y1-(3*dy1)],color=200,thick=1,linestyle=2
endelse

xyouts,x1+dx2,y1,color=50,'Solar forcing',charsize=cs
xyouts,x1+dx2,y1-(1*dy1),color=100,'CO2 forcing',charsize=cs
xyouts,x1+dx2,y1-(2*dy1),color=150,'Land surface forcing',charsize=cs
if (t ne 3) then begin
xyouts,x1+dx2,y1-(3*dy1),color=200,'Ice sheet forcing',charsize=cs
endif else begin
xyouts,x1+dx2,y1-(3*dy1),color=230,'Solar+land forcing',charsize=cs
endelse

;loadct,0
tvlct,r_0,g_0,b_0
xyouts,x1+dx2,y1-(4*dy1),color=150,'All forcings',charsize=cs
oplot,[x1,x1+dx1],[y1-(4*dy1),y1-(4*dy1)],color=150,thick=3
plots,x1+dx1/2.0,y1-(4*dy1),psym=8,symsize=0.5,color=150

;loadct,39
tvlct,r_39,g_39,b_39

oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

device,/close

endfor

endif ; end if forcings plot




if (do_forctemps_plot eq 1) then begin
print,'forctemp plot'

; t=0; individual forctemps and all forctemps.
; t=1; individual forctemps and all forctemps. and inferred CO2.
; t=2; anom forctemps.


for t=0,2 do begin

device,filename='forctemps_time_'+strtrim(t,2)+'.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0

if (t eq 0 or t eq 1) then begin
ymin=5
ymax=40
endif
if (t eq 2) then begin
ymin=-14
ymax=14
endif


topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0

plot,dates2,f_all,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='Global Mean Temperatures [oC]',ystyle=1,xstyle=1,/nodata

if (t eq 0 or t eq 1) then begin
plots,dates2,climav(*,pe,0),psym=8,symsize=0.5
oplot,dates2,temp_solar,color=50,thick=3
oplot,dates2,temp_co2,color=100,thick=3
oplot,dates2,temp_area,color=150,thick=3
oplot,dates2,temp_ice,color=200,thick=3
oplot,dates2,temp_resid,color=250,thick=3
oplot,dates2,temp_all_tun,color=0,thick=3
endif

if (t eq 1) then begin
oplot,dates2,f_co2_inf,color=100,thick=3,linestyle=1
endif

if (t eq 2) then begin
oplot,dates2,temp_solar_anom,color=50,thick=3
oplot,dates2,temp_co2_anom,color=100,thick=3
oplot,dates2,temp_area_anom,color=150,thick=3
oplot,dates2,temp_ice_anom,color=200,thick=3
oplot,dates2,temp_all_tun_anom,color=0,thick=3
;oplot,dates2,temp_resid_anom,color=250,thick=3
endif


if (t eq 0 or t eq 1) then begin
y1=12
endif
if (t eq 2) then begin
y1=-6
endif

dy1=1.2
x1=-220
dx1=30
dx2=50
cs=1.0



if (t eq 0 or t eq 1) then begin
plots,x1+dx1/2.0,y1+(1*dy1),psym=8,symsize=0.5
oplot,[x1,x1+dx1],[y1-(4*dy1),y1-(4*dy1)],color=250,thick=3
endif
oplot,[x1,x1+dx1],[y1,y1],color=50,thick=3
oplot,[x1,x1+dx1],[y1-(1*dy1),y1-(1*dy1)],color=100,thick=3
oplot,[x1,x1+dx1],[y1-(2*dy1),y1-(2*dy1)],color=150,thick=3
oplot,[x1,x1+dx1],[y1-(3*dy1),y1-(3*dy1)],color=200,thick=3
;oplot,[x1,x1+dx1],[y1-(4*dy1),y1-(4*dy1)],color=250,thick=3
oplot,[x1,x1+dx1],[y1-(5*dy1),y1-(5*dy1)],color=0,thick=3



if (t eq 0 or t eq 1) then begin
xyouts,x1+dx2,y1+(1*dy1),'HadCM3L ['+exproot(0,pe)+']',charsize=cs
xyouts,x1+dx2,y1-(4*dy1),color=250,'Residual temp',charsize=cs
endif
xyouts,x1+dx2,y1,color=50,'Solar temp',charsize=cs
xyouts,x1+dx2,y1-(1*dy1),color=100,'CO2 temp',charsize=cs
xyouts,x1+dx2,y1-(2*dy1),color=150,'Land surface temp',charsize=cs
xyouts,x1+dx2,y1-(3*dy1),color=200,'Ice sheet temp',charsize=cs
;xyouts,x1+dx2,y1-(4*dy1),color=250,'Residual temp',charsize=cs
xyouts,x1+dx2,y1-(5*dy1),color=0,'All temps',charsize=cs



oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

device,/close

endfor

endif ; end if forctemp plot


if (do_clim_plot eq 1) then begin

; GMST PLOT

; new is tfke and forcing-feedback
; cmp is tfke and tfks
; pro is tfke and ScoteseSmoothed and Winghuber
; bot is tfke and tfks and ScoteseSmoothed and Winghuber
; egu is tfke and tfks and ScoteseSmoothed
; pap is tfke and ScoteseSmoothed and Winghuber and Judd
; cmo is tfke and Scotese02

ntype=7
mytypename=['new','cmp','pro','bot','egu','pap','cmo']

colwin=80
coljud=200
colsco=250
mycol=0
mycot=210

for t=0,ntype-1 do begin
for v=0,nvar-1 do begin

device,filename='clim_'+climnamelong(v)+'_'+mytypename(t)+'_time.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0

ymin=yminc(v)
ymax=ymaxc(v)

if ((t eq 2 or t eq 3 or t eq 4 or t eq 5) and v eq 0) then begin
ymin=5
ymax=40
endif

if ((t eq 0) and v eq 0) then begin
ymin=9
ymax=27
endif

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0


plot,dates2,climav(*,0,v),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',psym=2,/nodata,ytitle=climnametitle(v)+' [degrees C]',ystyle=1,xstyle=1

if (t eq 5) then begin
br=240
co=255
;tvlct,r_0,g_0,b_0
tvlct,[br,co],[br,br],[co,br],0

for n=nstart,ndates-1 do begin

if (climav(n,pe,v) lt min([temp_scot1m_interp(n),temp_wing_interp(n),temp_judd_interp(n)])) then begin
polyfill,[dates2edge(n),dates2edge(n+1),dates2edge(n+1),dates2edge(n)],[topbar,topbar,ymin,ymin],color=0
endif

if (climav(n,pe,v) gt max([temp_scot1m_interp(n),temp_wing_interp(n),temp_judd_interp(n)])) then begin
polyfill,[dates2edge(n),dates2edge(n+1),dates2edge(n+1),dates2edge(n)],[topbar,topbar,ymin,ymin],color=1
endif

endfor

tvlct,r_39,g_39,b_39
axis,yrange=[ymin,ymax],xrange=[xmin,xmax],ystyle=1,xstyle=1,yaxis=0
axis,yrange=[ymin,ymax],xrange=[xmin,xmax],ystyle=1,xstyle=1,yaxis=1
axis,yrange=[ymin,ymax],xrange=[xmin,xmax],ystyle=1,xstyle=1,xaxis=0
endif



;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

x=n-nstart
xx=ndates-nstart
;mycol=(x)*250.0/(xx-1)
;mycol=0


if (t eq 1) then begin
; plot non-pe model points
for e=0,nexp-1 do begin
if (e ne pe) then begin
plots,dates2(n),climav(n,e,v),color=colexp(e),psym=5,symsize=0.5
endif
endfor
endif

if (t eq 6) then begin
; plot scotese02 model points
for e=0,nexp-1 do begin
if (e eq ps) then begin
plots,dates2(n),climav(n,e,v),color=colexp(e),psym=8,symsize=0.5
endif
endfor
endif

; plot hadcm3l (pe) points
plots,dates2(n),climav(n,pe,v),color=mycol,psym=8,symsize=0.5

if (t eq 3 or t eq 4) then begin
; plot tuned points
plots,dates2(n),climav(n,pt,v),color=mycot,psym=6,symsize=0.5
endif

if (t eq 1 or t eq 0) then begin
;xyouts,dates2(n)+5,climav(n,pe,v)+0.1,exproot(n,e)+exptail(n,e),charsize=0.2
endif

endfor ; end n

; plot non-pe curve
if (t eq 1) then begin
for e=0,nexp-1 do begin
if (e ne pe) then begin
oplot,dates2(*),climav(*,e,v),thick=3,color=colexp(e)
endif
endfor
endif

; plot scotese02 runs
if (t eq 6) then begin
for e=0,nexp-1 do begin
if (e eq ps) then begin
oplot,dates2(*),climav(*,e,v),thick=3,color=colexp(e)
endif
endfor
endif

; plot hadcm3l (pe) curve
oplot,dates2(*),climav(*,pe,v),thick=3,color=mycol

if (t eq 3 or t eq 4) then begin
; plot tuned curve
oplot,dates2(*),climav(*,pt,v),thick=3,color=mycot
endif


if (v eq 0 and t eq 0) then begin
;oplot,dates2(*),temp_all_lin(*),color=200,thick=3
;oplot,dates2(*),temp_all(*),color=100
;loadct,0
tvlct,r_0,g_0,b_0
oplot,dates2(*),temp_all_tun(*),color=150,thick=3
;loadct,39
tvlct,r_39,g_39,b_39

;xyouts,-500,13,'Forcing/feedback model [non-tuned]'
;oplot,[-510,-530],[13,13],color=200,thick=3

xyouts,-500,10,'Forcing/feedback model'
;loadct,0
tvlct,r_0,g_0,b_0
oplot,[-510,-530],[10,10],color=150,thick=3
;loadct,39
tvlct,r_39,g_39,b_39
endif

if (v eq 0 and t eq 2) then begin
;plots,dates_scot,temp_scot,psym=8,symsize=0.5,color=colsco
oplot,dates_scot1m,temp_scot1m,color=colsco,thick=3
;oplot,dates_scot,temp_scot,color=colsco,thick=3

;plots,dates_wing,temp_wing,psym=8,symsize=0.5,color=colwin
oplot,dates_wing,temp_wing,color=colwin,thick=3
endif

if (v eq 0 and t eq 3) then begin
;plots,dates_scot,temp_scot,psym=8,symsize=0.5,color=colsco
oplot,dates2,temp_scot1m_interp,color=colsco,thick=3

;plots,dates_wing,temp_wing,psym=8,symsize=0.5,color=colwin
oplot,dates_wing,temp_wing,color=colwin,thick=3
endif

if (v eq 0 and t eq 4) then begin
;plots,dates_scot,temp_scot,psym=8,symsize=0.5,color=colsco
oplot,dates2,temp_scot1m_interp,color=colsco,thick=3

;plots,dates_wing,temp_wing,psym=8,symsize=0.5,color=colwin
;oplot,dates_wing,temp_wing,color=colwin,thick=3
endif

if (v eq 0 and t eq 5) then begin
; for paper
oplot,dates2,temp_scot1m_interp,color=colsco,thick=3
oplot,dates_wing,temp_wing,color=colwin,thick=3
oplot,dates_judd,temp_judd,color=coljud,thick=3
endif


if (t eq 1) then begin
for e=0,nexp-1 do begin
if (e ne pe) then begin
xyouts,-500,13+e*1.0,exproot(0,e)
plots,-520,13+e*1.0,psym=5,color=colexp(e)
endif
endfor
endif

if (t eq 1 or t eq 0) then begin
xyouts,-500,12,'HadCM3L ['+exproot(0,pe)+']'
plots,-520,12,psym=8,symsize=0.5
oplot,[-510,-530],[12,12],thick=3
endif

if (v eq 0 and (t eq 2 or t eq 3 or t eq 4 or t eq 5 or t eq 6)) then begin


x1=-300
y1=8
if (t eq 5 or t eq 6) then begin
x1=-230
y1=10
endif
dx1=40
dx2=50
dy1=1.5
dy2=0.5

oplot,[x1,x1+dx1],[y1+dy1,y1+dy1],color=0,thick=3
;plots,x1+dx1/2.0,y1,psym=8,symsize=0.5,color=colsco
xyouts,x1+dx2,y1+dy1-dy2,'HadCM3L ['+exproot(0,pe)+']',color=0
plots,x1+dx1/2.0,y1+dy1,color=mycol,psym=8,symsize=0.5
;plots,-520,12,psym=6,symsize=0.5

if (t ne 6) then begin
oplot,[x1,x1+dx1],[y1,y1],color=colsco,thick=3
;plots,x1+dx1/2.0,y1,psym=8,symsize=0.5,color=colsco
endif

if (t ne 6) then begin
if (t ne 5) then begin
xyouts,x1+dx2,y1-dy2,'Scotese et al (2021) [smoothed]',color=colsco
endif else begin
xyouts,x1+dx2,y1-dy2,'Scotese et al (2021)',color=colsco
endelse
endif

if (t ne 6) then begin
if (t ne 4) then begin
oplot,[x1,x1+dx1],[y1-dy1,y1-dy1],color=colwin,thick=3
;plots,x1+dx1/2.0,y1-dy1,psym=8,symsize=0.5,color=colwin
xyouts,x1+dx2,y1-dy1-dy2,'Wing and Huber (2020)',color=colwin
endif
endif

if (t eq 3 or t eq 4) then begin
oplot,[x1,x1+dx1],[y1+2*dy1,y1+2*dy1],color=mycot,thick=3
;plots,x1+dx1/2.0,y1,psym=8,symsize=0.5,color=colsco
xyouts,x1+dx2,y1+2*dy1-dy2,'HadCM3L ['+exproot(0,pt)+']',color=mycot
plots,x1+dx1/2.0,y1+dy1,color=mycot,psym=8,symsize=0.5
endif

if (t eq 5) then begin
oplot,[x1,x1+dx1],[y1-dy1,y1-dy1],color=colwin,thick=3
xyouts,x1+dx2,y1-dy1-dy2,'Wing and Huber (2020)',color=colwin
oplot,[x1,x1+dx1],[y1-2*dy1,y1-2*dy1],color=coljud,thick=3
xyouts,x1+dx2,y1-2*dy1-dy2,'Judd et al (in press)',color=coljud
endif

if (t eq 6) then begin
oplot,[x1,x1+dx1],[y1,y1],color=colexp(ps),thick=3
xyouts,x1+dx2,y1-dy2,'Valdes et al (2021)',color=colexp(ps)
endif


endif


oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

device,/close


endfor
endfor


if (do_scattemp_plot eq 1) then begin

device,filename='scattemp_time.eps',/encapsulate,/color,set_font='Helvetica',xsize=14,ysize=12

xmin=8
xmax=30

ymin=8
ymax=30

plot,temp_scot1m_interp,climav(*,pe,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='GMST, Scotese et al',ytitle='Modelled GMST',ystyle=1,xstyle=1,/nodata

plots,temp_scot1m_interp,climav(*,pe,0),psym=8,symsize=0.5
plots,temp_scot1m_interp,climav(*,pt,0),psym=8,symsize=0.5,color=mycot

oplot,[xmin,xmax],[ymin,ymax],color=0

myyy=ymin+(ymax-ymin)*0.9
myxx=xmin+(xmax-xmin)*0.1
mydy=1.5
mydy2=0.2
mydx=0.5
plots,myxx,myyy,psym=8,color=0,symsize=0.5
plots,myxx,myyy-mydy,psym=8,color=mycot,symsize=0.5
xyouts,myxx+mydx,myyy-mydy2,'Untuned'
xyouts,myxx+mydx,myyy-mydy-mydy2,'Tuned',color=mycot


endif



if (do_climsens_plot eq 1) then begin

; GMST PLOT


tempdiff=fltarr(ndates)
co2diff=fltarr(ndates)
co2forcing=fltarr(ndates)
climsens=fltarr(ndates)


tempdiff(*)=climav(*,pt,0)-climav(*,pe,0)
co2diff(*)=co2_inf_1m-co2
co2forcing(*)=alog(co2_inf_1m/co2)/alog(2.0)
climsens(*)=tempdiff/co2forcing


device,filename='climsens_time.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0

ymin=0
ymax=12

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0


plot,dates2,climsens(*),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',psym=2,/nodata,ytitle='Clim sens [degrees C]',ystyle=1,xstyle=1


; plot non-pe curve
oplot,dates2(*),climsens(*),thick=1,color=0

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

if (abs(co2forcing(n)) lt 0.25) then begin
ccol=250
endif else begin
ccol=130
endelse


plots,dates2(n),climsens(n),color=ccol,psym=8,symsize=0.7

endfor ; end n




oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

device,/close

endif

if (do_grads_plot eq 1) then begin

; Grads PLOT

device,filename='grads_time.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

nbar=100
nlevv=21
maxv=40
minv=-40
mybarv=fltarr(nbar,2)
mybarv(*,0)=minv+(maxv-minv)*findgen(nbar)/(nbar-1.0)
mybarv(*,1)=mybarv(*,0)
mylevsv=minv+(maxv-minv)*findgen(nlevv)/(nlevv-1.0)

xmin=-550
xmax=0

ymin=-90
ymax=90

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0

;plot,dates2,climsens(*),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',psym=2,/nodata,ytitle='Zonal mean temperature [degrees C]',ystyle=1,xstyle=1

contour,transpose(grads(*,*,pe,0)-273.15),dates2,lats,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='Latitude',ystyle=1,xstyle=1,/cell_fill,levels=mylevsv,position=[0.1,0.25,0.95,0.95]

oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

contour,mybarv,mybarv(*,0),[0,1],levels=mylevsv,/fill,position=[0.15,0.1,0.95,0.15],/noerase,xstyle=1,xrange=[minv,maxv],ystyle=4,xtickv=[-40,-32,-24,-16,-8,0,8,16,24,32,40],xticks=10
xyouts,0.5,-1.5,'Zonal mean temperature [degrees C]',align=0.5

device,/close

endif


; plot the residual

v=0

device,filename='resid_'+climnamelong(v)+'_time.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0
ymin=yminr(v)
ymax=ymaxr(v)

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0

plot,dates2,climav(*,1,v),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',psym=2,/nodata,ytitle='Temperature [degrees C]',title=climnametitle(v)+' residual',ystyle=1,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

x=n-nstart
xx=ndates-nstart
;mycol=(x)*250.0/(xx-1)
mycol=0

plots,dates2(n),resid(n),color=mycol,psym=8,symsize=0.5
;xyouts,dates2(n)+5,resid(n)+0.05,exproot(n,1)+exptail(n,1),charsize=0.2

endfor ; end n

oplot,dates2(*),resid,thick=3

oplot,[dates2(0),dates2(nstart-1)],[0,0],linestyle=2

xyouts,-500,-2.5,'HadCM3L ['+exproot(0,pe)+']'
plots,-520,-2.5,psym=8,symsize=0.5

oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor


device,/close

endif


if (do_polamp_plot eq 1) then begin

for v=0,nvar-1 do begin

device,filename='polamp_'+climnamelong(v)+'_time.eps',/encapsulate,/color,set_font='Helvetica',xsize=7,ysize=5,/inches

xmin=-550
xmax=0


ymin=yminp(v)
ymax=ymaxp(v)


topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0


plot,dates2,climav(*,1,v),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',psym=2,/nodata,ytitle='Temperature Gradient [degrees C]',title=climnametitle(v)+' meridional gradient',ystyle=1,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)
;mycol=0

plots,dates2(n),polamp(n,pe,v),color=mycol,psym=8,symsize=0.5
;xyouts,dates2(n)+5,polamp(n,pe,v)+0.05,exproot(n,1)+exptail(n,1),charsize=0.2

endfor ; end n

for n=nstart,ndates-2 do begin
x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)
oplot,[dates2(n),dates2[n+1]],[polamp(n,pe,v),polamp(n+1,pe,v)],thick=3,color=mycol
endfor


;plot,[dates2(0),dates2(nstart-1)],[0,0],linestyle=2

xyouts,-500,yminp(v)+0.8*(ymaxp(v)-yminp(v)),'HadCM3L ['+exproot(0,pe)+']'
plots,-520,yminp(v)+0.8*(ymaxp(v)-yminp(v)),psym=8,symsize=0.5


tvlct,r_cgmw,g_cgmw,b_cgmw
for n=0,nstage-1 do begin
polyfill,[stageb(n),stageb(n+1),stageb(n+1),stageb(n)],[ymax,ymax,topbar,topbar],color=n
endfor
tvlct,r_39,g_39,b_39

oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor



for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

device,/close

endfor


for v=0,nvar*2 do begin

device,filename='polampxtemp_'+climnamelongx(v)+'_scatter.eps',/encapsulate,/color,set_font='Helvetica'

if (v eq 0 or v eq 1) then begin
xmin=yminc(v)
xmax=ymaxc(v)
ymin=yminp(v)
ymax=ymaxp(v)
endif

if (v eq 2) then begin
xmin=min(yminc(0))
xmax=max(ymaxc(0))
ymin=min(yminc(1))
ymax=max(ymaxc(1))
endif

if (v eq 3) then begin
xmin=min(yminp(0))
xmax=max(ymaxp(0))
ymin=min(yminp(1))
ymax=max(ymaxp(1))
endif

if (v eq 4) then begin
xmin=min(yminc(0:nvar-1))
xmax=max(ymaxc(0:nvar-1))
ymin=min(yminp(0:nvar-1))
ymax=max(ymaxp(0:nvar-1))
endif

plot,climav(*,pe,0),polamp(*,pe,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='global mean',psym=2,/nodata,ytitle='meridional gradient [degrees C]',title=climnametitlex(v)+' ['+exproot(0,pe)+']',ystyle=1,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)
;mycol=0

;climnamelongx(*)=['temp-tempp','sst-sstp','temp-sst','tempp-sstp','all']

if (v eq 0 or v eq 1) then begin
   plots,climav(n,pe,v),polamp(n,pe,v),color=mycol,psym=8,symsize=1.5
;xyouts,climav(n,pe,v)+5,polamp(n,pe,v)+0.05,exproot(n,1)+exptail(n,1),charsize=0.2
endif
if (v eq 2) then begin
   plots,climav(n,pe,0),climav(n,pe,1),color=mycol,psym=8,symsize=1.5
endif
if (v eq 3) then begin
   plots,polamp(n,pe,0),polamp(n,pe,1),color=mycol,psym=8,symsize=1.5
endif
if (v eq 4) then begin
   for vv=0,nvar-1 do begin
   plots,climav(n,pe,vv),polamp(n,pe,vv),color=mycol,psym=8,symsize=((1-vv)+1.0)/2.0
   endfor
   oplot,[climav(n,pe,0),climav(n,pe,1)],[polamp(n,pe,0),polamp(n,pe,1)],color=mycol,linestyle=1
endif

ddy=0.001*(ymax-ymin)
fy=0.05*(ymax-ymin)
sy=ymin+0.3*(ymax-ymin)
sx1=xmin+0.1*(xmax-xmin)
sx2=xmin+0.13*(xmax-xmin)

if (n eq 0) then begin
plots,+sx1,sy,color=mycol,psym=8,symsize=1.5
xyouts,+sx2,sy-ddy,color=0,'0 Ma'
endif
if (n eq 20) then begin
plots,+sx1,sy-1*fy,color=mycol,psym=8,symsize=1.5
xyouts,+sx2,sy-1*fy-ddy,color=0,'100 Ma'
endif
if (n eq 40) then begin
plots,+sx1,sy-2*fy,color=mycol,psym=8,symsize=1.5
xyouts,+sx2,sy-2*fy-ddy,color=0,'200 Ma'
endif
if (n eq 60) then begin
plots,+sx1,sy-3*fy,color=mycol,psym=8,symsize=1.5
xyouts,+sx2,sy-3*fy-ddy,color=0,'300 Ma'
endif
if (n eq 80) then begin
plots,+sx1,sy-4*fy,color=mycol,psym=8,symsize=1.5
xyouts,+sx2,sy-4*fy-ddy,color=0,'400 Ma'
endif
if (n eq 100) then begin
plots,+sx1,sy-5*fy,color=mycol,psym=8,symsize=1.5
xyouts,+sx2,sy-5*fy-ddy,color=0,'500 Ma'
endif

endfor ; end n




device,/close

endfor



endif


if (do_ess_plot eq 1) then begin

ptf=1.0
;ptf=2.0

nt=9
xtit=strarr(nt)
ytit=strarr(nt)
ltit=strarr(nt)
xtit(*)=['CO2 (Foster, prescribed in model)','CO2 (inferred from Scotese GMST, prescribed in model)','CO2 (Foster, prescribed in model) + S0','CO2 (Foster, prescribed in model) + S0 + continent + ice','CO2 (Foster, prescribed in model) + S0 + continent','CO2 (Scotese, incorrect) + S0 + continent','CO2 (Foster, prescribed in model) + S0 + continent + ice + missing forcing','CO2 (Foster, prescribed in model) + S0 + continent + error','CO2 (Foster, prescribed in model) + error']
ytit(*)=['Modelled GMST, tfke','Modelled GMST, tfks','Modelled GMST, tfke','Modelled GMST, tfke','Modelled GMST, tfke','Modelled GMST, tfke','Modelled GMST, tfke','Modelled GMST, tfke, + error','Modelled GMST, tfke, + error']
ltit(*)=['Forcing versus temp']

for t=0,nt-1 do begin

device,filename='ess_co2_temp_'+strtrim(t,2)+'.eps',/encapsulate,/color,set_font='Helvetica',xsize=14,ysize=12

xmin=-1
xmax=6

ymin=0
ymax=50

plot,temp_scot1m_interp,climav(*,pe,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle=xtit(t),ytitle=ytit(t),ystyle=1,xstyle=1,/nodata,xticks=7,xtickv=[-1,0,1,2,3,4,5,6],xtickname=['140','280','560','1120','2240','4480','8960','17920']

if (t eq 0) then begin
thisxf=alog(co2/280.0)/alog(2.0)
;thisy=climav(*,pe,0)
thisy=14+(climav(*,pe,0)-14)*ptf
endif

if (t eq 1) then begin
thisxf=alog(co2_inf_1m/280.0)/alog(2.0)
;thisy=climav(*,pt,0)
thisy=14+(climav(*,pe,0)-14)*ptf
endif

if (t eq 2) then begin
thisxf=alog(co2/280.0)/alog(2.0) + t_solar_tun*((1.0-c_alb)*(solar-mean(solar))/4.0)/c_co2
;thisy=climav(*,pe,0)
thisy=14+(climav(*,pe,0)-14)*ptf
endif

if (t eq 3) then begin
thisxf=alog(co2/280.0)/alog(2.0) + t_solar_tun*((1.0-c_alb)*(solar-mean(solar))/4.0)/c_co2 + t_area_tun*(solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0)/c_co2 + t_ice_tun*(solar*(-1.0)*(ice_mean-ice_mean(baseline))*c_dice/4.0)/c_co2
;thisy=climav(*,pe,0)
thisy=14+(climav(*,pe,0)-14)*ptf
endif

if (t eq 4) then begin
thisxf=alog(co2/280.0)/alog(2.0) + t_solar_tun*((1.0-c_alb)*(solar-mean(solar))/4.0)/c_co2 + t_area_tun*(solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0)/c_co2
;thisy=climav(*,pe,0)
thisy=14+(climav(*,pe,0)-14)*ptf
endif

if (t eq 5) then begin
thisxf=alog(co2_inf_1m/280.0)/alog(2.0) + t_solar_tun*((1.0-c_alb)*(solar-mean(solar))/4.0)/c_co2 + t_area_tun*(solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0)/c_co2
;thisy=climav(*,pe,0)
thisy=14+(climav(*,pe,0)-14)*ptf
endif

if (t eq 6) then begin
thisxf=alog(co2/280.0)/alog(2.0) + t_solar_tun*((1.0-c_alb)*(solar-mean(solar))/4.0)/c_co2 + t_area_tun*(solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0)/c_co2 + t_ice_tun*(solar*(-1.0)*(ice_mean-ice_mean(baseline))*c_dice/4.0)/c_co2 - resid*lambda_tun/c_co2
;thisy=climav(*,pe,0)
thisy=14+(climav(*,pe,0)-14)*ptf
endif

if (t eq 7) then begin
thisxf=alog(co2/280.0)/alog(2.0)+0.5*randomn(1.0,ndates) + t_solar_tun*((1.0-c_alb)*(solar-mean(solar))/4.0)/c_co2 + t_area_tun*(solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0)/c_co2
;thisy=climav(*,pe,0)
thisy=14+(climav(*,pe,0)-14)*ptf+3.0*randomn(2.0,ndates)
endif

if (t eq 8) then begin
thisxf=alog(co2/280.0)/alog(2.0)+0.5*randomn(1.0,ndates)
;thisy=climav(*,pe,0)
thisy=14+(climav(*,pe,0)-14)*ptf+3.0*randomn(2.0,ndates)
endif

for n=nstart,ndates-1 do begin
x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)
;mycol=0
plots,thisxf(n),thisy(n),psym=8,symsize=0.5,color=mycol
;xyouts,thisxf(n),thisy(n),exproot(n,1)+exptail(n,1),charsize=0.2
endfor ; end n

myessresult=linfit(thisxf,thisy,sigma=mysigma)
print,'myessresult:'
print,myessresult
print,mysigma

oplot,[xmin,xmax],[myessresult(0)+xmin*myessresult(1),myessresult(0)+xmax*myessresult(1)]



myyy=ymin+(ymax-ymin)*0.9
myxx=xmin+(xmax-xmin)*0.1
mydy=(ymax-ymin)*0.05
mydy2=(ymax-ymin)*0.01
mydx=(xmax-xmin)*0.02
plots,myxx,myyy,psym=8,color=0,symsize=0.5
xyouts,myxx+mydx,myyy-0*mydy-mydy2,ltit(t)
xyouts,myxx+mydx,myyy-1*mydy-mydy2,string(myessresult(1), format = '(f4.2)')
xyouts,myxx+mydx,myyy-2*mydy-mydy2,string(mysigma(1), format = '(f4.2)')


device,/close

endfor


nessf=7
ftit=strarr(nessf)
ftit(*)=['temp vs. CO2','temp vs. CO2+solar','temp vs. CO2+solar+area+ice','temp vs. CO2+solar+area+ice+resid','temp vs. CO2','temp vs. CO2+solar','temp vs. CO2+solar+area']

for t=0,nessf-1 do begin

device,filename='ess_forcings_'+strtrim(t,2)+'.eps',/encapsulate,/color,set_font='Helvetica',xsize=14,ysize=12

xmin=-1
xmax=6

ymin=0
ymax=50

plot,temp_scot1m_interp,climav(*,pe,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='forcing',ytitle='GMST',ystyle=1,xstyle=1,/nodata

if (t eq 0) then begin
thisxf=f_co2_tun/c_co2 ; THIS ONE IS IDENTICAL TO _0, ; i.e. co2 forcing only 
thisy=climav(*,pe,0)
nndates=ndates
endif

if (t eq 1) then begin
thisxf=f_co2_tun/c_co2 + (f_solar_tun-mean(f_solar_tun))/c_co2 ; this one is identical to _2, i.e. co2 and solar forcing only
thisy=climav(*,pe,0)
nndates=ndates
endif

if (t eq 2) then begin
thisxf=f_co2_tun/c_co2 + (f_solar_tun-mean(f_solar_tun))/c_co2 + (f_area_tun-mean(f_area_tun))/c_co2 + (f_ice_tun-mean(f_ice_tun))/c_co2 ; this one is identical to _3, i.e. all the explained forcings
thisy=climav(*,pe,0)
nndates=ndates
endif

if (t eq 3) then begin
thisxf=f_co2_tun/c_co2 + (f_solar_tun-mean(f_solar_tun))/c_co2 + (f_area_tun-mean(f_area_tun))/c_co2 + (f_ice_tun-mean(f_ice_tun))/c_co2 - resid*lambda_tun/c_co2 ; this one is a straight line.
thisy=climav(*,pe,0)
nndates=ndates
endif


njm=97

if (t eq 4) then begin
thisxf=f_co2_jud(0:njm-1)/c_co2
thisy=temp_judd_interp(0:njm-1)
nndates=njm
endif

if (t eq 5) then begin
thisxf=f_co2_jud(0:njm-1)/c_co2 + (f_solar_jud(0:njm-1)-mean(f_solar_jud(0:njm-1)))/c_co2
thisy=temp_judd_interp(0:njm-1)
nndates=njm
endif

if (t eq 6) then begin
thisxf=f_co2_jud(0:njm-1)/c_co2 + (f_solar_jud(0:njm-1)-mean(f_solar_jud(0:njm-1)))/c_co2 + (f_area_jud(0:njm-1)-mean(f_area_jud(0:njm-1)))/c_co2
thisy=temp_judd_interp(0:njm-1)
nndates=njm
endif



for n=nstart,nndates-1 do begin
x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)
;mycol=0
plots,thisxf(n),thisy(n),psym=8,symsize=0.5,color=mycol
;xyouts,thisxf(n),thisy(n),exproot(n,1)+exptail(n,1),charsize=0.2
endfor ; end n

myessresult=linfit(thisxf,thisy,sigma=mysigma)
print,'myessresult:'
print,myessresult
print,mysigma

oplot,[xmin,xmax],[myessresult(0)+xmin*myessresult(1),myessresult(0)+xmax*myessresult(1)]

myyy=ymin+(ymax-ymin)*0.9
myxx=xmin+(xmax-xmin)*0.1
mydy=(ymax-ymin)*0.05
mydy2=(ymax-ymin)*0.01
mydx=(xmax-xmin)*0.02
plots,myxx,myyy,psym=8,color=0,symsize=0.5
xyouts,myxx+mydx,myyy-0*mydy-mydy2,ftit(t)
xyouts,myxx+mydx,myyy-1*mydy-mydy2,string(myessresult(1), format = '(f4.2)')
xyouts,myxx+mydx,myyy-2*mydy-mydy2,string(mysigma(1), format = '(f4.2)')


device,/close
endfor


endif


if (do_textfile1 eq 1) then begin

openw,1,'temp_all.dat'
printf,1,'Wing and Huber:'
for n=0,nrows_wing-1 do begin
printf,1,dates_wing(n),temp_wing(n)
endfor
printf,1,'Scotese:'
for n=0,nrows_scot-1 do begin
printf,1,dates_scot(n),temp_scot(n)
endfor
printf,1,'HadCM3L:'
for n=nstart,ndates-1 do begin
printf,1,dates2(n),climav(n,1,0)
endfor

close,1

endif

if (do_textfile2 eq 1) then begin

openw,1,'temp_chris.dat'
for n=0,ndates-1 do begin
printf,1,dates2(n),temp_scot1m_interp(n)
endfor
close,1

endif

if (do_textfile3 eq 1) then begin

openw,1,'fluxes_emily.dat'
for n=0,ndates-1 do begin
printf,1,dates2(n),flsol_mean(n,*),format='(f0," ",3(" ",f0))'
endfor
close,1

endif

if (do_textfile4 eq 1) then begin

openw,1,'forcings_emily.dat'

printf,1,'dates C S L GMST'
for n=0,ndates-1 do begin
printf,1,dates2(n),co2(n),solar(n),masks_mean(n),temp_judd_interp(n),format='(f0," ",4(" ",f0))'
endfor



close,1

endif


;;;;;
; Numbers for paper:
print,'** FOR PAPER**  HIGHEST MODEL TEMP IS: '+strtrim(max(climav(nstart:ndates-1,pe,0),ind),2)
print,dates2(ind)
print,'** FOR PAPER**  LOWEST MODEL TEMP IS: '+strtrim(min(climav(nstart:ndates-1,pe,0),ind),2)
print,dates2(ind)
print,'** FOR PAPER**  MEAN MODEL TEMP IS: '+strtrim(mean(climav(nstart:ndates-1,pe,0)),2)
print,'** FOR PAPER**  MODERN MODEL TEMP IS: '+strtrim(climav(nstart,pe,0),2)


stop

end
