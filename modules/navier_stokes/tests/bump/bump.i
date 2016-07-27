# Euler flow of an ideal gas over a Gaussian "bump".
#
# The inlet is a stagnation pressure and temperature BC which
# corresponds to subsonic (M=0.5) flow with a static pressure of 1 atm
# and static temperature of 300K.  The outlet consists of a
# weakly-imposed static pressure BC of 1 atm.  The top and bottom
# walls of the channel weakly impose the "no normal flow" BC. The
# problem is initialized with freestream flow throughout the domain.
# Although this initial condition is less physically realistic, it
# helps the problem reach steady state more quickly.
#
# There is a sequence of uniformly-refined, geometry-fitted meshes
# from Yidong Xia available for solving this classical subsonic test
# problem (see the Mesh block below).  A coarse grid is used for the
# actual regression test, but changing one line in the Mesh block is
# sufficient to run this problem with different meshes.  An
# entropy-based error estimate is also provided, and can be used to
# demonstrate convergence of the numerical solution (since the true
# solution should produce zero entropy).  The error should converge at
# second-order in this norm.
[Mesh]
  # Bi-Linear elements
  # file = SmoothBump_quad_ref1_Q1.msh # 84 elems, 65 nodes
  # file = SmoothBump_quad_ref2_Q1.msh # 192 elems, 225 nodes
  # file = SmoothBump_quad_ref3_Q1.msh # 768 elems, 833 nodes
  # file = SmoothBump_quad_ref4_Q1.msh # 3072 elems, 3201 nodes
  # file = SmoothBump_quad_ref5_Q1.msh # 12288 elems, 12545 nodes
  # Bi-Quadratic elements
  # file = SmoothBump_quad_ref0_Q2.msh # 32 elems, 65 nodes
  # file = SmoothBump_quad_ref1_Q2.msh # 84 elems, 225 nodes
  file = SmoothBump_quad_ref2_Q2.msh # 260 elems, 833 nodes
  # file = SmoothBump_quad_ref3_Q2.msh # 900 elems, 3201 nodes
  # file = SmoothBump_quad_ref4_Q2.msh # 3332 elems, 12545 nodes
  # file = SmoothBump_quad_ref5_Q2.msh # 12804 elems, 49665 nodes
[]



[NavierStokes]
  [./Variables]
    #         'rho rhou rhov   rhoE'
    scaling = '1.  1.    1.    9.869232667160121e-6'
    family = LAGRANGE
    order = FIRST
  [../]
  [./ICs]
    initial_pressure = 101325.
    initial_temperature = 300.
    initial_velocity = '173.594354746921 0 0' # Mach 0.5: = 0.5*sqrt(gamma*R*T)
    fluid_properties = ideal_gas
  [../]
[]

[Modules]
  [./FluidProperties]
    [./ideal_gas]
      type = IdealGasFluidProperties
      gamma = 1.4
      R = 287
    [../]
  [../]
[]


[Kernels]
  ################################################################################
  # Mass conservation Equation
  ################################################################################

  # Time derivative term
  [./rho_time_deriv]
    type = TimeDerivative
    variable = rho
  [../]

  # Inviscid flux term (integrated by parts)
  [./rho_if]
    type = NSMassInviscidFlux
    variable = rho
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    fluid_properties = ideal_gas
  [../]

  ################################################################################
  # x-momentum equation
  ################################################################################

  # Time derivative term
  [./rhou_time_deriv]
    type = TimeDerivative
    variable = rhou
  [../]

  # Inviscid flux term (integrated by parts)
  [./rhou_if]
    type = NSMomentumInviscidFlux
    variable = rhou
    u = vel_x
    v = vel_y
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    pressure = pressure
    component = 0
    fluid_properties = ideal_gas
  [../]

  ################################################################################
  # y-momentum equation
  ################################################################################

  # Time derivative term
  [./rhov_time_deriv]
    type = TimeDerivative
    variable = rhov
  [../]

  # Inviscid flux term (integrated by parts)
  [./rhov_if]
    type = NSMomentumInviscidFlux
    variable = rhov
    u = vel_x
    v = vel_y
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    pressure = pressure
    component = 1
    fluid_properties = ideal_gas
  [../]


  ################################################################################
  # Total Energy Equation
  ################################################################################

  # Time derivative term
  [./rhoE_time_deriv]
    type = TimeDerivative
    variable = rhoE
  [../]

  # Energy equation inviscid flux term (integrated by parts)
  [./rhoE_if]
    type = NSEnergyInviscidFlux
    variable = rhoE
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    enthalpy = enthalpy
    fluid_properties = ideal_gas
  [../]


  ################################################################################
  # Stabilization terms
  ################################################################################

  # The SUPG stabilization terms for the density equation
  [./rho_supg]
    type = NSSUPGMass
    variable = rho
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    temperature = temperature
    enthalpy = enthalpy
    fluid_properties = ideal_gas
  [../]

  # The SUPG stabilization terms for the x-momentum equation
  [./rhou_supg]
    type = NSSUPGMomentum
    component = 0
    variable = rhou
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    temperature = temperature
    enthalpy = enthalpy
    fluid_properties = ideal_gas
  [../]

  # The SUPG stabilization terms for the y-momentum equation
  [./rhov_supg]
    type = NSSUPGMomentum
    component = 1
    variable = rhov
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    temperature = temperature
    enthalpy = enthalpy
    fluid_properties = ideal_gas
  [../]

  # The SUPG stabilization terms for the energy equation
  [./rhoE_supg]
    type = NSSUPGEnergy
    variable = rhoE
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    temperature = temperature
    enthalpy = enthalpy
    fluid_properties = ideal_gas
  [../]
