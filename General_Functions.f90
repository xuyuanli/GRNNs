!  General_Functions.f90
!
!  Free-Format Fortran Source File 
!  Generated by PGI Visual Fortran(R)
!  3/8/2013 4:30:19 PM
!  Compiled by XUYUAN LI
!  The University of Adelaide
!  Open sources code (application version) for the following journal paper:
!********************************************************************
! Li X., Zecchin A.C. and Maier H.R. 2014, 'Selection of smoothing parameter estimators 
! for General Regression Neural Networks - applications to hydrological and water resources modelling', 
! Environmental Modelling and Software, accepted May 6, 2014
!********************************************************************

! Contains:
! 1.Standard deviation
! 2.Kurtosis
! 3.GRNN (multi-to-one mapping)
! 4.Performance Criteria (Dawson et al. 2007)
!   4.1 Statistical parameters of observed & modelled data (Statistical summary)(min,max,mean,var,skew,k)
!   4.2 Statistical parameters of residual errors (Absolute parameters)(RMSE)
!   4.3 Statistical parameters of residual errors (Relative parameters)(MARE)
!   4.4 Statistical parameters of residual errors (Dimensionless parameters)(CE,IoAd,PI,MCE,MIoAd,MPI)

Module GFS
contains

!******************stdev of data************
!stdev
subroutine sd(a,n,b)
implicit none
real(8),intent(in)::a(:)
integer(8),intent(in)::n
real(8),intent(out)::b(:)
integer(8)::i
real(8)::ave,sda

ave=0.0
do i=1,n
   ave=ave+a(i)
end do
ave=ave/real(n)   

sda=0.0
do i=1,n
   sda=sda+(a(i)-ave)**2.0
end do
sda=dsqrt(sda/real(n-1))  

do i=1,n
   b(i)=(a(i)-ave)/sda
end do
   
end subroutine 
!***************End sd of data***************



!******************stdev of data*************
!stdev
subroutine sds(a,n,sda)
implicit none
real(8),intent(in)::a(:)
integer(8),intent(in)::n
real(8),intent(out)::sda
integer(8)::i
real(8)::ave

ave=0.0
do i=1,n
   ave=ave+a(i)
end do
ave=ave/real(n)   

sda=0.0
do i=1,n
   sda=sda+(a(i)-ave)**2.0
end do
sda=dsqrt(sda/real(n-1))  
   
end subroutine 
!***************End sd of data***************



!**************Mean**************************
subroutine aves(a,n,means)
implicit none
real(8),intent(in)::a(:)
integer(8),intent(in)::n
real(8),intent(out)::means
integer(8)::i

means=0.0
 do i=1,n
    means=means+a(i)
 end do   
means=means/real(n)

end subroutine
!***********End Mean************************




!**************Skewness*********************
!(n/(n-1)/(n-2))*(sum(xj-ave)/s)^3
subroutine skews(a,n,g)
implicit none
real(8),intent(in)::a(:)
integer(8),intent(in)::n
real(8),intent(out)::g
integer(8)::i
real(8)::p1,p2

p1=0.0
do i=1,n
   p1=p1+a(i)
end do   
p1=p1/real(n)

p2=0.0
do i=1,n
   p2=p2+(a(i)-p1)**2.0
end do
p2=dsqrt(p2/real(n-1))

g=0.0
do i=1,n
   g=g+((a(i)-p1)/p2)**3.0
end do   
g=g*real(n/(n-1.0)/(n-2.0))

end subroutine
!***********End Skewness**************


!******************Kurtosis of data******
!Kurtosis
!n*(n+1)/(n-1)/(n-2)/(n-3)*CM4/(CM2^2)-3*(n-1)**2.0/(n-2)/(n-3)
subroutine kurt(a,n,kt)
implicit none
real(8),intent(in)::a(:)
integer(8),intent(in)::n
real(8),intent(out)::kt
integer(8)::i
real(8)::ave,sum1,sum2

ave=0.0
do i=1,n
   ave=ave+a(i)
end do
ave=ave/real(n)   

sum2=0.0
do i=1,n
   sum2=sum2+(a(i)-ave)**2.0
