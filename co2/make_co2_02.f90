program co2_phran
  implicit none
  !
  real age(844)
  real co2(844)
  character*100 cage,cage1,cage2
  integer ii,im,ip,i
  real age1,age2,ages,co2s,co2m
  !
  open(unit=10,file='foster_loess.dat')
  do i=1,840
     read(10,*)age(i),co2(i)
  end do
  close(unit=10)
  !
  age(841)=439.0
  age(842)=500.0
  age(843)=550.0
  age(844)=600.0
  co2(841)=1600.0
  co2(842)=2800.0
  co2(843)=3500.0
  co2(844)=3000.0
  !
  print*,' Enter age in xxx_x Ma format '
  read(5,*)cage
  !
  ii=index(trim(cage),'_')
  cage1=cage(1:ii-1)
  cage2=cage(ii+1:len(cage)) 
  !
  read(cage1,*)age1
  read(cage2,*)age2
  ages=age1+0.1*age2
  !
  im=0
  do ii=1,844
     if (age(ii).le.ages) im=ii
  end do
  ip=im+1
  co2s=(co2(ip)-co2(im))*(ages-age(im))/(age(ip)-age(im)) + co2(im)
  print '(i5,10f10.3)',im,age(im),ages,age(ip),co2(im),co2s,co2(ip)
  co2m=co2s*44.01/28970000.0
  write(10,'(1x,a,1x,2f10.2,1x,1p,e12.5)')trim(cage),ages,co2s,co2m
!
  stop
end program co2_phran