[]



[AuxKernels]
  [./u_vel]
    type = NSVelocityAux
    variable = vel_x
    rho = rho
    momentum = rhou
  [../]

  [./v_vel]
    type = NSVelocityAux
    variable = vel_y
    rho = rho
    momentum = rhov
  [../]

  [./temperature_auxkernel]
    type = NSTemperatureAux
    variable = temperature
    internal_energy = internal_energy
    specific_volume = specific_volume
    fluid_properties = ideal_gas
  [../]

  [./pressure_auxkernel]
    type = NSPressureAux
    variable = pressure
    internal_energy = internal_energy
    specific_volume = specific_volume
    fluid_properties = ideal_gas
  [../]

  [./enthalpy_auxkernel]
    type = NSEnthalpyAux
    variable = enthalpy
    rho = rho
    rhoE = rhoE
    pressure = pressure
  [../]

  [./mach_auxkernel]
    type = NSMachAux
    variable = Mach
    u = vel_x
    v = vel_y
    internal_energy = internal_energy
    specific_volume = specific_volume
    fluid_properties = ideal_gas
  [../]

  [./internal_energy_auxkernel]
    type = NSInternalEnergyAux
    variable = internal_energy
    rho = rho
    u = vel_x
    v = vel_y
    rhoE = rhoE
  [../]

  [./specific_volume_auxkernel]
    type = NSSpecificVolumeAux
    variable = specific_volume
    rho = rho
  [../]
[]



