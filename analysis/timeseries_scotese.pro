pro time

set_plot,'ps'
!P.FONT=0

loadct,39

Aaa = FINDGEN(17) * (!PI*2/16.)  
USERSYM, COS(Aaa), SIN(Aaa), /FILL 

; times
do_times=0 ; if 0 then only read in most recent simulations, for speed
do_timeseries_plot=0 ; plot global mean SST timeseries of each simulation
do_gmst_plot=0 ; plot last navy years of SST through phanerozoic

;means
do_clims=1 ; read in and analyse model output
do_readbounds=1 ; read in mask and ice
do_ff_model=1 ; forcing/feedback model
do_temp_plot=1 ; global mean from proxies
do_co2_plot=1 ; prescribed co2
do_lsm_plot=0 ; prescribed land area
do_solar_plot=0 ; prescribed solar forcing
do_ice_plot=0 ; prescribed ice sheets
do_forcings_plot=0 ; prescribed forcings in Wm-2
do_forctemps_plot=0 ; prescribed forcings in oC
do_polamp_plot=0 ;  plot polamp
do_clim_plot=1 ;  plot new vs old, EBM, MDC, and resid
do_textfile=0 ; textfile of proxies for Emily
do_textfile2=0 ; textfile of proxies for Chris


;;;;
; Total number of time snapshots
ndates=109
nexp=6
tmax=4000
nstart=0
;;;;

;;;;
; for timeseries to save time
writing=intarr(ndates,nexp)
writing(*,0)=0
writing(*,1)=0
writing(*,2)=0
writing(*,3)=0
writing(*,4)=0
writing(*,5)=0

reading=intarr(ndates,nexp)
reading(*,0)=1-writing(*,0)
reading(*,1)=1-writing(*,1)
reading(*,2)=1-writing(*,2)
reading(*,3)=1-writing(*,3)
reading(*,4)=1-writing(*,4)
reading(*,5)=1-writing(*,4)

readfile=intarr(ndates,nexp) ; does clim data exist for this simulation?
if (do_times eq 1) then begin
readfile(*,0)=1
readfile(*,1)=1
readfile(*,2)=1
readfile(*,3)=1
readfile(*,4)=1
readfile(*,5)=1
endif else begin
readfile(*,0)=0
readfile(*,1)=0
readfile(*,2)=0
readfile(*,3)=0
readfile(*,4)=1
readfile(*,5)=1
; missing tfks files
tfks_missing=[12,21,49,51]-1
readfile(tfks_missing,5)=0
endelse

readtype=intarr(ndates,nexp) ; um_climates [0] or ummodel [1] for clims
readtype(*,0)=1
readtype(*,1)=1
readtype(*,2)=1
readtype(*,3)=1
readtype(*,4)=1
readtype(*,5)=1


locdata=intarr(ndates,nexp) ; um_climates [1] or ummodel [0] for timeseries
locdata(*,0)=0
locdata(*,1)=0
locdata(*,2)=0
locdata([16,39,50,59,66,68],2)=1 ; jaq,jAn,jAy,Jah,Jao,Jaq
locdata(*,3)=0
locdata(*,4)=0
locdata(*,5)=0


co2file=strarr(nexp)
co2file(0)='co2_all_02'
co2file(1)='co2_all_02'
co2file(2)='co2_all_03_nt'
co2file(3)='co2_all_02'
co2file(4)='co2_all_03_nt'
co2file(5)='co2_all_04_nt'

colexp=intarr(nexp)
colexp(0)=50
colexp(1)=100
colexp(2)=150
colexp(3)=200
colexp(4)=0
colexp(5)=250



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

for e=1,nexp-1 do begin
exptail(*,e)=exptail(*,0)
endfor
exptail2(*,0)=''
exptail2(*,1)=''
exptail2(*,2)=''
exptail2(*,3)='3'
exptail2(*,4)=''
exptail2(*,5)=''


; which set of simulations to plot and analyse
pe=4

varname=strarr(ndates,nexp)
varname(*,0)='temp_ym_dpth'
varname(*,1)='temp_ym_dpth'
varname(*,2)='temp_ym_dpth'
varname(*,3)='temp_ym_dpth'
varname(*,4)='temp_ym_dpth'
varname(*,5)='temp_ym_dpth'

