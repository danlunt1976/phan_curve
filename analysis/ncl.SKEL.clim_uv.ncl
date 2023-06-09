begin

expname="EXP"
exrname="EXR"
age="AGE"
doplot=DOPLOT
lev=LEV

exp_dir="/home/bridge/swsvalde/ummodel/data"
exr_dir="/home/bridge/swsvalde/ummodel/data"

g3=addfile(exr_dir+"/"+exrname+"/inidata/"+exrname+".qrparm.omask.nc","r")
my_lsm=g3->lsm(:,:)
g2=addfile(exr_dir+"/"+exrname+"/climate/"+exrname+"o.pgclann.nc","r")
my_var_2_u=g2->ucurrTot_ym_dpth(0,LEV,:,:)
my_var_2_v=g2->vcurrTot_ym_dpth(0,LEV,:,:)

if (doplot .eq. 1) then
g1=addfile(exp_dir+"/"+expname+"/climate/"+expname+"o.pgclann.nc","r")
my_var_1_u=g1->ucurrTot_ym_dpth(0,LEV,:,:)
my_var_1_v=g1->vcurrTot_ym_dpth(0,LEV,:,:)

else 
my_var_1=my_lsm
end if

if (lev .eq. 0) then
levshort="00"
levlong="5m"
myscal=1.0
end if
if (lev .eq. 11) then
levshort="11"
levlong="670m"
myscal=0.2
end if
if (lev .eq. 15) then
levshort="15"
levlong="2700m"
myscal=0.05
end if

vmax=80.0*myscal
vinc=5.0*myscal
varr=5.0*myscal



my_var_2_t=sqrt(my_var_2_u*my_var_2_u+my_var_2_v*my_var_2_v)
my_var_1_t=sqrt(my_var_1_u*my_var_1_u+my_var_1_v*my_var_1_v)



my_cmap = read_colormap_file("BlAqGrYeOrReVi200")


wks_type="pdf"
wks_type@wkPaperWidthF=8.2
wks_type@wkPaperHeightF=5.5
wks=gsn_open_wks(wks_type,"plots/uv_"+expname+"_"+levshort)

res=True
res@tiMainString="UV "+expname+" "+age+"Ma"+" : "+levlong
res@lbOrientation="horizontal"
res@mpCenterLonF=0
res@mpOutlineOn=False
res@gsnFrame     =  False                   ; do not advance the frame
res@gsnAddCyclic         = True           ; add longitude cyclic point
res@gsnDraw      =  False                   ; do not draw the plot
res@gsnMaximize=True
res@gsnPaperMargin=0
res@gsnPaperOrientation="portrait"
res@mpFillOn     = False

res@vcRefMagnitudeF         = varr              ; make vectors larger
res@vcRefLengthF            = 0.050            ; ref vec length
res@vcGlyphStyle            = "CurlyVector"    ; turn on curly vectors
res@vcMinDistanceF          = 0.01            ; thin out vectors
res@vcLevelPalette      = my_cmap(6:193,:)
res@vcVectorDrawOrder       = "PostDraw"        ; draw vectors last

res@vcLevelSelectionMode = "ManualLevels"     ; set manual contour levels
res@vcMinLevelValF       = 0               ; set min contour level
res@vcMaxLevelValF       = vmax                 ; set max contour level
res@vcLevelSpacingF      = vinc               ; set contour spacing

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
  cres@cnLineThicknessF = 1

plot=gsn_csm_vector_scalar_map_ce(wks,my_var_1_u,my_var_1_v,my_var_1_t,res)  ; create plot

map2 = gsn_csm_contour(wks,my_lsm,cres) 
overlay(plot,map2)
if (doplot .eq. 1) then
draw(plot)
end if

frame(wks)

wks=gsn_open_wks(wks_type,"plots/uv_"+exrname+"_"+levshort)
res@tiMainString="UV "+exrname
plot=gsn_csm_vector_scalar_map_ce(wks,my_var_2_u,my_var_2_v,my_var_2_t,res)  ; create plot
map2 = gsn_csm_contour(wks,my_lsm,cres) 
overlay(plot,map2)
draw(plot)
frame(wks)



end
