      program make_grid
      real ebeam
      real pmin,pmax,pstep
      real thetamin,thetamax,thetastep
      real ptmp,thtmp
      character*80 xfile
      character(3) mychar1
      character(4) mychar2
      character(5) ebchar1
      character(6) ebchar2
            

      integer i,j,k

      write(6,*) 'Enter beam energy'
      read(5,*) ebeam
      if(ebeam.lt.10.00) then
         write(ebchar1,'(f5.3)') ebeam
      else
         write(ebchar2,'(f6.3)') ebeam
      endif
      write(6,*) 'Minimum scattered electron energy'
      read(5,*) pmin
      write(6,*) 'Maximum scattered electron energy'
      read(5,*) pmax
      write(6,*) 'Scattered electron energy step size'
      read(5,*) pstep ! nominal 0.01

c For a given angle, usually use +/- 5degrees from central value, 0.2 degrees step       
      write(6,*) 'Theta min'
      read(5,*) thetamin
      write(6,*) 'Theta max'
      read(5,*) thetamax
      write(6,*) 'Theta step size'
      read(5,*) thetastep


      np=(pmax-pmin)/pstep
      write(6,*) 'number of np ',np

      nth=(thetamax-thetamin)/thetastep
      write(6,*) 'number of nth ',nth

      do i=1,nth+1
         k=100+i
         thtmp=thetamin+(i-1)*thetastep
         if(thtmp.lt.10.0) then
            write(mychar1,'(f3.1)') thtmp
            if(ebeam.lt.10.00) then
             xfile='../RUNPLAN/'//ebchar1//'gev_th_'//mychar1//'deg.inp'
            else
             xfile='../RUNPLAN/'//ebchar2//'gev_th_'//mychar1//'deg.inp'
            endif
         else
            write(mychar2,'(f4.1)') thtmp
            if(ebeam.lt.10.00) then
             xfile='../RUNPLAN/'//ebchar1//'gev_th_'//mychar2//'deg.inp'
            else
             xfile='../RUNPLAN/'//ebchar2//'gev_th_'//mychar2//'deg.inp'
            endif
         endif
         open(unit=10,file=xfile)
         do j=1,np+1
            ptmp=pmin + (j-1)*pstep
            write(10,77) ebeam,ptmp,thtmp
         enddo
         close(10)
      enddo



 77   format(F6.3,1x,F7.4,1x,F7.4)

      close(10)
 99   continue
      end
