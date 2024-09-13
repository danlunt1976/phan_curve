begin

expname="EXP"
exrname="EXR"
age="AGE"
doplot=DOPLOT

exp_dir="/home/bridge/swsvalde/ummodel/data"
exr_dir="/home/bridge/swsvalde/ummodel/data"

g3=addfile(exr_dir+"/"+exrname+"/inidata/"+exrname+".qrparm.omask.nc","r")
my_lsm=g3->lsm(:,:)
g2=addfile(exr_dir+"/"+exrname+"/merid_ocn/"+exrname+"o.meridclann.nc","r")
my_var_2=g2->Merid_Global(0,:,:)

g1=addfile(exp_dir+"/"+expname+"/merid_ocn/"+expname+"o.meridclann.nc","r")
my_var_1=g1->Merid_Global(0,:,:)

; to blank out continous ocean 
do j=0,72
if (max(my_lsm(j,:)) .eq. 0) then
  my_var_2(:,j)=my_var_2@_FillValue
  my_var_1(:,j)=my_var_1@_FillValue
end if 
end do


my_cmap="BlueDarkRed18"
my_max=24
my_min=-24
my_del=2
my_max2=120
my_min2=-120
my_del2=8


wks_type="pdf"
wks_type@wkPaperWidthF=8.2
wks_type@wkPaperHeightF=5.5
wks=gsn_open_wks(wks_type,"plots/merid_"+expname)

res=True
res@tiMainString="Overturning Streamfunction "+expname+" "+age+"Ma"
res@cnFillOn=True
res@cnLinesOn=False
res@lbOrientation="horizontal"
res@cnFillPalette      = my_cmap ; set color map
res@cnFillMode         = "MeshFill"   ; for faster draw
res@gsnFrame     =  False                   ; do not advance the frame
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = my_min
res@cnMaxLevelValF       = my_max
res@cnLevelSpacingF      = my_del
res@gsnDraw      =  False                   ; do not draw the plot
res@gsnMaximize=True
res@gsnPaperMargin=0
res@gsnPaperOrientation="portrait"
res@vpWidthF=1.3
res@vpHeightF=0.6

res@trYReverse              = True 
res@gsnYAxisIrregular2Linear = True

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
  cres2@cnLineColor = "gray40"

map = gsn_csm_contour(wks,my_var_1,res)
map2 = gsn_csm_contour(wks,my_var_1,cres2)
overlay(map,map2)
if (doplot .eq. 1) then
draw(map)
end if
frame(wks)

wks=gsn_open_wks(wks_type,"plots/merid_"+exrname)
res@tiMainString="Overturning Streamfunction "+exrname
map = gsn_csm_contour(wks,my_var_2,res)
if (doplot .eq. 1) then
draw(map)
end if
frame(wks)


end
