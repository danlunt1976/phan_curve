begin

expname="EXP"
exrname="EXR"
doplot=DOPLOT

exp_dir="/home/bridge/ggdjl/um_climates"
exr_dir="/home/bridge/swsvalde/ummodel/data"

g3=addfile(exr_dir+"/"+exrname+"/inidata/"+exrname+".qrparm.omask.nc","r")
my_lsm=g3->lsm(:,:)
g2=addfile(exr_dir+"/"+exrname+"/climate/"+exrname+"o.TYPclann.nc","r")
my_var_2=g2->VAR(0,0,:,:)
my_var_2=mask(my_var_2,my_lsm,0)

if (doplot .eq. 1) then
g1=addfile(exp_dir+"/"+expname+"/"+expname+"o.TYPclann.nc","r")
my_var_1=g1->VAR(0,0,:,:)
my_var_1=mask(my_var_1,my_lsm,0)
else 
my_var_1=my_lsm
end if



my_cmap="COL"
my_max=MAX
my_min=MIN
my_del=DEL

wks_type="pdf"
wks_type@wkPaperWidthF=8.2
wks_type@wkPaperHeightF=5.5
wks=gsn_open_wks(wks_type,"plots/VSHORT_"+expname)

res=True
res@tiMainString="Streamfunction "+expname
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

map = gsn_csm_contour_map(wks,my_var_1,res)
map2 = gsn_csm_contour(wks,my_lsm,cres) 
overlay(map,map2)
if (doplot .eq. 1) then
draw(map)
end if

frame(wks)

wks=gsn_open_wks(wks_type,"plots/VSHORT_"+exrname)
res@tiMainString="VLONG "+exrname
map = gsn_csm_contour_map(wks,my_var_2,res)
map2 = gsn_csm_contour(wks,my_lsm,cres) 
overlay(map,map2)
draw(map)
frame(wks)

end
