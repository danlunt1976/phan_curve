pro mc

set_plot,'ps'
!P.FONT=0

; set up arrays
nco2=2
; 0 = foster
; 1 = rae

nco2f=6
; 0 = foster
; 1 = foster | rae
; 2 = foster blended rae
; 3 = foster rae rae
; 4 = inferred
; 5 = mean forcing of foster blended rae

dowrite=intarr(nco2f)
dowrite(*)=[0,0,0,0,0,1]

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
astartb=50
afinisb=70
for i=0,ns-1 do begin
if (ages(i,t) le astartb) then begin
  wf=0
endif
if (ages(i,t) gt astartb and ages(i,t) le afinisb) then begin
  wf=(ages(i,t)-astartb)/(afinisb-astartb)
endif
if (ages(i,t) gt afinisb) then begin
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

; Inferred
if (t eq 1) then begin
dates2=fltarr(ns)
co2_inf_1m=fltarr(ns)

openr,1,'../analysis/co2_inferred.dat'
readf,1,dates2
readf,1,co2_inf_1m
close,1

for i=0,ns-1 do begin
co2s(i,4,t)=co2_inf_1m(i)
co2m(i,4,t)=co2s(i,2,t)*44.01/28970000.0
endfor

endif


; Inferred
if (t eq 1) then begin

co2_const= exp(mean(alog(co2s(*,4,1))))


for i=0,ns-1 do begin
co2s(i,5,t)=co2_const
co2m(i,5,t)=co2s(i,5,t)*44.01/28970000.0
endfor

endif


; write the files

if (dowrite(0) eq 1) then begin
openw,1,'co2_all_02_djl'+extname(t)+'.dat'
for i=0,ns-1 do begin
PRINTf,1,cage(i,t),ages(i,t),co2s(i,0,t),co2m(i,0,t), FORMAT = '(1x,a,1x,2f10.2,1x,E12.5)'
endfor
close,1
endif

if (dowrite(3) eq 1) then begin
openw,1,'co2_all_03'+extname(t)+'.dat'
for i=0,ns-1 do begin
PRINTf,1,cage(i,t),ages(i,t),co2s(i,3,t),co2m(i,3,t), FORMAT = '(1x,a,1x,2f10.2,1x,E12.5)'
endfor
close,1
endif

if (dowrite(4) eq 1) then begin
if (t eq 1) then begin
openw,1,'co2_all_04'+extname(t)+'.dat'
for i=0,ns-1 do begin
PRINTf,1,cage(i,t),ages(i,t),co2s(i,4,t),co2m(i,4,t), FORMAT = '(1x,a,1x,2f10.2,1x,E12.5)'
endfor
close,1
endif
endif

if (dowrite(5) eq 1) then begin
if (t eq 1) then begin
openw,1,'co2_all_05'+extname(t)+'.dat'
for i=0,ns-1 do begin
PRINTf,1,cage(i,t),ages(i,t),co2s(i,5,t),co2m(i,5,t), FORMAT = '(1x,a,1x,2f10.2,1x,E12.5)'
endfor
close,1
endif
endif


endfor ; end t/ntim


; make some plots

nstage=10
stageb=fltarr(nstage+1)
stageb(*)=-1.0*[0,66.0,145.0,201.3,251.902,298.9,358.9,419.2,443.8,485.4,541.0]
stagen=strarr(nstage)
stagen(*)=['Cenozoic','Cretaceous','Jurassic','Triassic','Permian','Carb.','Devonian','Sil.','Ord.','Cambrian']

nplot=3
xmin=fltarr(nplot)
xmax=fltarr(nplot)
ymin=fltarr(nplot)
ymax=fltarr(nplot)
plotname=strarr(nplot)
myclip=intarr(nplot)
stageend=intarr(nplot)
mythick=fltarr(nplot)
xmin(*)=[-550,-100,-100]
xmax(*)=[0,5,5]
ymin(*)=[0,0,0]
ymax(*)=[4000,2000,2000]
plotname(*)=['a','b','c']
myclip(*)=[1,0,0]
stageend=[nstage-1,0,0]
mythick=[1,1,4]

