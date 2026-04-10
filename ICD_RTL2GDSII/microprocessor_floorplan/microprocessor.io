(
 globals
 version = 3
 io_order = default
)

(iopad
  (bottom
    (inst name = "pc3d01_clk" space = 30 place_status = fixed)
    (inst name = "pc3d01_rst" space = 30 place_status = fixed)
    (inst name = "pc3d01_mem_bank_sel_0" space = 30 place_status = fixed)
    (inst name = "pc3d01_mem_bank_sel_1" space = 30 place_status = fixed)
    (inst name = "pc3d01_dbg_sel_0" space = 30 place_status = fixed)
    (inst name = "pc3d01_dbg_sel_1" space = 30 place_status = fixed)

    (inst name = "pvdi_VDD_CORE_1" space = 30 place_status = fixed)
    (inst name = "pv0i_VSS_CORE_1" space = 30 place_status = fixed)
    (inst name = "pvda_VDDO_CORE_1" space = 30 place_status = fixed)
    (inst name = "pv0a_VSSO_CORE_1" space = 30 place_status = fixed)

    (inst name = "pc3o05_dbg_out_0" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_1" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_2" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_3" space = 30 place_status = fixed)
  )

  (right
    (inst name = "pc3o05_dbg_out_4" space = 28 place_status = fixed)
    (inst name = "pc3o05_dbg_out_5" space = 28 place_status = fixed)
    (inst name = "pc3o05_dbg_out_6" space = 28 place_status = fixed)
    (inst name = "pc3o05_dbg_out_7" space = 28 place_status = fixed)
    (inst name = "pc3o05_dbg_out_8" space = 28 place_status = fixed)

    (inst name = "pvdi_VDD_CORE_2" space = 28 place_status = fixed)
    (inst name = "pv0i_VSS_CORE_2" space = 28 place_status = fixed)
    (inst name = "pvda_VDDO_CORE_2" space = 28 place_status = fixed)
    (inst name = "pv0a_VSSO_CORE_2" space = 28 place_status = fixed)

    (inst name = "pc3o05_dbg_out_9" space = 28 place_status = fixed)
    (inst name = "pc3o05_dbg_out_10" space = 28 place_status = fixed)
    (inst name = "pc3o05_dbg_out_11" space = 28 place_status = fixed)
    (inst name = "pc3o05_dbg_out_12" space = 28 place_status = fixed)
  )

  (top
    (inst name = "pc3o05_dbg_out_13" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_14" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_15" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_16" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_17" space = 30 place_status = fixed)

    (inst name = "pvdi_VDD_CORE_3" space = 30 place_status = fixed)
    (inst name = "pv0i_VSS_CORE_3" space = 30 place_status = fixed)
    (inst name = "pvda_VDDO_CORE_3" space = 30 place_status = fixed)
    (inst name = "pv0a_VSSO_CORE_3" space = 30 place_status = fixed)

    (inst name = "pc3o05_dbg_out_18" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_19" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_20" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_21" space = 30 place_status = fixed)
  )

  (left
    (inst name = "pc3o05_dbg_out_22" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_23" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_24" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_25" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_26" space = 30 place_status = fixed)

    (inst name = "pvdi_VDD_CORE_4" space = 30 place_status = fixed)
    (inst name = "pv0i_VSS_CORE_4" space = 30 place_status = fixed)
    (inst name = "pvda_VDDO_CORE_4" space = 30 place_status = fixed)
    (inst name = "pv0a_VSSO_CORE_4" space = 30 place_status = fixed)

    (inst name = "pc3o05_dbg_out_27" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_28" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_29" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_30" space = 30 place_status = fixed)
    (inst name = "pc3o05_dbg_out_31" space = 30 place_status = fixed)
    (inst name = "pc3o05_CLKOUT" space = 30 place_status = fixed)
  )

  (topright
    (inst name = "corner_3"
      cell = pfrelr
      place_status = fixed
      orientation = R90
    )
  )

  (topleft
    (inst name = "corner_4"
      cell = pfrelr
      place_status = fixed
      orientation = R180
    )
  )

  (bottomright
    (inst name = "corner_2"
      cell = pfrelr
      place_status = fixed
      orientation = R0
    )
  )

  (bottomleft
    (inst name = "corner_1"
      cell = pfrelr
      place_status = fixed
      orientation = R270
    )
  )
)