if (nexp gt 1) then begin
myshift=intarr(nexp)
myshift(*)=[2100,3250,6350,-1,9450,12550]
endif

; plot_times: do we want to plot the timeseries?
plot_tims=intarr(nexp)
plot_tims(*)=[1,1,1,0,1,1]

; cont_tims: which experiment will we difference from to check
; continuity [-1 = none]
cont_tims=intarr(nexp)
cont_tims(*)=[-1,0,1,-1,2,4]

; navy = how many years for averaging means
navy=intarr(nexp)
navy(*)=[20,20,20,20,20,20]

;;;;


check_names=1

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
ymaxa=[30,16,15]

lim=fltarr(ndepth,2)
lim(0,0)=10.0
lim(1,0)=2.0
lim(2,0)=-2
lim(0,1)=28.0
lim(1,1)=15.5
lim(2,1)=14


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
dates=fltarr(ndates,nexp)
names=strarr(ndates,nexp)
dates2=fltarr(ndates)
dates3=strarr(ndates)
co2=fltarr(ndates)
solar=fltarr(ndates)




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
endfor

weight=fltarr(nx,ny)
newweight=fltarr(nx,ny)

mytemp=fltarr(tmax,ndates,ndepth,nexp)
ntimes=intarr(ndates,nexp)
gmst=fltarr(ndates,ndepth,nexp)

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

clims=fltarr(nxmax,nymax,ndates,nexp,nvar)
masks=fltarr(nx,ny,ndates)
masks_mean=fltarr(ndates)
ice=fltarr(nx,ny,ndates)
ice_mean=fltarr(ndates)

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

if (readfile(n,e) eq 1) then begin

if (locdata(n,e) eq 0) then begin
data_filename=roottim(n,e)+'/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'/monthly/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'.temp_ym_dpth_'+depthname2(d)+'.annual.nc'
endif

if (locdata(n,e) eq 1) then begin
data_filename=roottim(n,e)+'/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'.oceantemppg'+depthname3(d)+'.monthly.nc'
endif

print,n,data_filename
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

my_filename='my_data/temp_'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'_'+depth(d)+'.dat'
openw,1,my_filename
printf,1,ntimes(n,e)
printf,1,mytemp(*,n,d,e)
close,1

endif ; end readfile

endif ; end writing(e)

endfor ; end n (nstart)

endfor ; end d (depth)

endfor ; end e (nexp)





for e=0,nexp-1 do begin
for d=0,ndepth-1 do begin
for n=nstart,ndates-1 do begin
if (reading(n,e) eq 1) then begin

if (readfile(n,e) eq 1) then begin

my_filename='my_data/temp_'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'_'+depth(d)+'.dat'
print,my_filename
openr,1,my_filename
readf,1,aa
ntimes(n,e)=aa
aaa=fltarr(aa)
readf,1,aaa
mytemp(0:aa-1,n,d,e)=aaa
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


; check for continuity

for e=1,nexp-1 do begin
if (cont_tims(e) ne -1) then begin
for n=nstart,ndates-1 do begin
if (readfile(n,e) eq 1) then begin
print,'checking continuity for: '+exproot(n,e)+exptail(n,e)+exptail2(n,e)
diff=mytemp(ntimes(n,cont_tims(e))-1,n,2,cont_tims(e))-mytemp(0,n,2,e)
print,mytemp(ntimes(n,0)-1,n,2,cont_tims(e)),mytemp(0,n,2,e),diff
if (abs(diff) gt 0.02) then begin
print,'OWCH - non-continuity'
endif
endif
endfor
endif
endfor

endif ; end times


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
print,my_line(0)+' '+my_line(1)+' '+my_line(2)+' '+my_line(3)+' '+my_line(4)
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
print,n
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




nreg=7
xs=intarr(nreg)
xf=intarr(nreg)
ys=intarr(nreg)
yf=intarr(nreg)
xs(*)=[0,0,0,0,0,0,0]
xf(*)=[95,95,95,95,95,95,95]
ys(*)=[0,12,24,36,48,60,0]
yf(*)=[11,23,35,47,59,72,72]

climtag=strarr(nvar)
climtag(*)=['a.pd','o.pf']
climname=strarr(nvar)
climname(*)=['temp_mm_1_5m','temp_mm_uo']
climav=fltarr(ndates,nexp,nvar)

