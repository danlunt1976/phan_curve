begin

expname="EXP"
exrname="EXR"
doplot=DOPLOT

exp_dir="/home/bridge/ggdjl/um_climates"
exr_dir="/home/bridge/swsvalde/ummodel/data"

g3=addfile(exr_dir+"/"+exrname+"/inidata/"+exrname+".qrparm.mask.nc","r")
my_lsm=g3->lsm(0,0,:,:)

if (doplot .eq. 1) then
g1=addfile(exp_dir+"/"+expname+"/"+expname+"a.pdclann.nc","r")
g2=addfile(exr_dir+"/"+exrname+"/climate/"+exrname+"a.pdclann.nc","r")
my_var_1=g1->temp_mm_1_5m(0,0,:,:)
my_var_2=g2->temp_mm_1_5m(0,0,:,:)
my_var=my_var_1
my_var=my_var_1-my_var_2
else 
my_var=my_lsm
end if



my_cmap="BlueDarkRed18"
my_max=5.0
my_min=-5.0
my_del=1.0

wks_type="pdf"
wks_type@wkPaperWidthF=8.2
wks_type@wkPaperHeightF=5.5
wks=gsn_open_wks(wks_type,"plots/temp_"+expname+"-"+exrname)

res=True
res@tiMainString="1.5m air temperature "+expname+"-"+exrname
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



  cres=True
  cres@cnInfoLabelOn     = False
  cres@gsnLeftString          = ""
  cres@gsnRightString          = ""
  cres@cnLineLabelsOn       = False            ; do not use line labels
  cres@gsnDraw              = False             ; do not draw the plot
  cres@gsnFrame             = False             ; do not advance the frame
  cres@cnLevelSelectionMode = "ExplicitLevels"  ; use explicit levels
  cres@cnLevels             = fspan(-5,5,10)   ; set the contour levels
  cres@gsnAddCyclic         = True           ; add longitude cyclic point

map = gsn_csm_contour_map(wks,my_var,res)
map2 = gsn_csm_contour(wks,my_lsm,cres) 

overlay(map,map2)

if (doplot .eq. 1) then
draw(map)
end if

frame(wks)


end
