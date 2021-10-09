pro time

;;;;
; Total number of time snapshots
ndates=109
nexp=2
tmax=3000
nstart=0
;;;;

writing=intarr(nexp)

;;;;
writing(0)=0
writing(1)=0
check=1
;;;;

ndepth=3
depthname2=strarr(ndepth)
depthname2=['5','666','2731']
depthname3=strarr(ndepth)
depthname3=['1','12','16']
depth=strarr(ndepth)
depth=['L01','L12','L16']
depthname=['5m','670m','2700m']
ymina=fltarr(ndepth)
ymaxa=fltarr(ndepth)
ymina=[15,2,-2]
ymaxa=[27,17,16]
lim=fltarr(ndepth)
lim(0)=10.0
lim(1)=2.0
lim(2)=-2

my_missing=intarr(ndates,tmax,ndepth)
my_missing(*,*,*)=1

root=strarr(nexp)
exproot=strarr(ndates,nexp)
exptail=strarr(ndates,nexp)
sim_names=strarr(ndates)
sim_names_long=strarr(ndates)
sim_tail=strarr(ndates)
sim_ext=strarr(ndates,nexp)


root(0)='/home/bridge/ggdjl/ummodel/data'
root(1)='/home/bridge/ggdjl/um_climates'

expname=strarr(ndates,nexp)
dates=fltarr(ndates,nexp)
names=strarr(ndates,nexp)


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
exptail(0:25,1)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
exproot(26:51,1)=['tfgW']
exptail(26:51,1)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
exproot(52:77,1)=['tfGw']
exptail(52:77,1)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
exproot(78:103,1)=['tfGW']
exptail(78:103,1)=['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
exproot(104:108,1)=['tFgw']
exptail(104:108,1)=['a','b','c','d','e']

varname=strarr(ndates,nexp)
varname(*,0)='temp_ym_dpth'
varname(*,1)='temp_ym_dpth'

readfile=intarr(ndates,nexp)

readfile(*,0)=1
readfile(0:84,1)=1
readfile(95:108,1)=1


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

if (check eq 1) then begin

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

endif


for e=0,nexp-1 do begin

if (writing(e) eq 1) then begin

for d=0,ndepth-1 do begin

for n=nstart,ndates-1 do begin

if (readfile(n,e) eq 1) then begin

if (e eq 0) then begin
data_filename=root(e)+'/'+exproot(n,e)+exptail(n,e)+'/monthly/'+exproot(n,e)+exptail(n,e)+'.temp_ym_dpth_'+depthname2(d)+'.annual.nc'
endif

if (e eq 1) then begin
data_filename=root(e)+'/'+exproot(n,e)+exptail(n,e)+'/'+exproot(n,e)+exptail(n,e)+'.oceantemppg'+depthname3(d)+'.monthly.nc'
endif

print,n,data_filename
id1=ncdf_open(data_filename)
ncdf_varget,id1,varname(n,e),dummy
ncdf_close,id1
a=size(dummy)
ntimes(n,e)=a(4)

for t=0,ntimes(n,e)-1 do begin

weight=dummy(*,*,0,t) lt 1e20

for j=0,ny-1 do begin
for i=0,nx-1 do begin
newweight(i,j)=weight_lat(j)*weight(i,j)
endfor
endfor

mytemp(t,n,d,e)=total(dummy(*,*,0,t)*newweight(*,*)/total(newweight(*,*)))
if (my_missing(n,t,d) eq 0) then begin
mytemp(t,n,d,e)=!VALUES.F_NAN
endif

if (n ge nstart) then begin
if (mytemp(t,n,d,e) lt lim(d)) then begin
print,'PROBLEM',n,t,d,e,mytemp(t,n,d,e)
endif
endif


endfor ; end t (ntimes)

my_filename='my_data/temp_'+exproot(n,e)+exptail(n,e)+'_'+depth(d)+'.dat'
openw,1,my_filename
printf,1,ntimes(n,e)
printf,1,mytemp(*,n,d,e)
close,1

endif ; end readfile

endfor ; end n (nstart)

endfor ; end d (depth)

endif ; end writing(e)

endfor ; end e (nexp)




for e=0,nexp-1 do begin
if (writing(e) eq 0) then begin


for d=0,ndepth-1 do begin
for n=nstart,ndates-1 do begin

if (readfile(n,e) eq 1) then begin

my_filename='my_data/temp_'+exproot(n,e)+exptail(n,e)+'_'+depth(d)+'.dat'
print,my_filename
openr,1,my_filename
readf,1,aa
ntimes(n,e)=aa
aaa=fltarr(tmax)
readf,1,aaa
mytemp(*,n,d,e)=aaa
close,1

endif
endfor ; end n (nstart)
endfor ; end d (depth)

endif ; end reading(e)
endfor ; end e (nexp)







for d=0,ndepth-1 do begin

set_plot,'ps'
!P.FONT=0

device,filename='timeseries_'+depth(d)+'_new3.eps',/encapsulate,/color,set_font='Helvetica'

xmin=0
xmax=3000
times=indgen(xmax)

loadct,39

ymin=ymina(d)
ymax=ymaxa(d)


plot,times(0:ntimes(0,0)-1),mytemp(0:ntimes(0,0)-1,0,0,0),yrange=[ymin,ymax],xrange=[xmin,xmax],xtitle='Year of simulation',psym=2,/nodata,ytitle='Temperature [degrees C]',title='Global mean ocean temperature at '+depthname(d),ystyle=1,xtickname=['0','500','1000','1500','2000','2500','3000'],xtickv=[0,500,1000,1500,2000,2500,3000],xticks=6,xstyle=1

;;;;;;;;;;;;;
for n=nstart,ndates-1 do begin

myshift=2100

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

if (readfile(n,1) eq 1) then begin
ttt=myshift
oplot,times(ttt:ttt+ntimes(n,1)-1),mytemp(0:ntimes(n,1)-1,n,d,1),color=(x)*250.0/(xx-1)

xyouts,2400,mytemp(ntimes(n,1)-1,n,d,1),exproot(n,1)+exptail(n,1),charsize=0.25,color=mycol

endif


z=ymin+0.9*(ymax-ymin)-0.8*(ymax-ymin)*x/(xx-1)
oplot,[2500,2600],[z,z],color=(n-nstart)*250.0/(ndates-nstart-1)
xyouts,2700,z,sim_names_long(n),charsize=0.25

endfor

device,/close


endfor



stop

end
