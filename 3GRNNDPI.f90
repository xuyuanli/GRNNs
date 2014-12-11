!  GRNNDPI_test.f90
!
!  Free-Format Fortran Source File 
!  Generated by PGI Visual Fortran(R)
!  3/11/2013 2:54:03 PM
!  Compiled by XUYUAN LI
!  The University of Adelaide
!  Open sources code (application version) for the following journal paper:
!  ********************************************************************
!  Li X., Zecchin A.C. and Maier H.R. 2014, 'Selection of smoothing parameter estimators 
!  for General Regression Neural Networks - applications to hydrological and water resources modelling', 
!  Environmental Modelling and Software, accepted May 6, 2014
!  ********************************************************************

Module GRNN_DPI
  use GFS
  contains

!***********************2-stage DPI**************************
!Function factorial
integer(8) function fact(x)
implicit none
integer(8),intent(in)::x
integer(8)::i

fact=x
do i=1,(x-1)
   fact=fact*(x-i)
end do

end function

!Psi estimation with normal density (Wand& Jones 1995) pp.72
real(8) function psiNS(o,sd1)
implicit none
integer(8),intent(in)::o
real(8),intent(in)::sd1  !order, data standard deviation, Psi at given order

psiNS=((-1.0)**(o/2.0)*fact(o))/((2*sd1)**(o+1.0)*fact(o/2)*3.141592653**0.5)

end function

!Generl Psi estimation (Wand& Jones 1995) pp.67
!K(6),K(4) derived by XUYUAN LI
subroutine psi6(x,g,n1,psiv)
implicit none
real(8),intent(in)::x(:),g  !input, pilot bandwidth, general psi at given order
integer(8),intent(in)::n1
real(8),intent(out)::psiv   !general psi at given order
integer(8)::c1,c2
real(8)::sum1,sum2

sum1=0.0
sum2=0.0
do c1=1,n1
   do c2=1,n1
      sum1=(x(c1)-x(c2))**2.0/2.0/g**2.0   
      sum2=sum2+(-15.0*dexp(-sum1)/g**4.0+45.0*(x(c1)-x(c2))**2.0*dexp(-sum1)/g**6.0&    !K(6), checked
      -15.0*(x(c1)-x(c2))**4.0*dexp(-sum1)/g**8.0+(x(c1)-x(c2))**6.0*dexp(-sum1)/g**10.0)     
   end do
end do 
psiv=n1**(-2.0)*((2.0*3.141592653)**0.5*g**3.0)**(-1.0)*sum2   

end subroutine

subroutine psi4(x,g,n1,psiv)
implicit none
real(8),intent(in)::x(:),g  !input, pilot bandwidth, general psi at given order
integer(8),intent(in)::n1
real(8),intent(out)::psiv   !general psi at given order
integer(8)::c1,c2
real(8)::sum1,sum2

sum1=0.0
sum2=0.0
do c1=1,n1
   do c2=1,n1
      sum1=(x(c1)-x(c2))**2.0/2.0/g**2.0 
      sum2=sum2+(3.0*dexp(-sum1)/g**2.0-6.0*(x(c1)-x(c2))**2.0*dexp(-sum1)/g**4.0&       !K(4), checked
      +(x(c1)-x(c2))**4.0*dexp(-sum1)/g**6.0)            
   end do
end do
psiv=n1**(-2.0)*((2.0*3.141592653)**0.5*g**3.0)**(-1.0)*sum2   

end subroutine

!**********************End 2-stage DPI********************

!*************GRNN prediction with 2-stage DPI BW**********
subroutine BW_DPI(fc1,inx,outy,nr,nc)
implicit none

real(8),intent(in)::inx(:,:),outy(:)
integer(8),intent(in)::fc1,nr,nc
integer(8)::c1,c2,fc2,fc3    !counters
real(8),allocatable::sd(:),bw(:),outyest(:)
real(8)::g1,g2,epsi6,epsi4
real(8)::mins,maxs,vars,kurts,rmses,mares,ces,ioads,pis,as,ss,& 
mces,mioads,mpis !Performance criteria

allocate(sd(nc))
allocate(bw(nc))
allocate(outyest(nr))
bw=0.0

!Estimate bandwidths (GRR)
do c2=1,nc
   call sds(inx(1:nr,c2),nr,sd(c2)) 
   !Based upon 2-stage Direct plug-in bandwidth estimator(Wand& Jones 1995) pp.72 assume L=K=N(0,1)
   g1=(-2.0*(-15.0/(2.0*3.141592653)**0.5)/psiNS(8_8,sd(c2))/nr)**(1.0/9.0)  !Pilot bandwidth for L at order 8
   call psi6(inx(1:nr,c2),g1,nr,epsi6)    !Psi 6, K6(0)=-15/sqrt(2pi)
   g2=(-2.0*(3.0/(2.0*3.141592653)**0.5)/epsi6/nr)**(1.0/7.0)  !Pilot bandwidth for L at order 6
   call psi4(inx(1:nr,c2),g2,nr,epsi4)    !Psi 4, K4(0)=3/sqrt(2pi)
   bw(c2)=(0.5/3.141592653**0.5/epsi4)**0.2*nr**(-0.2)    !Selected bandwidth h_DPI,2=[R(K)/sdvK^4/psi4/n]**(1/5)     
end do

!GRNN prediction
call GRNN(inx,outy,nr,nc,bw,outyest)

!Performance criteria
call SPOM(outy,outyest,nr,mins,maxs,as,vars,ss,kurts)
call RMSE(outy,outyest,nr,rmses)
call MARE(outy,outyest,nr,mares)

call CE(outy,outyest,nr,ces)
call IoAd(outy,outyest,nr,ioads)
call PI(outy,outyest,nr,pis)

call MCE(outy,outyest,nr,mces)
call MIoAd(outy,outyest,nr,mioads)
call MPI(outy,outyest,nr,mpis)

!Output summary
!Detial results
write(fc1,*)"Estimated output:"
do c1=1,nr
   write(fc1,*)outyest(c1)
end do
write(fc1,*)

write(fc1,*)"Prediction performance:"
write(fc1,*)"Min. error %:",mins
write(fc1,*)"Max. error %:",maxs
write(fc1,*)"Mean. error:",as
write(fc1,*)"Stdev. error %:",vars
write(fc1,*)"Skew. error %:",ss
write(fc1,*)"Kurt. error %:",kurts
write(fc1,*)"RMSE:",rmses
write(fc1,*)"MARE:",mares
write(fc1,*)"CE:",ces
write(fc1,*)"IoAd:",ioads
write(fc1,*)"PI:",pis
write(fc1,*)"MCE:",mces
write(fc1,*)"MIoAd:",mioads
write(fc1,*)"MPI:",mpis
write(fc1,*)"******************************"

!Overall results
fc2=fc1+100
write(fc2,'(14F11.5)')mins,maxs,as,vars,ss,kurts,rmses,mares,ces,&
ioads,pis,mces,mioads,mpis

!Smoothing parameters
fc3=fc2+100
write(fc3,*)(bw(c2),c2=1,nc)

deallocate(sd)
deallocate(bw)
deallocate(outyest)

end subroutine



end Module