climav_r=fltarr(ndates,nexp,nvar,nreg)

climnamelong=strarr(nvar)
climnamelong(*)=['temp','sst']
climnametitle=strarr(nvar)
climnametitle(*)=['Global Mean Surface Temperature','SST']
climoff=fltarr(nvar)
climoff(*)=[-273.15,0]

yminc=fltarr(nvar)
ymaxc=fltarr(nvar)
yminc=[10,15]
ymaxc=[26,27]

yminr=fltarr(nvar)
ymaxr=fltarr(nvar)
yminr=[-4,-5]
ymaxr=[4,5]

yminp=fltarr(nvar)
ymaxp=fltarr(nvar)
yminp=[15,15]
ymaxp=[40,27]


climweight=fltarr(nxmax,nymax,ndates,nvar)
climweight_lat=fltarr(nymax,nvar)
climnewweight=fltarr(nxmax,nymax)

for v=0,nvar-1 do begin
for j=0,nyc(v)-1 do begin
climweight_lat(j,v)=-0.5*(sin(latsedgec(j+1,v)*2*!pi/360.0)-sin(latsedgec(j,v)*2*!pi/360.0))
endfor
endfor

; read in bounds


if (do_readbounds eq 1) then begin

masks_mean(*)=0.0
for n=nstart,ndates-1 do begin
; read in lsm
filename=root(0,0)+'/'+exproot(n,0)+exptail(n,0)+exptail2(n,0)+'/inidata/'+exproot(n,0)+exptail(n,0)+exptail2(n,0)+'.qrparm.mask.nc'
print,filename
id1=ncdf_open(filename)
ncdf_varget,id1,'lsm',dummy
masks(*,*,n)=dummy
ncdf_close,id1
for j=0,ny-1 do begin
masks_mean(n)=masks_mean(n)+weight_lat(j)*mean(masks(*,j,n))
endfor
endfor

ice_mean(*)=0.0
for n=nstart,ndates-1 do begin
; read in ice
filename=root(0,0)+'/'+exproot(n,0)+exptail(n,0)+exptail2(n,0)+'/inidata/'+exproot(n,0)+exptail(n,0)+exptail2(n,0)+'.qrfrac.type.nc'
print,filename
id1=ncdf_open(filename)
ncdf_varget,id1,'field1391',dummy
print,size(dummy)
ice(*,*,n)=dummy(*,*,8)
ice(*,*,n)=ice(*,*,n)*(ice(*,*,n) gt -1)
ncdf_close,id1
for j=0,ny-1 do begin
ice_mean(n)=ice_mean(n)+weight_lat(j)*mean(ice(*,j,n))
endfor
endfor

endif


if (do_clims eq 1) then begin

for e=0,nexp-1 do begin
for n=nstart,ndates-1 do begin
for v=0,nvar-1 do begin

if (readfile(n,e) eq 1) then begin

if (readtype(n,e) eq 1) then begin
data_filename=root(n,e)+'/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'/climate/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+climtag(v)+'clann.nc'
endif
if (readtype(n,e) eq 0) then begin
data_filename=root(n,e)+'/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+climtag(v)+'clann.nc'
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

f_area=fltarr(ndates)
f_area_lin=fltarr(ndates)

f_ice=fltarr(ndates)
f_ice_lin=fltarr(ndates)

f_co2=fltarr(ndates)
f_co2_lin=fltarr(ndates)

f_all=fltarr(ndates)
f_all_lin=fltarr(ndates)

temp_all=fltarr(ndates)
temp_all_lin=fltarr(ndates)


; units of f_co2 and f_solar are w/m2
f_co2(*)=t_co2*c_co2*alog(co2/co2(baseline))/alog(2.0)
f_solar(*)=t_solar*(1.0-c_alb)*(solar-solar(baseline))/4.0
f_area(*)=t_area*solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0
f_ice(*)=t_ice*solar*(-1.0)*(ice_mean-ice_mean(baseline))*c_dice/4.0


f_co2_lin(*)=t_co2_lin*c_co2*alog(co2/co2(baseline))/alog(2.0)
f_solar_lin(*)=t_solar_lin*(1.0-c_alb)*(solar-solar(baseline))/4.0
f_area_lin(*)=t_area_lin*solar*(-1.0)*(masks_mean-masks_mean(baseline))*c_dalb/4.0
f_ice_lin(*)=t_ice*solar*(-1.0)*(ice_mean-ice_mean(baseline))*c_dice/4.0