end do
sum2=dsqrt(sum2/real(n-1.0))

sum1=0.0
do i=1,n
   sum1=sum1+((a(i)-ave)/sum2)**4.0
end do

kt=sum1*n*(n+1.0)/(n-1.0)/(n-2.0)/(n-3.0)-3.0*(n-1.0)**2.0/(n-2.0)/(n-3.0)
   
end subroutine 
!***************End Kurtosis****************



!*********************GRNN********************
subroutine GRNN(xrec,yrec,r,c,h,yest)   !inputs records; output records, row no., column no., bandwidths, estimated ouput
implicit none
real(8),intent(in)::xrec(:,:),yrec(:),h(:)
integer(8),intent(in)::r,c
real(8),intent(out)::yest(:)
integer(8)::c1,c2,c3
real(8),allocatable::aj(:)
real(8)::num,den,sum1,ho   !,dis

allocate(aj(r))

do c1=1,r    
      num=0.0
      den=0.0
      
      do c2=1,r   
         if (c2==c1) then
            num=num
            den=den
         else 
            sum1=0.0
            do c3=1,c
               sum1=sum1+(xrec(c2,c3)-xrec(c1,c3))**2.0/2.0/h(c3)**2.0
            end do   
            
            ho=h(1)
            do c3=2,c
               ho=ho*h(c3)
            end do 
             
            aj(c2)=exp(-sum1)/ho
            num=num+yrec(c2)*aj(c2)
            den=den+aj(c2)          
         end if 
      end do
       
                   
       if (dabs(den)<1.0*10.0**(-6.0)) then
           yest(c1)=num/10.0**(-6.0)     !warning: den=0.0
       else   
           yest(c1)=num/den !estimated output   
       end if                 
end do 

deallocate(aj)

end subroutine
!********************End GRNN****************



!************Performance Criteria************
!Concept refers to Dawson et al. 2007
!Input1: observed data; Input2: modelled data
!1.1 Statistical parameters of observed & modelled data (Statistical summary)
!recall previous subroutine
subroutine SPOM(output1,output2,n1,mind,maxd,aved,vard,skewd,kurtd)
implicit none

real(8),intent(in)::output1(:),output2(:)
real(8),intent(out)::mind,maxd,aved,vard,skewd,kurtd
integer(8),intent(in)::n1
real(8)::sdv1,sdv2,kt1,kt2,ave1,ave2,sk1,sk2

!Minimum
mind=dabs((minval(output2)-minval(output1))/minval(output1))

!Maximum
maxd=dabs((maxval(output2)-maxval(output1))/maxval(output1))

!Mean
call aves(output1,n1,ave1)
call aves(output2,n1,ave2)
aved=dabs(ave2-ave1)           !mean=0.0 after SD

!Variance
call sds(output1,n1,sdv1)
call sds(output2,n1,sdv2)
vard=dabs((sdv2**2.0-sdv1**2.0)/(sdv1**2.0)) 

!Skewness
call skews(output1,n1,sk1)
call skews(output2,n1,sk2)
skewd=dabs((sk2-sk1)/sk1)  

!Kurtosis
call kurt(output1,n1,kt1)
call kurt(output2,n1,kt2)
kurtd=dabs((kt2-kt1)/kt1)

end subroutine

!1.2 Statistical parameters of residual errors (Absolute parameters)
!Root mean square error
subroutine RMSE(output1,output2,n1,rmsev)
implicit none

real(8),intent(in)::output1(:),output2(:)
integer(8),intent(in)::n1
real(8),intent(out)::rmsev
integer(8)::c1

rmsev=0.0
do c1=1,n1
   rmsev=rmsev+(output1(c1)-output2(c1))**2.0
end do
   rmsev=dsqrt(rmsev/real(n1))   

end subroutine

!1.3 Statistical parameters of residual errors (Relative parameters)
!Mean absolute realtive error
subroutine MARE(output1,output2,n1,marev)
implicit none

real(8),intent(in)::output1(:),output2(:)
integer(8),intent(in)::n1
real(8),intent(out)::marev
integer(8)::c1

marev=0.0
do c1=1,n1
   marev=marev+dabs((output1(c1)-output2(c1))/output1(c1))
