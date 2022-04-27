pro time

set_plot,'ps'
!P.FONT=0

loadct,39

Aaa = FINDGEN(17) * (!PI*2/16.)  
USERSYM, COS(Aaa), SIN(Aaa), /FILL 

; times
do_timeseries_plot=1 ; plot global mean SST timeseries of each simulation

; continuity (only if nexp>1)
do_cont_check=1


;;;;
; Total number of time snapshots
ndates=109
nexp=8
tmax=3000
nstart=0
;;;;

if (nexp gt 1) then begin
myshift=intarr(nexp)
myshift(*)=[2100,4200,6300,7400,8500,9600,10700,11300]
endif


ymin=0.0
ymax=0.8


;;;;
writing=intarr(ndates,nexp)
writing(*,0)=0
writing(*,1)=0
writing(*,2)=0
writing(*,3)=0
writing(*,4)=0
writing(*,5)=0
writing(*,6)=0
writing(*,7)=0



reading=intarr(ndates,nexp)
reading(*,0)=1-writing(*,0)
reading(*,1)=1-writing(*,1)
reading(*,2)=1-writing(*,2)
reading(*,3)=1-writing(*,3)
reading(*,4)=1-writing(*,4)
reading(*,5)=1-writing(*,5)
reading(*,6)=1-writing(*,6)
reading(*,7)=1-writing(*,7)



readfile=intarr(ndates,nexp) ; does data exist for this simulation?
readfile(*,0)=1
readfile(*,1)=1
readfile(*,2)=1
readfile(*,3)=1
readfile(*,4)=1
readfile(*,5)=1
readfile(*,6)=1

readfile(*,7)=0
readfile(0,7)=1
readfile(108,7)=1

readtype=intarr(ndates,nexp)
readtype(*,0)=1
readtype(*,1)=1
readtype(*,2)=1
readtype(*,3)=1
readtype(*,4)=1
readtype(*,5)=1
readtype(*,6)=1
readtype(*,7)=2

my_missing=intarr(ndates,nexp,tmax) ; is single data missing
my_missing(*,*,*)=1 ; no missing data
my_missing(17,6,780)=0 ; teyf?3 series

my_missing(80,0,952:957)=0

my_missing(84,0,955:962)=0
my_missing(85,0,913)=0


check_names=1


lim=0.0 ; all fracs > 0

root=strarr(nexp)
exproot=strarr(ndates,nexp)
exptail=strarr(ndates,nexp)
exptail2=strarr(ndates,nexp)
sim_names=strarr(ndates)
sim_names_long=strarr(ndates)
sim_tail=strarr(ndates)
sim_ext=strarr(ndates,nexp)

root(*)='/home/bridge/ggdjl/ummodel/data/'

expname=strarr(ndates,nexp)
dates=fltarr(ndates,nexp)
names=strarr(ndates,nexp)
dates2=fltarr(ndates)
co2=fltarr(ndates)

; My tfgw
;exproot(0:25,0)=['tfgw']
exproot(0:25,0:1)=['teyd']
exproot(0:25,2)=['teye']
exproot(0:25,3:6)=['teyf']
exproot(0:25,7)=['tfja']
exptail(0:25,0)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

;exproot(26:51,0)=['tfgW']
exproot(26:51,0:1)=['teyD']
exproot(26:51,2)=['teyE']
exproot(26:51,3:6)=['teyF']
exproot(26:51,7)=['tfjA']
exptail(26:51,0)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

;exproot(52:77,0)=['tfGw']
exproot(52:77,0:1)=['teYd']
exproot(52:77,2)=['teYe']
exproot(52:77,3:6)=['teYf']
exproot(52:77,7)=['tfJa']
exptail(52:77,0)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

;exproot(78:103,0)=['tfGW']
exproot(78:103,0:1)=['teYD']
exproot(78:103,2)=['teYE']
exproot(78:103,3:6)=['teYF']
exproot(78:103,7)=['tfJA']
exptail(78:103,0)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']

;exproot(104:108,0)=['tFgw']
exproot(104:108,0:1)=['tEyd']
exproot(104:108,2)=['tEye']
exproot(104:108,3:6)=['tEyf']
exproot(104:108,7)=['tFja']
exptail(104:108,0)=['a','b','c','d','e']


for e=1,nexp-1 do begin 
exptail(*,e)=exptail(*,0)
endfor
exptail2(*,0)=''
exptail2(*,1)='1'
exptail2(*,2)=''
exptail2(*,3)=''
exptail2(*,4)='1'
exptail2(*,5)='2'
exptail2(*,6)='3'
exptail2(*,7)=''


varname=strarr(ndates,nexp)
varname(*,*)='fracPFTs_mm_srf'