f_all=f_co2+f_solar+f_area+f_ice
f_all_lin=f_co2_lin+f_solar_lin+f_area_lin+f_ice_lin

temp_all_lin=climav(baseline,pe,0) - 1.0*f_all_lin/lambda_lin 
temp_all= climav(baseline,pe,0) + (-1.0*lambda-sqrt(lambda*lambda-4.0*c_a*f_all))/(2.0*c_a)

temp_scot_interp=interpol(temp_scot,dates_scot,dates2)
temp_scot1m_interp=interpol(temp_scot1m,dates_scot1m,dates2)



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

resid=climav(*,pe,0)-temp_all_tun(*)
temp_resid=myconst + resid

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


device,filename='timeseries_'+depth(d)+'_new4.eps',/encapsulate,/color,set_font='Helvetica'

xmin=0
xmax=11000
times=indgen(xmax)

; where individual names on lines are
labelx=9000
; where all naems are listed in relation to this
ddx=900

ymin=ymina(d)
ymax=ymaxa(d)


plot,times(0:ntimes(0,0)-1),mytemp(0:ntimes(0,0)-1,0,0,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Year of simulation',psym=2,/nodata,ytitle='Temperature [degrees C]',title='Global mean ocean temperature at '+depthname(d),ystyle=1,xstyle=1

;plot,times(0:ntimes(0,0)-1),mytemp(0:ntimes(0,0)-1,0,0,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Year of simulation',psym=2,/nodata,ytitle='Temperature [degrees C]',title='Global mean ocean temperature at '+depthname(d),ystyle=1,xtickname=['0','500','1000','1500','2000','2500','3000','3500','4000'],xtickv=[0,500,1000,1500,2000,2500,3000,3500,4000],xticks=8,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin



x=n-nstart
xx=ndates-nstart

mycol=(x)*250.0/(xx-1)

if (readfile(n,0) eq 1) then begin
oplot,times(0:ntimes(n,0)-1),mytemp(0:ntimes(n,0)-1,n,d,0),color=mycol

if (total(mytemp(0:ntimes(n,0)-1,n,d,0) eq 0) gt 0) then begin
print,mytemp(0:ntimes(n,0)-1,n,d,0)
print,'problem!!!'
print,total(mytemp(0:ntimes(n,0)-1,n,d,0) le 0)
print,n,sim_names_long(n),d
stop
endif
endif

if (nexp gt 1) then begin
for e=1,nexp-1 do begin
if (plot_tims(e) eq 1) then begin
if (readfile(n,e) eq 1) then begin
ttt=myshift(cont_tims(e))
oplot,times(ttt:ttt+ntimes(n,e)-1),mytemp(0:ntimes(n,e)-1,n,d,e),color=(x)*250.0/(xx-1)
if (e eq nexp-1) then begin
xyouts,labelx,mytemp(ntimes(n,e)-1,n,d,e),exproot(n,e)+exptail(n,e)+exptail2(n,e)+' '+strtrim(ntimes(n,e),2),charsize=0.25,color=mycol
endif
endif
endif

endfor
endif


explab=2
z=ymin+0.9*(ymax-ymin)-0.8*(ymax-ymin)*x/(xx-1)
oplot,[labelx+ddx,labelx+ddx+70],[z,z],color=(n-nstart)*250.0/(ndates-nstart-1)
xyouts,labelx+ddx+100,z,sim_names_long(n)+' '+exproot(n,explab)+exptail(n,explab)+exptail2(n,explab)+' '+strtrim(ntimes(n,explab),2),charsize=0.25,color=(n-nstart)*250.0/(ndates-nstart-1)

endfor

; plot main experiment family label
for e=0,nexp-1 do begin
if (plot_tims(e) eq 1) then begin
z=ymin+0.97*(ymax-ymin)
xyouts,myshift(e)-500,z,exproot(0,e)+'*'
endif
endfor

device,/close


endfor

endif




nstage=10
stageb=fltarr(nstage+1)
stageb(*)=-1.0*[0,66.0,145.0,201.3,251.902,298.9,358.9,419.2,443.8,485.4,541.0]
stagen=strarr(nstage)
stagen(*)=['Cenozoic','Cretaceous','Jurassic','Triassic','Permian','Carb.','Devonian','Sil.','Ord.','Cambrian']



if (do_gmst_plot eq 1) then begin

; GMST PLOT
for d=0,0 do begin

device,filename='gmst_time_'+depth(d)+'.eps',/encapsulate,/color,set_font='Helvetica'

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

if (readfile(n,0) eq 1) then begin
plots,dates2(n),gmst(n,d,0),color=mycol,psym=5
endif

if (readfile(n,1) eq 1) then begin
plots,dates2(n),gmst(n,d,1),color=mycol,psym=6
;xyouts,dates2(n)+5,gmst(n,d,1)+0.1,exproot(n,1)+exptail(n,1),charsize=0.2
endif

if (readfile(n,2) eq 1) then begin
plots,dates2(n),gmst(n,d,2),color=mycol,psym=7
xyouts,dates2(n)+5,gmst(n,d,2)+0.1,exproot(n,2)+exptail(n,2)+exptail2(n,2),charsize=0.2
endif

if (readfile(n,3) eq 1) then begin
plots,dates2(n),gmst(n,d,3),color=mycol,psym=4
xyouts,dates2(n)+5,gmst(n,d,3)+0.1,exproot(n,3)+exptail(n,3)+exptail2(n,3),charsize=0.2
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

npp=3
ppname=strarr(npp)
ppname(*)=['01','02','03']
for p=0,npp-1 do begin

device,filename='temp_scotese_time_'+ppname(p)+'.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0


ymin=5
ymax=40

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0


plot,dates2,co2,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='Global Mean Temperature [oC]',ystyle=1,xstyle=1,/nodata

; Plot Wing and Huber
;plots,dates_wing,temp_wing,psym=8,symsize=0.5,color=80
oplot,dates_wing,temp_wing,color=80,thick=3


if (p eq 0 or p eq 1 or p eq 2) then begin
; Plot raw Scotese Master in red
;plots,dates_scot,temp_scot,psym=8,symsize=0.5,color=250
oplot,dates_scot,temp_scot,color=250,thick=3
endif

if (p eq 1 or p eq 2) then begin
; Plot raw Scotese 1m in green
oplot,dates_scot1m,temp_scot1morig,color=150,thick=3
endif

if (p eq 2) then begin
; Plot final Scotese 1m in black, with interpolated points
oplot,dates_scot1m,temp_scot1m,color=0,thick=3
plots,dates2,temp_scot1m_interp,psym=6,symsize=0.5,color=0
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

oplot,[x1,x1+dx1],[y1,y1],color=250,thick=3
;plots,x1+dx1/2.0,y1,psym=8,symsize=0.5,color=250
xyouts,x1+dx2,y1-dy2,'Scotese et al (2021)',color=250
oplot,[x1,x1+dx1],[y1-dy1,y1-dy1],color=80,thick=3
;plots,x1+dx1/2.0,y1-dy1,psym=8,symsize=0.5,color=80
xyouts,x1+dx2,y1-dy1-dy2,'Wing and Huber (2020)',color=80

device,/close

endfor

endif ; end if temp plot


if (do_co2_plot eq 1) then begin

for t=0,1 do begin

device,filename='co2_time_'+strtrim(t,2)+'.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0


ymin=0
ymax=12000

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0

plot,dates2,co2,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='co2',ystyle=1,xstyle=1,color=0,/nodata
oplot,dates2,co2,color=50
plots,dates2,co2,psym=5,symsize=0.5,color=50

if (t eq 1) then begin
oplot,dates2,co2_inf,color=250
oplot,dates2,co2_inf_1m,color=0,thick=5
plots,dates2,co2_inf_1m,color=0,psym=6,symsize=0.5
endif

oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

oplot,[-150,-120],[4000,4000],color=50
xyouts,-100,3950,'prescribed CO2', charsize=0.7
if (t eq 1) then begin
oplot,[-150,-120],[3700,3700], color=0,thick=5
xyouts,-100,3650,'inferred CO2', charsize=0.7
endif

device,/close

endfor

endif ; end if co2 plot



if (do_lsm_plot eq 1) then begin

device,filename='lsm_time.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0


ymin=0
ymax=0.5

plot,dates2,masks_mean,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='land area',ystyle=1,xstyle=1
plots,dates2,masks_mean,psym=5

device,/close

endif ; end if co2 plot


if (do_solar_plot eq 1) then begin

device,filename='solar_time.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0


ymin=1280
ymax=1380

plot,dates2,solar,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='S0',ystyle=1,xstyle=1
plots,dates2,solar,psym=5

device,/close

endif ; end if solar plot

if (do_ice_plot eq 1) then begin

device,filename='ice_time.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0


ymin=0
ymax=0.07

plot,dates2,ice_mean,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='ice fraction',ystyle=1,xstyle=1
plots,dates2,ice_mean,psym=5

device,/close

endif ; end if ice plot


if (do_forcings_plot eq 1) then begin

for t=0,1 do begin

device,filename='forcings_time_'+strtrim(t,2)+'.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0


ymin=-15
ymax=15

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0

plot,dates2,f_all,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='Global Mean Forcings [W/m2]',ystyle=1,xstyle=1,/nodata

plots,dates2,f_all,psym=5,symsize=0.5

oplot,dates2,f_solar,color=50,thick=3
oplot,dates2,f_co2,color=100,thick=3
oplot,dates2,f_area,color=150,thick=3
oplot,dates2,f_ice,color=200,thick=3
oplot,dates2,f_all,color=0,thick=3

if (t eq 1) then begin
oplot,dates2,f_co2_inf,color=100,thick=3,linestyle=1
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
oplot,[x1,x1+dx1],[y1-(3*dy1),y1-(3*dy1)],color=200,thick=3
oplot,[x1,x1+dx1],[y1-(4*dy1),y1-(4*dy1)],color=0,thick=3
plots,x1+dx1/2.0,y1-(4*dy1),psym=5,symsize=0.5

xyouts,x1+dx2,y1,color=50,'Solar forcing',charsize=cs
xyouts,x1+dx2,y1-(1*dy1),color=100,'CO2 forcing',charsize=cs
xyouts,x1+dx2,y1-(2*dy1),color=150,'Land surface forcing',charsize=cs
xyouts,x1+dx2,y1-(3*dy1),color=200,'Ice sheet forcing',charsize=cs
xyouts,x1+dx2,y1-(4*dy1),color=0,'All forcings',charsize=cs


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

for t=0,1 do begin

device,filename='forctemps_time_'+strtrim(t,2)+'.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0

ymin=5
ymax=40

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0

plot,dates2,f_all,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',ytitle='Global Mean Te,peratures [oC]',ystyle=1,xstyle=1,/nodata

plots,dates2,climav(*,pe,0),psym=5,symsize=0.5

oplot,dates2,temp_solar,color=50,thick=3
oplot,dates2,temp_co2,color=100,thick=3
oplot,dates2,temp_area,color=150,thick=3
oplot,dates2,temp_ice,color=200,thick=3
oplot,dates2,temp_resid,color=250,thick=3

oplot,dates2,temp_all_tun,color=0,thick=3

if (t eq 1) then begin
oplot,dates2,f_co2_inf,color=100,thick=3,linestyle=1
endif



y1=12
dy1=1.2
x1=-220
dx1=30
dx2=50
cs=1.0

plots,x1+dx1/2.0,y1+(1*dy1),psym=5,symsize=0.5
oplot,[x1,x1+dx1],[y1,y1],color=50,thick=3
oplot,[x1,x1+dx1],[y1-(1*dy1),y1-(1*dy1)],color=100,thick=3
oplot,[x1,x1+dx1],[y1-(2*dy1),y1-(2*dy1)],color=150,thick=3
oplot,[x1,x1+dx1],[y1-(3*dy1),y1-(3*dy1)],color=200,thick=3
oplot,[x1,x1+dx1],[y1-(4*dy1),y1-(4*dy1)],color=250,thick=3
oplot,[x1,x1+dx1],[y1-(5*dy1),y1-(5*dy1)],color=0,thick=3


xyouts,x1+dx2,y1+(1*dy1),'HadCM3L ['+exproot(pe,0)+']',charsize=cs
xyouts,x1+dx2,y1,color=50,'Solar temp',charsize=cs
xyouts,x1+dx2,y1-(1*dy1),color=100,'CO2 temp',charsize=cs
xyouts,x1+dx2,y1-(2*dy1),color=150,'Land surface temp',charsize=cs
xyouts,x1+dx2,y1-(3*dy1),color=200,'Ice sheet temp',charsize=cs
xyouts,x1+dx2,y1-(4*dy1),color=250,'Residual temp',charsize=cs
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

ntype=4
mytypename=['new','cmp','pro','bot']


for t=0,ntype-1 do begin
for v=0,nvar-1 do begin

device,filename='clim_'+climnamelong(v)+'_'+mytypename(t)+'_time.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0



ymin=yminc(v)
ymax=ymaxc(v)

if ((t eq 2 or t eq 3) and v eq 0) then begin
ymin=5
ymax=40
endif

topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0


plot,dates2,climav(*,0,v),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',psym=2,/nodata,ytitle=climnametitle(v)+' [degrees C]',ystyle=1,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)
mycol=0

if (t eq 1) then begin

; plot non-pe model points
for e=0,nexp-1 do begin
if (e ne pe) then begin
plots,dates2(n),climav(n,e,v),color=colexp(e),psym=5,symsize=0.5
endif
endfor
endif

; plot hadcm3l (pe) points
plots,dates2(n),climav(n,pe,v),color=mycol,psym=6,symsize=0.5
; plot hadcm3l (pe) curves
oplot,dates2(*),climav(*,pe,v),thick=3

if (t eq 3) then begin
; plot tuned runs
plots,dates2(n),climav(n,5,v),color=210,psym=6,symsize=0.5
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




if (v eq 0 and t eq 0) then begin
oplot,dates2(*),temp_all_lin(*),color=200,thick=3
;oplot,dates2(*),temp_all(*),color=100
oplot,dates2(*),temp_all_tun(*),color=100,thick=3

xyouts,-500,13,'Forcing/feedback model'
oplot,[-510,-530],[13,13],color=200,thick=3

xyouts,-500,14,'Forcing/feedback model [tuned]'
oplot,[-510,-530],[14,14],color=100,thick=3

endif

if (v eq 0 and t eq 2) then begin
;plots,dates_scot,temp_scot,psym=8,symsize=0.5,color=250
oplot,dates_scot,temp_scot,color=250,thick=3

;plots,dates_wing,temp_wing,psym=8,symsize=0.5,color=80
oplot,dates_wing,temp_wing,color=80,thick=3
endif

if (v eq 0 and t eq 3) then begin
;plots,dates_scot,temp_scot,psym=8,symsize=0.5,color=250
oplot,dates2,temp_scot1m_interp,color=250,thick=3

;plots,dates_wing,temp_wing,psym=8,symsize=0.5,color=80
oplot,dates_wing,temp_wing,color=80,thick=3
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
plots,-520,12,psym=6,symsize=0.5
oplot,[-510,-530],[12,12]
endif

if (v eq 0 and (t eq 2 or t eq 3)) then begin
x1=-300
dx1=40
dx2=50
y1=8
dy1=1.5
dy2=0.5

oplot,[x1,x1+dx1],[y1+dy1,y1+dy1],color=0,thick=3
;plots,x1+dx1/2.0,y1,psym=8,symsize=0.5,color=250
xyouts,x1+dx2,y1+dy1-dy2,'HadCM3L ['+exproot(0,pe)+']',color=0
plots,x1+dx1/2.0,y1+dy1,color=mycol,psym=6,symsize=0.5
;plots,-520,12,psym=6,symsize=0.5
oplot,[x1,x1+dx1],[y1,y1],color=250,thick=3
;plots,x1+dx1/2.0,y1,psym=8,symsize=0.5,color=250
xyouts,x1+dx2,y1-dy2,'Scotese et al (2021)',color=250
oplot,[x1,x1+dx1],[y1-dy1,y1-dy1],color=80,thick=3
;plots,x1+dx1/2.0,y1-dy1,psym=8,symsize=0.5,color=80
xyouts,x1+dx2,y1-dy1-dy2,'Wing and Huber (2020)',color=80
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
mycol=(x)*250.0/(xx-1)
mycol=0

plots,dates2(n),resid(n),color=mycol,psym=6,symsize=0.5
;xyouts,dates2(n)+5,resid(n)+0.05,exproot(n,1)+exptail(n,1),charsize=0.2

endfor ; end n

oplot,dates2(*),resid,thick=3

oplot,[dates2(0),dates2(nstart-1)],[0,0],linestyle=2

xyouts,-500,-1.5,'HadCM3L ['+exproot(0,pe)+']'
plots,-520,-1.5,psym=6,symsize=0.5

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

polamp=(climav_r(*,1,v,2)+climav_r(*,1,v,3))/2.0 - (climav_r(*,1,v,0)+climav_r(*,1,v,5))/2.0

device,filename='polamp_'+climnamelong(v)+'_time.eps',/encapsulate,/color,set_font='Helvetica'

xmin=-550
xmax=0


ymin=yminp(v)
ymax=ymaxp(v)


topbar=ymin+(ymax-ymin)*33.0/35.0
dtopbar=(ymax-ymin)*0.6/35.0


plot,dates2,climav(*,1,v),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Myrs BP',psym=2,/nodata,ytitle='Temperature [degrees C]',title=climnametitle(v)+' meridional gradient',ystyle=1,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)
;mycol=0

plots,dates2(n),polamp(n),color=mycol,psym=6,symsize=0.5
;xyouts,dates2(n)+5,polamp(n)+0.05,exproot(n,1)+exptail(n,1),charsize=0.2

endfor ; end n

for n=nstart,ndates-2 do begin
x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)
oplot,[dates2(n),dates2[n+1]],[polamp(n),polamp(n+1)],thick=3,color=mycol
endfor


oplot,[dates2(0),dates2(nstart-1)],[0,0],linestyle=2

xyouts,-500,17,'HadCM3L'
plots,-520,17,psym=6,symsize=0.5

oplot,[xmin,xmax],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax]
endfor