end do
marev=marev/real(n1)   

end subroutine

!1.4 Statistical parameters of residual errors (Dimensionless parameters)
!Nash-Sutcliffe efficiency 
subroutine CE(output1,output2,n1,cev)
implicit none
real(8),intent(in)::output1(:),output2(:)
integer(8),intent(in)::n1
real(8),intent(out)::cev
integer(8)::c1
real(8)::ave,sum1,sum2

ave=0.0
do c1=1,n1
   ave=ave+output1(c1)
end do
ave=ave/real(n1)

sum1=0.0
sum2=0.0
do c1=1,n1
   sum1=sum1+(output1(c1)-output2(c1))**2.0
   sum2=sum2+(output1(c1)-ave)**2.0
end do

cev=1.0-sum1/sum2

end subroutine

!Modifided Nash-Sutcliffe efficiency (Krause et al. 2005)
subroutine MCE(output1,output2,n1,mcev)
implicit none
real(8),intent(in)::output1(:),output2(:)
integer(8),intent(in)::n1
real(8),intent(out)::mcev
integer(8)::c1
real(8)::ave,sum1,sum2

ave=0.0
do c1=1,n1
   ave=ave+output1(c1)
end do
ave=ave/real(n1)

sum1=0.0
sum2=0.0
do c1=1,n1
   sum1=sum1+dabs(output1(c1)-output2(c1))
   sum2=sum2+dabs(output1(c1)-ave)
end do

mcev=1.0-sum1/sum2

end subroutine

!Index of agreement
subroutine IoAd(output1,output2,n1,ioadv)
implicit none

real(8),intent(in)::output1(:),output2(:)
integer(8),intent(in)::n1
real(8),intent(out)::ioadv
integer(8)::c1
real(8)::ave,sum1,sum2

ave=0.0
do c1=1,n1
   ave=ave+output1(c1)
end do
ave=ave/real(n1)

sum1=0.0
sum2=0.0
do c1=1,n1
   sum1=sum1+(output1(c1)-output2(c1))**2.0
   sum2=sum2+(dabs(output2(c1)-ave)+dabs(output1(c1)-ave))**2.0
end do

ioadv=1.0-sum1/sum2

end subroutine

!Modifided index of agreement (Krause et al. 2005)
subroutine MIoAd(output1,output2,n1,mioadv)
implicit none

real(8),intent(in)::output1(:),output2(:)
integer(8),intent(in)::n1
real(8),intent(out)::mioadv
integer(8)::c1
real(8)::ave,sum1,sum2

ave=0.0
do c1=1,n1
   ave=ave+output1(c1)
end do
ave=ave/real(n1)

sum1=0.0
sum2=0.0
do c1=1,n1
   sum1=sum1+dabs(output1(c1)-output2(c1))
   sum2=sum2+(dabs(output2(c1)-ave)+dabs(output1(c1)-ave))
end do

mioadv=1.0-sum1/sum2

end subroutine

!Persistence Index
subroutine PI(output1,output2,n1,piv)
implicit none

real(8),intent(in)::output1(:),output2(:)
integer(8),intent(in)::n1
real(8),intent(out)::piv
integer(8)::c1
real(8)::sum1,sum2

sum1=0.0
do c1=2,n1
   sum1=sum1+(output1(c1)-output2(c1))**2.0  
end do

sum2=0.0
do c1=2,n1
   sum2=sum2+(output1(c1)-output1(c1-1))**2.0  
end do

piv=1.0-sum1/sum2

end subroutine

!Modifided Persistence Index
subroutine MPI(output1,output2,n1,piv)
implicit none

real(8),intent(in)::output1(:),output2(:)
integer(8),intent(in)::n1
real(8),intent(out)::piv
integer(8)::c1
real(8)::sum1,sum2

sum1=0.0
do c1=2,n1
   sum1=sum1+dabs(output1(c1)-output2(c1)) 
end do

sum2=0.0
do c1=2,n1
   sum2=sum2+dabs(output1(c1)-output1(c1-1)) 
end do

piv=1.0-sum1/sum2

end subroutine

end Module