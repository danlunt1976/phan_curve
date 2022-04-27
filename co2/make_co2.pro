pro mc

set_plot,'ps'
!P.FONT=0

; set up arrays
nco2=2
; 0 = foster
; 1 = rae

nco2f=4
; 0 = foster
; 1 = foster | rae
; 2 = foster blended rae
; 3 = foster rae rae

ntim=2
; 0 = orig
; 1 = new
timname=strarr(ntim)
timname(*)=['dumps.dat','dumps_newtim.dat']
extname=strarr(ntim)
extname(*)=['_ot','_nt']
timfact=fltarr(ntim)
timfact(*)=[0.5,1.0]

ns=109
ages=fltarr(ns,ntim)
co2s=fltarr(ns,nco2f,ntim)
co2m=fltarr(ns,nco2f,ntim)
cage=strarr(ns,ntim)

ntmax=1500
nt=intarr(nco2)
nt(0)=844
nt1=840

nrae=682
age_rae=fltarr(nrae)
co2_rae=fltarr(nrae)

age=fltarr(ntmax,nco2)
co2=fltarr(ntmax,nco2)

age(*,*)=!VALUES.F_NAN
co2(*,*)=!VALUES.F_NAN
co2s(*,*,*)=!VALUES.F_NAN
co2m(*,*,*)=!VALUES.F_NAN


; read in the foster c02 and extrapolate
line=''
close,1
openr,1,'foster_loess.dat'
for i=0,nt1-1 do begin
print,i
readf,1,line
linedat=strsplit(line,/EXTRACT)
print,linedat
age(i,0)=linedat(0)
co2(i,0)=linedat(1)
endfor
close,1

age(840,0)=439.0
age(841,0)=500.0
age(842,0)=550.0
age(843,0)=600.0
co2(840,0)=1600.0
co2(841,0)=2800.0
co2(842,0)=3500.0
co2(843,0)=3000.0


; set up the rae co2
close,1
openr,1,'Rae_2021_CO2_wSmooth_edit.csv'
readf,1,line
for i=0,nrae-1 do begin
print,i
readf,1,line
data_row=strsplit(line,',',/extract,/preserve_null)
co2_rae(i)=data_row(11)
age_rae(i)=data_row(1)/1000.0
endfor
close,1

beyond_rae=where(age(*,0) gt age_rae(nrae-1))
aa=size(beyond_rae)

nt(1)=1+nrae+aa(1)

age(0:nt(1)-1,1)=[0,age_rae(0:nrae-1),age(beyond_rae,0)]
co2(0:nt(1)-1,1)=[co2(0,0),co2_rae(0:nrae-1),co2(beyond_rae,0)]

for t=0,ntim-1 do begin

; read in the dates 
close,1
openr,1,timname(t)
for i=0,ns-1 do begin
print,i
readf,1,line
linedat=strsplit(line,/EXTRACT)
print,linedat
cage(i,t)=linedat(0)
linedat1=strsplit(cage(i,t),'_',/EXTRACT)
mil=linedat1(0)
hth=linedat1(1)
ages(i,t)=mil+0.1*hth
endfor
close,1

; do the interpolation
for c=0,nco2-1 do begin
for i=0,ns-1 do begin

for ii=0,nt(c)-1 do begin
if (age(ii,c) le ages(i,t)) then begin
 im=ii 
 ip=im+1
endif
endfor

co2s(i,c,t)=(co2(ip,c)-co2(im,c))*(ages(i,t)-age(im,c))/(age(ip,c)-age(im,c)) +co2(im,c)
co2m(i,c,t)=co2s(i,c,t)*44.01/28970000.0

endfor
endfor


; blended CO2
astart=50
afinis=70
for i=0,ns-1 do begin
if (ages(i,t) le astart) then begin
  wf=0
endif
if (ages(i,t) gt astart and ages(i,t) le afinis) then begin
  wf=(ages(i,t)-astart)/(afinis-astart)
endif
if (ages(i,t) gt afinis) then begin
  wf=1