nx=96
ny=73
lats=fltarr(ny)
latsedge=fltarr(ny+1)
dlat=2.5
latsedge(1:ny-1)=90.0-1.25-dlat*findgen(ny-1)
latsedge(0)=90.0
latsedge(ny)=-90.0

weight_lat=fltarr(ny)
newweight=fltarr(nx,ny)

for j=0,ny-1 do begin
weight_lat(j)=-0.5*(sin(latsedge(j+1)*2*!pi/360.0)-sin(latsedge(j)*2*!pi/360.0))
endfor

weight=fltarr(nx,ny)

mytemp=fltarr(tmax,ndates,nexp)
ntimes=intarr(ndates,nexp)

nxmax=96
nymax=73

nvar=1
nxc=intarr(nvar)
nyc=intarr(nvar)
nxc(*)=[96]
nyc(*)=[73]

latsedgec=fltarr(nymax+1,nvar)
dlat=2.5
for v=0,nvar-1 do begin
latsedgec(1:nyc(v)-1,v)=90.0-1.25-dlat*findgen(nyc(v)-1)
latsedgec(0,v)=90.0
latsedgec(nyc(v),v)=-90.0
endfor


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




for e=0,nexp-1 do begin

for n=nstart,ndates-1 do begin

if (writing(n,e) eq 1) then begin

if (readfile(n,e) eq 1) then begin

if (readtype(n,e) eq 1) then begin

data_filename=root(e)+'/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'/monthly/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'.fracPFTs_mm_srf_01.monthly.nc'

print,n,data_filename
id1=ncdf_open(data_filename)
ncdf_varget,id1,varname(n,e),dummy
ncdf_close,id1
a=size(dummy)
ntim=a(4)


t=0

for tt=0,ntim-1 do begin

if ( (tt mod 12) eq 0) then begin


weight(*,*)=dummy(*,*,0,tt) lt 1e20

for j=0,ny-1 do begin
for i=0,nx-1 do begin
newweight(i,j)=weight_lat(j)*weight(i,j)
endfor
endfor

mytemp(t,n,e)=total(dummy(*,*,0,tt)*newweight(*,*)/total(newweight(*,*)))
;if (my_missing(n,e,t) eq 0) then begin
;mytemp(t,n,e)=!VALUES.F_NAN
;endif

if (n ge nstart) then begin
if (mytemp(t,n,e) lt lim) then begin
print,'PROBLEM',n,t,e,mytemp(t,n,e)
endif
endif

t=t+1

endif

endfor ; end tt (ntim)

ntimes(n,e)=t


endif else begin ; readtype=2

ntimes(n,e)=500

for t=0,ntimes(n,e)-1 do begin

if (t eq 0) then thisvarname='fracPFTs_snp_srf'
if (t gt 0) then thisvarname='fracPFTs_srf'

tt=t
noughts,tt,ee,9

data_filename='/home/bridge/ggdjl/umdata/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'/pt/'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'a#pt'+ee+'dec+.nc'

print,n,data_filename
id1=ncdf_open(data_filename)
ncdf_varget,id1,thisvarname,dummy
ncdf_close,id1

weight(*,*)=dummy(*,*,0) lt 1e20

for j=0,ny-1 do begin
for i=0,nx-1 do begin
newweight(i,j)=weight_lat(j)*weight(i,j)
endfor
endfor

mytemp(t,n,e)=total(dummy(*,*,0)*newweight(*,*)/total(newweight(*,*)))


endfor ; end t (ntimes)


endelse ; readtype


close,1
my_filename='my_data/veg_'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'.dat'
openw,1,my_filename
printf,1,ntimes(n,e)
printf,1,mytemp(*,n,e)
close,1

endif ; end readfile

endif ; end writing(e)

endfor ; end n (nstart)

endfor ; end e (nexp)





close,1
for e=0,nexp-1 do begin
for n=nstart,ndates-1 do begin

if (reading(n,e) eq 1) then begin
if (readfile(n,e) eq 1) then begin

my_filename='my_data/veg_'+exproot(n,e)+exptail(n,e)+exptail2(n,e)+'.dat'
print,my_filename
openr,1,my_filename
readf,1,aa
ntimes(n,e)=aa
aaa=fltarr(tmax)
readf,1,aaa
mytemp(*,n,e)=aaa
close,1

for t=0,ntimes(n,e)-1 do begin
if (my_missing(n,e,t) eq 0) then begin
mytemp(t,n,e)=!VALUES.F_NAN
endif
endfor


endif
endif ; end reading(e)
endfor ; end n (nstart)
endfor ; end e (nexp)