for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor

device,/close

endfor


for v=0,nvar-1 do begin

polamp=(climav_r(*,1,v,2)+climav_r(*,1,v,3))/2.0 - (climav_r(*,1,v,0)+climav_r(*,1,v,5))/2.0

device,filename='polampxtemp_'+climnamelong(v)+'_scatter.eps',/encapsulate,/color,set_font='Helvetica'

xmin=yminc(v)
xmax=ymaxc(v)

ymin=yminp(v)
ymax=ymaxp(v)


plot,climav(*,1,v),polamp,yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='global mean',psym=2,/nodata,ytitle='meridional gradient [degrees C]',title=climnametitle(v),ystyle=1,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

x=n-nstart
xx=ndates-nstart
mycol=(x)*250.0/(xx-1)
;mycol=0

plots,climav(n,1,v),polamp(n),color=mycol,psym=8,symsize=1.5
;xyouts,climav(n,1,v)+5,polamp(n)+0.05,exproot(n,1)+exptail(n,1),charsize=0.2

ddy=0.2
fy=0.7
sy=19

if (n eq 0) then begin
plots,16,sy,color=mycol,psym=8,symsize=1.5
xyouts,16.5,sy-ddy,color=0,'0 Ma'
endif
if (n eq 20) then begin
plots,16,sy-1*fy,color=mycol,psym=8,symsize=1.5
xyouts,16.5,sy-1*fy-ddy,color=0,'100 Ma'
endif
if (n eq 40) then begin
plots,16,sy-2*fy,color=mycol,psym=8,symsize=1.5
xyouts,16.5,sy-2*fy-ddy,color=0,'200 Ma'
endif
if (n eq 60) then begin
plots,16,sy-3*fy,color=mycol,psym=8,symsize=1.5
xyouts,16.5,sy-3*fy-ddy,color=0,'300 Ma'
endif
if (n eq 80) then begin
plots,16,sy-4*fy,color=mycol,psym=8,symsize=1.5
xyouts,16.5,sy-4*fy-ddy,color=0,'400 Ma'
endif
if (n eq 100) then begin
plots,16,sy-5*fy,color=mycol,psym=8,symsize=1.5
xyouts,16.5,sy-5*fy-ddy,color=0,'500 Ma'
endif






endfor ; end n

;oplot,climav(*,1,v),polamp,thick=3

;oplot,[dates2(0),dates2(nstart-1)],[0,0],linestyle=2

;xyouts,-500,17,'My new runs'


plots,-520,17,psym=6,symsize=0.5





device,/close

endfor



endif


if (do_textfile eq 1) then begin

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



stop

end