loadct,39

for p=0,nplot-1 do begin

topbar=ymin(p)+(ymax(p)-ymin(p))*33.0/35.0
dtopbar=(ymax(p)-ymin(p))*0.6/35.0

device,filename='co2_'+plotname(p)+'.eps',/encapsulate,/color,set_font='Helvetica'

plot,ages(*,0)*(-1),co2s(*,0),yrange=[ymin(p),ymax(p)],xrange=[xmin(p),xmax(p)],xtitle='Ma BP',psym=2,/nodata,ytitle='CO!D2!N [ppmv]',ystyle=1,xstyle=1

oplot,age(0:nt(0)-1,0)*(-1),co2(0:nt(0)-1,0),thick=mythick(p),color=100

oplot,age_rae*(-1),co2_rae,thick=mythick(p),color=200

for t=0,ntim-1 do begin

for s=0,ns-1 do begin
; plot Foster CO2
if (t ne 1 or p ne 2) then begin; don't plot if new times and paper plot
plots,ages(s,t)*(-1),co2s(s,0,t),color=0,psym=5,symsize=1.0*timfact(t),NOCLIP=myclip(p),thick=mythick(p)
endif
endfor

if (p ne 2) then begin
; plot foster rae CO2
for s=0,ns-1 do begin
plots,ages(s,t)*(-1),co2s(s,1,t),color=0,psym=6,symsize=1.5*timfact(t),NOCLIP=myclip(p),thick=mythick(p)
endfor
endif

for s=0,ns-1 do begin
; plot foster rae rae CO2
if (t ne 0 or p ne 2) then begin; don't plot if old times and paper plot
plots,ages(s,t)*(-1),co2s(s,3,t),color=250,psym=4,symsize=2*timfact(t),NOCLIP=myclip(p),thick=mythick(p)
endif

if (t ne 0 and p eq 0) then begin; only plto on all plot
plots,ages(s,t)*(-1),co2s(s,5,t),color=200,psym=4,symsize=2*timfact(t),NOCLIP=myclip(p),thick=mythick(p)
endif


endfor



endfor

if (p eq 2) then begin
; plot blending

oplot,[astart,afinis]*(-1),[co2s(istart,3,1),co2s(ifinis,3,1)],thick=0.5,linestyle=2

endif

if (p eq 2) then begin
; plot legend

xls=-40
xll=10
yls=1700
dyl=120
dyl2=-20
dxl=2.5
mycharsize=1

; foster
oplot,[xls,xls+xll],[yls,yls],thick=mythick(p),color=100
plots,xls+xll/2.0,yls,thick=mythick(p),color=0,psym=5,symsize=1*timfact(0)
xyouts,xls+xll+dxl,yls+dyl2,color=0,charsize=mycharsize,'CO!L2!N Foster et al (2017)'

; rae line
oplot,[xls,xls+xll],[yls-dyl,yls-dyl],thick=mythick(p),color=200
plots,xls+xll/2.0,yls-dyl,thick=mythick(p),color=250,psym=4,symsize=2*timfact(1)
xyouts,xls+xll+dxl,yls-dyl+dyl2,color=0,charsize=mycharsize,'CO!L2!N this study'

endif



oplot,[xmin(p),xmax(p)],[topbar,topbar]
for n=1,nstage-1 do begin
oplot,[stageb(n),stageb(n)],[topbar,ymax(p)]
endfor
for n=0,stageend(p) do begin
xyouts,(stageb(n)+stageb(n+1))/2.0,topbar+dtopbar,alignment=0.5,stagen(n),charsize=0.7,NOCLIP=myclip(p)
endfor


device,/close

endfor


stop

end
