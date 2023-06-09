begin

exrname="EXR"
expname="EXP"
age="AGE"
doplot=DOPLOT

exr_dir="/home/bridge/swsvalde/ummodel/data"

g3=addfile(exr_dir+"/"+exrname+"/inidata/"+exrname+".qrparm.omask.nc","r")
my_lsm=g3->lsm(:,:)
my_dpt=g3->depthdepth(:,:)
my_dpt=my_dpt*-1.0

g2=addfile(exr_dir+"/"+exrname+"/inidata/"+exrname+".qrparm.orog.nc","r")
my_oro=g2->ht(0,0,:,:)

g1=addfile(exr_dir+"/"+exrname+"/inidata/"+exrname+".qrfrac.type.nc","r")
my_ice=g1->field1391(0,8,:,:)

nx=96
ny=73
do j=0,ny-1
do i=0,nx-1
 if(ismissing(my_ice(j,i))) then
   my_ice(j,i)=0.0
 end if
end do
end do

my_cmap="GMT_globe"

wks_type="pdf"
wks_type@wkPaperWidthF=8.2
wks_type@wkPaperHeightF=5.5
wks=gsn_open_wks(wks_type,"plots/topo_"+expname)

res=True
res@tiMainString="Topography "+expname+" "+age+"Ma"
res@cnFillOn=True
res@cnLinesOn=False
res@lbOrientation="horizontal"
res@mpCenterLonF=0
res@mpOutlineOn=False
res@cnFillPalette      = my_cmap ; set color map
res@cnFillMode         = "MeshFill"   ; for faster draw
res@gsnFrame     =  False                   ; do not advance the frame
res@cnLevelSelectionMode = "ManualLevels"
res@cnMinLevelValF       = -4000
res@cnMaxLevelValF       = 4000
res@cnLevelSpacingF      = 200
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
  cres@cnLineColor = "gray20"

  cres2=True
  cres2@cnInfoLabelOn     = False
  cres2@gsnLeftString          = ""
  cres2@gsnRightString          = ""
  cres2@cnLineLabelsOn       = False            ; do not use line labels
  cres2@gsnDraw              = False             ; do not draw the plot
  cres2@gsnFrame             = False             ; do not advance the frame
  cres2@cnLevelSelectionMode = "ExplicitLevels"  ; use explicit levels
  cres2@cnLevels             = 0.5   ; set the contour levels
  cres2@gsnAddCyclic         = True           ; add longitude cyclic point
  cres2@cnLineColor = "yellow"
  cres2@cnLineThicknessF=5
  cres2@cnConstFLabelOn  = False

res3=True
res3@cnFillOn=True
res3@cnLinesOn=False
res3@lbOrientation="horizontal"
res3@cnFillPalette      = my_cmap ; set color map
res3@cnFillMode         = "MeshFill"   ; for faster draw
res3@gsnFrame     =  False                   ; do not advance the frame
res3@cnLevelSelectionMode = "ManualLevels"
res3@cnMinLevelValF       = -4000
res3@cnMaxLevelValF       = 4000
res3@cnLevelSpacingF      = 200
res3@gsnAddCyclic         = True           ; add longitude cyclic point
res3@gsnDraw      =  False                   ; do not draw the plot

map = gsn_csm_contour_map(wks,my_oro,res)
map2 = gsn_csm_contour(wks,my_dpt,res3)
map3 = gsn_csm_contour(wks,my_lsm,cres)
map4 = gsn_csm_contour(wks,my_ice,cres2)

overlay(map,map2)
overlay(map,map3)
overlay(map,map4)
if (doplot .eq. 1) then
draw(map)
end if

frame(wks)

end

