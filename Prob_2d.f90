subroutine amrex_probinit (init,name,namlen,problo,probhi) bind(c)

  use parallel
  use probdata_module
  use model_parser_module
  use bl_error_module

  implicit none

  integer init, namlen
  integer name(namlen)
  double precision problo(2), probhi(2)

  double precision offset
  integer untin,i

  namelist /fortin/ model_name, apply_vel_field, &
       velpert_scale, velpert_amplitude, velpert_height_loc, num_vortices, &
       shear_height_loc, shear_amplitude, &
       cutoff_density, interp_BC, zero_vels

  integer, parameter :: maxlen = 256
  character probin*(maxlen)

  ! Build "probin" filename from C++ land -- 
  ! the name of file containing fortin namelist.


  if (namlen .gt. maxlen) call bl_error("probin file name too long")

  do i = 1, namlen
     probin(i:i) = char(name(i))
  end do
  

  ! Namelist defaults
  apply_vel_field = .false.
  velpert_scale = 1.0d2
  velpert_amplitude = 1.0d2
  velpert_height_loc = 6.5d3
  num_vortices = 1
  cutoff_density = 50.d0
  interp_BC = .false.
  zero_vels = .false.
  shear_height_loc = 0.0d0
  
  ! Read namelists
  untin = 9
  open(untin,file=probin(1:namlen),form='formatted',status='old')
  read(untin,fortin)
  close(unit=untin)


  ! Read initial model
  call read_model_file(model_name)


  if (parallel_IOProcessor()) then
     do i = 1, npts_model
        print *, i, model_r(i), model_state(i,idens_model)
     enddo
  endif

  ! set local variable defaults
  center(1) = 0.5*(problo(1)+probhi(1))
  center(2) = 0.5*(problo(2)+probhi(2))


  ! velocity perturbation stuff
  offset = (probhi(1) - problo(1)) / (num_vortices)

  allocate(xloc_vortices(num_vortices))

  do i = 1, num_vortices
     xloc_vortices(i) = (dble(i-1) + 0.5d0) * offset + problo(1)
  enddo

end subroutine amrex_probinit


! ::: -----------------------------------------------------------
! ::: This routine is called at problem setup time and is used
! ::: to initialize data on each grid.  
! ::: 
! ::: NOTE:  all arrays have one cell of ghost zones surrounding
! :::        the grid interior.  Values in these cells need not
! :::        be set here.
! ::: 
! ::: INPUTS/OUTPUTS:
! ::: 
! ::: level     => amr level of grid
! ::: time      => time at which to init data             
! ::: lo,hi     => index limits of grid interior (cell centered)
! ::: nstate    => number of state components.  You should know
! :::		   this already!
! ::: state     <=  Scalar array
! ::: delta     => cell size
! ::: xlo,xhi   => physical locations of lower left and upper
! :::              right hand corner of grid.  (does not include
! :::		   ghost region).
! ::: -----------------------------------------------------------
subroutine ca_initdata(level,time,lo,hi,nscal, &
                       state,state_l1,state_l2,state_h1,state_h2, &
                       delta,xlo,xhi)

  use bl_constants_module
  use probdata_module
  use interpolate_module
  use eos_module
  use meth_params_module, only : NVAR, URHO, UMX, UMY, UEDEN, UEINT, UFS, UTEMP
  use network, only: nspec
  use model_parser_module
  use eos_type_module
  implicit none
        
  integer level, nscal
  integer lo(2), hi(2)
  integer state_l1,state_l2,state_h1,state_h2
  double precision xlo(2), xhi(2), time, delta(2)
  double precision state(state_l1:state_h1,state_l2:state_h2,NVAR)
  
  double precision xdist,ydist,x,y,r,upert(2)
  integer i,j,n,vortex

  type (eos_t) :: eos_state
        
  do j = lo(2), hi(2)
     y = xlo(2) + delta(2)*(float(j-lo(2)) + 0.5d0)

     do i = lo(1), hi(1)   

        state(i,j,URHO)  = interpolate(y,npts_model,model_r, &
                                      model_state(:,idens_model))
        state(i,j,UTEMP) = interpolate(y,npts_model,model_r, &
                                       model_state(:,itemp_model))
        do n = 1, nspec
           state(i,j,UFS-1+n) = interpolate(y,npts_model,model_r, &
                                            model_state(:,ispec_model-1+n))
        enddo
        
        eos_state%rho = state(i,j,URHO)
        eos_state%T = state(i,j,UTEMP)
        eos_state%xn(:) = state(i,j,UFS:)

        call eos(eos_input_rt, eos_state)

        state(i,j,UEINT) = eos_state%e

     end do
  end do

  ! switch to conserved quantities
  do j = lo(2), hi(2)     
     do i = lo(1), hi(1)   
        
        state(i,j,UEDEN) = state(i,j,URHO) * state(i,j,UEINT) 
        state(i,j,UEINT) = state(i,j,URHO) * state(i,j,UEINT)

        do n = 1,nspec
           state(i,j,UFS+n-1) = state(i,j,URHO) * state(i,j,UFS+n-1)
        end do
        
     enddo
  enddo

  ! Initial velocities
  state(:,:,UMX:UMY) = 0.d0
  
  ! Now add the velocity perturbation (update the kinetic energy too)
  if (apply_vel_field) then

     do j = lo(2), hi(2)
        y = xlo(2) + delta(2)*(float(j-lo(2)) + 0.5d0)
        ydist = y - velpert_height_loc

        do i = lo(1), hi(1)
           x = xlo(1) + delta(1)*(float(i-lo(1)) + 0.5d0)

           if (y >= shear_height_loc) then 
              state(:,:,UMX) = state(:,:,URHO)*shear_amplitude
              state(:,:,UMY) = 0.d0
           endif
           
           upert = 0.d0

           ! loop over each vortex
           do vortex = 1, num_vortices

              xdist = x - xloc_vortices(vortex)

              r = sqrt(xdist**2 + ydist**2)

              upert(1) = upert(1) - (ydist/velpert_scale) * &
                   velpert_amplitude * exp( -r**2/(2.d0*velpert_scale**2)) &
                   * (-1.d0)**vortex

              upert(2) = upert(2) + (xdist/velpert_scale) * &
                   velpert_amplitude * exp(-r**2/(2.d0*velpert_scale**2)) &
                   * (-1.d0)**vortex
           enddo

           state(i,j,UMX) = state(i,j,UMX) + state(i,j,URHO) * upert(1)
           state(i,j,UMY) = state(i,j,UMY) + state(i,j,URHO) * upert(2)

           state(i,j,UEDEN) = state(i,j,UEDEN) + HALF*(state(i,j,UMX)**2 + state(i,j,UMY)**2)/state(i,j,URHO)
        end do
     end do

  endif

  
end subroutine ca_initdata


subroutine ca_initrad(level,time,lo,hi,nrad, &
                      rad_state,rad_state_l1,rad_state_l2, &
                      rad_state_h1,rad_state_h2, &
                      delta,xlo,xhi)

  use probdata_module

  integer level, nrad
  integer lo(2), hi(2)
  integer rad_state_l1,rad_state_l2
  integer rad_state_h1,rad_state_h2
  double precision ::  xlo(2), xhi(2), time, delta(2)
  double precision :: rad_state(rad_state_l1:rad_state_h1, &
                                rad_state_l2:rad_state_h2, nrad)

  integer i,j

  do j = lo(2), hi(2)
     do i = lo(1), hi(1)
        rad_state(i,j,:) = 0.d0
     end do
  end do
  
end subroutine ca_initrad