endif
co2s(i,2,t)=co2s(i,0,t)*wf + co2s(i,1,t)*(1.0-wf)
co2m(i,2,t)=co2s(i,2,t)*44.01/28970000.0
endfor

; Rae suggestion
astart=66.0
afinis=75.0
istart=where(ages(*,t) eq astart)
ifinis=where(ages(*,t) eq afinis)
for i=0,ns-1 do begin
if (ages(i,t) le astart) then begin
  co2s(i,3,t)=co2s(i,1,t)
  endif
if (ages(i,t) gt astart and ages(i,t) lt afinis) then begin
  co2s(i,3,t)=(co2s(ifinis,0,t)-co2s(istart,1,t))*(ages(i,t)-astart)/(afinis-astart)+co2s(istart,1,t)
endif
if (ages(i,t) ge afinis) then begin
  co2s(i,3,t)=co2s(i,0,t)
endif

co2m(i,3,t)=co2s(i,3,t)*44.01/28970000.0

endfor





; write the files
openw,1,'co2_all_02_djl'+extname(t)+'.dat'
for i=0,ns-1 do begin
PRINTf,1,cage(i,t),ages(i,t),co2s(i,0,t),co2m(i,0,t), FORMAT = '(1x,a,1x,2f10.2,1x,E12.5)'
endfor
close,1

openw,1,'co2_all_03'+extname(t)+'.dat'
for i=0,ns-1 do begin
PRINTf,1,cage(i,t),ages(i,t),co2s(i,3,t),co2m(i,3,t), FORMAT = '(1x,a,1x,2f10.2,1x,E12.5)'
endfor
close,1


endfor ; end t/ntim


; make some plots

nstage=10
stageb=fltarr(nstage+1)
stageb(*)=-1.0*[0,66.0,145.0,201.3,251.902,298.9,358.9,419.2,443.8,485.4,541.0]
stagen=strarr(nstage)
stagen(*)=['Cenozoic','Cretaceous','Jurassic','Triassic','Permian','Carb.','Devonian','Sil.','Ord.','Cambrian']

nplot=2
xmin=fltarr(nplot)
xmax=fltarr(nplot)
ymin=fltarr(nplot)
ymax=fltarr(nplot)
plotname=strarr(nplot)

xmin(*)=[-550,-100]
xmax(*)=[0,0]
ymin(*)=[0,0]
ymax(*)=[4000,2000]
plotname(*)=['a','b']

loadct,39

for p=0,nplot-1 do begin

topbar=ymin(p)+(ymax(p)-ymin(p))*33.0/35.0
dtopbar=(ymax(p)-ymin(p))*0.6/35.0

device,filename='co2_'+plotname(p)+'.eps',/encapsulate,/color,set_font='Helvetica'

plot,ages(*,0)*(-1),co2s(*,0),yrange=[ymin(p),ymax(p)],xrange=[xmin(p),xmax(p)],xtitle='Myrs BP',psym=2,/nodata,ytitle='CO2 [ppmv]',ystyle=1,xstyle=1

for t=0,ntim-1 do begin

for s=0,ns-1 do begin
plots,ages(s,t)*(-1),co2s(s,0,t),color=0,psym=5,symsize=0.5*timfact(t);,NOCLIP=0
endfor

for s=0,ns-1 do begin
plots,ages(s,t)*(-1),co2s(s,1,t),color=0,psym=6,symsize=1.5*timfact(t);,NOCLIP=0
endfor

for s=0,ns-1 do begin
plots,ages(s,t)*(-1),co2s(s,3,t),color=250,psym=4,symsize=2*timfact(t);,NOCLIP=0
endfor

endfor


oplot,age(0:nt(0)-1,0)*(-1),co2(0:nt(0)-1,0),thick=1,color=100

oplot,age_rae*(-1),co2_rae,thick=1,color=200



oplot,[xmin(p),xmax(p)],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax(p)]
endfor
for n=0,nstage-1 do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7
endfor


device,/close

endfor


stop

end
