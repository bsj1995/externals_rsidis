      real*8 function emcfit_xem2(xpass,A)
      implicit none
      
      real*8 alpha,C,x,xp,xpass,A,xtmp

      real*8 aplo(7)/0.60212E-01,0.50766E-01,-3.3853,14.835,-27.037,
     >               21.969,-6.2002/
      real*8 cplo(9)/0.69004,3.0516,-9.7715,7.8273,15.877,-32.847,
     >               16.344,8.6236,-7.3641/

      real*8 aphi(7)/0.45247E-02,0.37668E-01,-0.69210,2.8629,-5.8820,
     >               5.5074, -1.8073/
      real*8 cphi(9)/1.3019,-4.8963,34.445,-122.16,225.62,-207.88,
     >               75.645,11.756,-9.4048/
      
      if (xpass.le.0.2) then
         xp=0.2
      elseif (xpass.ge.1.35) then
         xp=1.35
      else
         xp=xpass
      endif
      
c calculate alpha
      if(A.gt.9.5) then
         if(xp.le.1.01) then
            x=xp               
         else if (xp.gt.1.0) then
            x=1.01
         endif
         alpha=aphi(1)+aphi(2)*x+aphi(3)*x**2+aphi(4)*x**3
     >        +aphi(5)*x**4+aphi(6)*x**5+aphi(7)*x**6
c     now calculate C
         x=xp
         xtmp=1.12
         if(xp.le.xtmp) then
            C=cphi(1)+cphi(2)*x+cphi(3)*x**2+cphi(4)*x**3+cphi(5)*x**4
     >        +cphi(6)*x**5+cphi(7)*x**6
         else
            C=cphi(1)+cphi(2)*xtmp+cphi(3)*xtmp**2+cphi(4)*xtmp**3
     >           +cphi(5)*xtmp**4+cphi(6)*xtmp**5+cphi(7)*xtmp**6
     >           +cphi(8)*x+cphi(9)*x**2
         endif
      endif

      if(A.lt.9.5) then
         if(xp.le.1.05) then
            x=xp               
         else if (xp.gt.1.0) then
            x=1.05
         endif
         alpha=aplo(1)+aplo(2)*x+aplo(3)*x**2+aplo(4)*x**3
     >        +aplo(5)*x**4+aplo(6)*x**5+aplo(7)*x**6
c     now calculate C
         x=xp
         xtmp=1.155
         if(xp.le.xtmp) then
            C=cplo(1)+cplo(2)*x+cplo(3)*x**2+cplo(4)*x**3+cplo(5)*x**4
     >        +cplo(6)*x**5+cplo(7)*x**6
         else
            C=cplo(1)+cplo(2)*xtmp+cplo(3)*xtmp**2+cplo(4)*xtmp**3
     >           +cplo(5)*xtmp**4+cplo(6)*xtmp**5+cplo(7)*xtmp**6
     >           +cplo(8)*x+cplo(9)*x**2
         endif
      endif
      
      emcfit_xem2 = C*A**alpha
      
      return 
      end 
