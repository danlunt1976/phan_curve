begin

expname="EXP"
exrname="EXR"
age="AGE"
doplot=DOPLOT
flip=FLIP
mymask=MASK

exp_dir="/home/bridge/swsvalde/ummodel/data"
exr_dir="/home/bridge/swsvalde/ummodel/data"

g3=addfile(exr_dir+"/"+exrname+"/inidata/"+exrname+".qrparm.omask.nc","r")
my_lsm=g3->lsm(:,:)
g2=addfile(exr_dir+"/"+exrname+"/climate/"+exrname+"CODE.TYPclann.nc","r")
my_var_2=g2->VAR(0,0,:,:)
my_var_2=mask(my_var_2,my_lsm,0)

if (doplot .eq. 1) then
g1=addfile(exp_dir+"/"+expname+"/climate/"+expname+"CODE.TYPclann.nc","r")
my_var_1=g1->VAR(0,0,:,:)
if (mymask .eq. 1) then
my_var_1=mask(my_var_1,my_lsm,0)
end if
else 
my_var_1=my_lsm
end if



my_cmap="COL"
my_max=MAX
my_min=MIN
my_del=DEL

my_max2=MX2
my_min2=MN2
my_del2=DL2

wks_type="pdf"
wks_type@wkPaperWidthF=8.2
wks_type@wkPaperHeightF=5.5
wks=gsn_open_wks(wks_type,"plots/VSHORT_"+expname)

res=True
res@tiMainString="VLONG "+expname+" "+age+"Ma"
res@cnFillOn=True
res@cnLinesOn=False
res@lbOrientation="horizontal"
res@mpCenterLonF=0
res@mpOutlineOn=False
res@cnFillPalette      = my_cmap ; set color map
res@cnFillMode         = "MeshFill"   ; for faster draw
res@gsnFrame     =  False                   ; do not advance the frame
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = my_min
res@cnMaxLevelValF       = my_max
res@cnLevelSpacingF      = my_del
res@gsnAddCyclic         = True           ; add longitude cyclic point
res@gsnDraw      =  False                   ; do not draw the plot
res@gsnMaximize=True
res@gsnPaperMargin=0
res@gsnPaperOrientation="portrait"
res@mpFillOn     = False



  cres=True
  cres@cnInfoLabelOn     = False
  cres@gsnLeftString          = ""
  cres@gsnRightString          = ""
  cres@cnLineLabelsOn       = False            ; do not use line labels
  cres@gsnDraw              = False             ; do not draw the plot
  cres@gsnFrame             = False             ; do not advance the frame
  cres@cnLevelSelectionMode = "ExplicitLevels"  ; use explicit levels
  cres@cnLevels             = 0.5   ; set the contour levels
  cres@gsnAddCyclic         = True           ; add longitude cyclic point
  cres@cnLineColor = "gray80"

  cres2=True
  cres2@cnInfoLabelOn     = False
  cres2@gsnLeftString          = ""
  cres2@gsnRightString          = ""
  cres2@cnLineLabelsOn       = False            ; do not use line labels
  cres2@gsnDraw              = False             ; do not draw the plot
  cres2@gsnFrame             = False             ; do not advance the frame
  cres2@cnLevelSelectionMode = "ManualLevels"
  cres2@cnMinLevelValF       = my_min2
  cres2@cnMaxLevelValF       = my_max2
  cres2@cnLevelSpacingF      = my_del2
  cres2@gsnAddCyclic         = True           ; add longitude cyclic point


if (flip .eq. 1) then
printVarSummary(my_var_1)
xx=my_var_1
do j=0,72
do i=0,95
yy=xx(j,i)
my_var_1(72-j,i)=yy
end do
end do
end if

map = gsn_csm_contour_map(wks,my_var_1,res)
map2 = gsn_csm_contour(wks,my_lsm,cres)
map3 = gsn_csm_contour(wks,my_var_1,cres2)
overlay(map,map2)
overlay(map,map3)
if (doplot .eq. 1) then
draw(map)
end if

frame(wks)

wks=gsn_open_wks(wks_type,"plots/VSHORT_"+exrname)
res@tiMainString="VLONG "+exrname
map = gsn_csm_contour_map(wks,my_var_2,res)
map2 = gsn_csm_contour(wks,my_lsm,cres) 
map3 = gsn_csm_contour(wks,my_var_2,cres2)
overlay(map,map2)
overlay(map,map3)
draw(map)
frame(wks)

end