line=''
close,1
openr,1,'../islands/co2_all_03_nt.dat'
for n=nstart,ndates-1 do begin
readf,1,line
my_line=strsplit(line,' ',/EXTRACT)
dates2(n)=my_line(1)
co2(n)=my_line(2)
endfor
close,1
dates2=dates2*(-1.0)

; check for continuity


if (do_cont_check eq 1) then begin
if (nexp gt 0) then begin
for e=1,nexp-1 do begin
for n=nstart,ndates-1 do begin
if (readfile(n,e) eq 1) then begin
print,'checking continuity for: '+exproot(n,e)+exptail(n,e)+exptail2(n,e)
diff=mytemp(ntimes(n,e-1)-1,n,e-1)-mytemp(0,n,e)
print,mytemp(ntimes(n,e-1)-1,n,e-1),mytemp(0,n,e),diff
if (abs(diff) gt 0.006) then begin
print,'OWCH'
stop
endif
endif
endfor
endfor
endif
endif


for e=0,nexp-1 do begin
for n=nstart,ndates-1 do begin

if (readfile(n,e) eq 1) then begin

if (stddev([mytemp(ntimes(n,e)-1,n,e),mytemp(ntimes(n,e)-10,n,e),mytemp(ntimes(n,e)-20,n,e),mytemp(ntimes(n,e)-30,n,e),mytemp(ntimes(n,e)-40,n,e)]) eq 0) then begin

print,'POSSIBLE NON-VEG RUN: '+exproot(n,e)+exptail(n,e)+exptail2(n,e)

endif

endif

endfor ; end n (nstart)
endfor ; end e (nexp)


thresh=0.001
for e=0,nexp-1 do begin
for n=nstart,ndates-1 do begin
if (total(mytemp(0:ntimes(n,0)-1,n,0) le thresh) gt 0) then begin
;print,mytemp(0:ntimes(n,0)-1,n,0)
print,'problem!!!',' ',e
print,total(mytemp(0:ntimes(n,0)-1,n,0) le thresh)
print,where(mytemp(0:ntimes(n,0)-1,n,0) le thresh)
print,n,' ',sim_names_long(n)
stop
endif
endfor ; end n (nstart)
endfor ; end e (nexp)


if (do_timeseries_plot eq 1) then begin

; TIMESERIES PLOT

device,filename='timeseries_veg_new3.eps',/encapsulate,/color,set_font='Helvetica',xsize=40,ysize=15

xmin=0
xmax=12500
times=indgen(xmax)


labelx=11300

plot,times(0:ntimes(0,0)-1),mytemp(0:ntimes(0,0)-1,0,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Year of simulation',psym=2,/nodata,ytitle='Veg fraction',title='VEG',ystyle=1,xstyle=1

;plot,times(0:ntimes(0,0)-1),mytemp(0:ntimes(0,0)-1,0,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Year of simulation',psym=2,/nodata,ytitle='Veg fraction',title='VEG',ystyle=1,xtickname=['0','500','1000','1500','2000','2500','3000','3500','4000'],xtickv=[0,500,1000,1500,2000,2500,3000,3500,4000],xticks=8,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin



x=n-nstart
xx=ndates-nstart

mycol=(x)*250.0/(xx-1)

if (readfile(n,0) eq 1) then begin
oplot,times(0:ntimes(n,0)-1),mytemp(0:ntimes(n,0)-1,n,0),color=mycol
endif

if (nexp gt 1) then begin
for e=1,nexp-1 do begin

if (readfile(n,e) eq 1) then begin
ttt=myshift(e-1)
oplot,times(ttt:ttt+ntimes(n,e)-1),mytemp(0:ntimes(n,e)-1,n,e),color=(x)*250.0/(xx-1)
if (e eq nexp-2) then begin
xyouts,labelx,mytemp(ntimes(n,e)-1,n,e),exproot(n,e)+exptail(n,e)+exptail2(n,e)+' '+strtrim(ntimes(n,e),2),charsize=0.25,color=mycol
endif
endif

endfor
endif


explab=0
z=ymin+0.9*(ymax-ymin)-0.8*(ymax-ymin)*x/(xx-1)
oplot,[labelx+500,labelx+570],[z,z],color=(n-nstart)*250.0/(ndates-nstart-1)
xyouts,labelx+600,z,sim_names_long(n)+' '+exproot(n,explab)+exptail(n,explab)+exptail2(n,explab)+' '+strtrim(ntimes(n,explab)),charsize=0.25,color=(n-nstart)*250.0/(ndates-nstart-1)

endfor

for e=0,nexp-1 do begin
z=ymin+0.97*(ymax-ymin)
xyouts,myshift(e)-500,z,exproot(0,e)+'*'+exptail2(0,e)
endfor

device,/close


endif





stop

end