[BCs]
  # "Free outflow" mass equation BC
  [./mass_outflow]
    type = NSMassUnspecifiedNormalFlowBC
    variable = rho
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    boundary = '2' # 'Outflow'
    fluid_properties = ideal_gas
  [../]

  # Specified pressure x-momentum equation invsicid outflow BC
  [./rhou_specified_pressure_outflow]
    type = NSMomentumInviscidSpecifiedPressureBC
    variable = rhou
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    component = 0
    boundary = '2' # 'Outflow'
    specified_pressure = 101325 # Pa
    fluid_properties = ideal_gas
  [../]

  # Specified pressure y-momentum equation inviscid outflow BC
  [./rhov_specified_pressure_outflow]
    type = NSMomentumInviscidSpecifiedPressureBC
    variable = rhov
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    component = 1
    boundary = '2' # 'Outflow'
    specified_pressure = 101325 # Pa
    fluid_properties = ideal_gas
  [../]

  # Specified pressure energy equation outflow BC
  [./rhoE_specified_pressure_outflow]
    type = NSEnergyInviscidSpecifiedPressureBC
    variable = rhoE
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    temperature = temperature
    boundary = '2' # 'Outflow'
    specified_pressure = 101325 # Pa
    fluid_properties = ideal_gas
  [../]

  # The no penentration BC (u.n=0) applies on all the solid surfaces.
  # This is enforced weakly via the NSPressureNeumannBC.
  [./rhou_no_penetration]
    type = NSPressureNeumannBC
    variable = rhou
    component = 0
    boundary = '3 4' # 'Lower Wall, Upper Wall'
    u = vel_x
    v = vel_y
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    pressure = pressure
    fluid_properties = ideal_gas
  [../]

  # The no penentration BC (u.n=0) applies on all the solid surfaces.
  # This is enforced weakly via the NSPressureNeumannBC.
  [./rhov_no_penetration]
    type = NSPressureNeumannBC
    variable = rhov
    component = 1
    boundary = '3 4' # 'Lower Wall, Upper Wall'
    u = vel_x
    v = vel_y
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    pressure = pressure
    fluid_properties = ideal_gas
  [../]

  #
  # "Weak" stagnation and specified flow direction boundary conditions
  #
  [./weak_stagnation_mass_inflow]
    type = NSMassWeakStagnationBC
    variable = rho
    boundary = '1' # 'Inflow'
    stagnation_pressure = 120192.995549849 # Pa, Mach=0.5 at 1 atm
    stagnation_temperature = 315 # K, Mach=0.5 at 1 atm
    sx = 1.
    sy = 0.
    rho = rho
    rhoE = rhoE
    rhou = rhou
    rhov = rhov
    u = vel_x
    v = vel_y
    fluid_properties = ideal_gas
  [../]

  [./weak_stagnation_rhou_convective_inflow]
    type = NSMomentumConvectiveWeakStagnationBC
    variable = rhou
    component = 0
    boundary = '1' # 'Inflow'
    stagnation_pressure = 120192.995549849 # Pa, Mach=0.5 at 1 atm
    stagnation_temperature = 315 # K, Mach=0.5 at 1 atm
    sx = 1.
    sy = 0.
    rho = rho
    rhoE = rhoE
    rhou = rhou
    rhov = rhov
    u = vel_x
    v = vel_y
    fluid_properties = ideal_gas
  [../]

  [./weak_stagnation_rhou_pressure_inflow]
    type = NSMomentumPressureWeakStagnationBC
    variable = rhou
    component = 0
    boundary = '1' # 'Inflow'
    stagnation_pressure = 120192.995549849 # Pa, Mach=0.5 at 1 atm
    stagnation_temperature = 315 # K, Mach=0.5 at 1 atm
    sx = 1.
    sy = 0.
    rho = rho
    rhoE = rhoE
    rhou = rhou
    rhov = rhov
    u = vel_x
    v = vel_y
    fluid_properties = ideal_gas
  [../]

  [./weak_stagnation_rhov_convective_inflow]
    type = NSMomentumConvectiveWeakStagnationBC
    variable = rhov
    component = 1
    boundary = '1' # 'Inflow'
    stagnation_pressure = 120192.995549849 # Pa, Mach=0.5 at 1 atm
    stagnation_temperature = 315 # K, Mach=0.5 at 1 atm
    sx = 1.
    sy = 0.
    rho = rho
    rhoE = rhoE
    rhou = rhou
    rhov = rhov
    u = vel_x
    v = vel_y
    fluid_properties = ideal_gas
  [../]

  [./weak_stagnation_rhov_pressure_inflow]
    type = NSMomentumPressureWeakStagnationBC
    variable = rhov
    component = 1
    boundary = '1' # 'Inflow'
    stagnation_pressure = 120192.995549849 # Pa, Mach=0.5 at 1 atm
    stagnation_temperature = 315 # K, Mach=0.5 at 1 atm
    sx = 1.
    sy = 0.
    rho = rho
    rhoE = rhoE
    rhou = rhou
    rhov = rhov
    u = vel_x
    v = vel_y
    fluid_properties = ideal_gas
  [../]

  [./weak_stagnation_energy_inflow]
    type = NSEnergyWeakStagnationBC
    variable = rhoE
    boundary = '1' # 'Inflow'
    stagnation_pressure = 120192.995549849 # Pa, Mach=0.5 at 1 atm
    stagnation_temperature = 315 # K, Mach=0.5 at 1 atm
    sx = 1.
    sy = 0.
    rho = rho
    rhoE = rhoE
    rhou = rhou
    rhov = rhov
    u = vel_x
    v = vel_y
    fluid_properties = ideal_gas
  [../]
[]




[Materials]
  [./fluid]
    type = Air
    block = 0 # 'MeshInterior'
    rho = rho
    rhou = rhou
    rhov = rhov
    rhoE = rhoE
    u = vel_x
    v = vel_y
    temperature = temperature
    enthalpy = enthalpy
    # This value is not used in the Euler equations, but it *is* used
    # by the stabilization parameter computation, which it decrease
    # the amount of artificial viscosity added, so it's best to use a
    # realistic value.
    dynamic_viscosity = 0.0
    fluid_properties = ideal_gas
  [../]

  # A Material is probably the most efficient way to use the
  # FluidProperties stuff, as the values will be computed once and
  # then used by all the Kernels, rather than calling getUserObject
  # from individual Kernels and computing properties repeatedly.
  # This could possibly be refactored in the future...
  # [./fp_mat]
  #   type = FluidPropertiesMaterial
  #   e = internal_energy
  #   v = specific_volume
  #   fp = ideal_gas
  # [../]
[]



[Postprocessors]
  [./entropy_error]
    type = NSEntropyError
    execute_on = 'initial timestep_end'
    block = 0
    rho_infty = 1.1768292682926829
    p_infty = 101325
    rho = rho
    pressure = pressure
    fluid_properties = ideal_gas
  [../]
[]



[Preconditioning]
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
  [../]
[]



[Executioner]
  type = Transient
  dt = 5.e-5
  dtmin = 1.e-5
  start_time = 0.0
  num_steps = 10
  nl_rel_tol = 1e-9
  nl_max_its = 5
  l_tol = 1e-4
  l_max_its = 100

  # We use trapezoidal quadrature.  This improves stability by
  # mimicking the "group variable" discretization approach.
  [./Quadrature]
    type = TRAP
    order = FIRST
  [../]
[]



[Outputs]
  interval = 1
  exodus = true
[]
