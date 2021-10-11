begin

expname="EXP"
root_dir="/home/bridge/ggdjl/ggdjl/bas/doc/phan_curve/islands"

g=addfile(root_dir+"/"+expname+"/islands_"+expname+"_newislands.nc","r")
islands=g->islands(:,:)
lat=g->latitude
lon=g->longitude

my_cmap="GMT_paired"
my_max=9.5
my_min=-0.5
my_del=1.0

wks=gsn_open_wks("pdf","newislands_"+expname)
res=True
res@tiMainString="Islands "+expname
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

map = gsn_csm_contour_map(wks,islands,res)

draw(map)

frame(wks)


end
