unit elp2000_data;

interface
type
  MOON_ECLIPTIC_LONGITUDE_COEFF =record
    D: Double;
    M: Double;
    Mp:Double;
    F: Double;
    eiA:Double;
    erA:Double;
  end;
  MOON_ECLIPTIC_LATITUDE_COEFF =record
    D: Double;
    M: Double;
    Mp:Double;
    F: Double;
    eiA:Double;
  end;
const
  (*
    月球黄经周期项(ΣI)及距离(Σr).
    黄经单位:0.000001度,距离单位:0.001千米.
--------------------------------------------------
  角度的组合系数  ΣI的各项振幅A  Σr的各项振幅A
  D  M  M' F        (正弦振幅)       (余弦振幅)
--------------------------------------------------
*)
  Moon_longitude:array[0..59] of MOON_ECLIPTIC_LONGITUDE_COEFF=(
    (D: 0;  M:  0;  Mp:  1;  F:  0; eiA: 6288744; erA:-20905355  ),
    (D: 2;  M:  0;  Mp: -1;  F:  0; eiA: 1274027; erA:  -3699111 ),
    (D: 2;  M:  0;  Mp:  0;  F:  0; eiA:  658314; erA:  -2955968 ),
    (D: 0;  M:  0;  Mp:  2;  F:  0; eiA:  213618; erA:   -569925 ),
    (D: 0;  M:  1;  Mp:  0;  F:  0; eiA: -185116; erA:     48888 ),
    (D: 0;  M:  0;  Mp:  0;  F:  2; eiA: -114332; erA:     -3149 ),
    (D: 2;  M:  0;  Mp: -2;  F:  0; eiA:   58793; erA:    246158 ),
    (D: 2;  M: -1;  Mp: -1;  F:  0; eiA:   57066; erA:   -152138 ),
    (D: 2;  M:  0;  Mp:  1;  F:  0; eiA:   53322; erA:   -170733 ),
    (D: 2;  M: -1;  Mp:  0;  F:  0; eiA:   45758; erA:   -204586 ),
    (D: 0;  M:  1;  Mp: -1;  F:  0; eiA:  -40923; erA:   -129620 ),
    (D: 1;  M:  0;  Mp:  0;  F:  0; eiA:  -34720; erA:    108743 ),
    (D: 0;  M:  1;  Mp:  1;  F:  0; eiA:  -30383; erA:    104755 ),
    (D: 2;  M:  0;  Mp:  0;  F: -2; eiA:   15327; erA:     10321 ),
    (D: 0;  M:  0;  Mp:  1;  F:  2; eiA:  -12528; erA:         0 ),
    (D: 0;  M:  0;  Mp:  1;  F: -2; eiA:   10980; erA:     79661 ),
    (D: 4;  M:  0;  Mp: -1;  F:  0; eiA:   10675; erA:    -34782 ),
    (D: 0;  M:  0;  Mp:  3;  F:  0; eiA:   10034; erA:    -23210 ),
    (D: 4;  M:  0;  Mp: -2;  F:  0; eiA:    8548; erA:    -21636 ),
    (D: 2;  M:  1;  Mp: -1;  F:  0; eiA:   -7888; erA:     24208 ),
    (D: 2;  M:  1;  Mp:  0;  F:  0; eiA:   -6766; erA:     30824 ),
    (D: 1;  M:  0;  Mp: -1;  F:  0; eiA:   -5163; erA:     -8379 ),
    (D: 1;  M:  1;  Mp:  0;  F:  0; eiA:    4987; erA:    -16675 ),
    (D: 2;  M: -1;  Mp:  1;  F:  0; eiA:    4036; erA:    -12831 ),
    (D: 2;  M:  0;  Mp:  2;  F:  0; eiA:    3994; erA:    -10445 ),
    (D: 4;  M:  0;  Mp:  0;  F:  0; eiA:    3861; erA:    -11650 ),
    (D: 2;  M:  0;  Mp: -3;  F:  0; eiA:    3665; erA:     14403 ),
    (D: 0;  M:  1;  Mp: -2;  F:  0; eiA:   -2689; erA:     -7003 ),
    (D: 2;  M:  0;  Mp: -1;  F:  2; eiA:   -2602; erA:         0 ),
    (D: 2;  M: -1;  Mp: -2;  F:  0; eiA:    2390; erA:     10056 ),
    (D: 1;  M:  0;  Mp:  1;  F:  0; eiA:   -2348; erA:      6322 ),
    (D: 2;  M: -2;  Mp:  0;  F:  0; eiA:    2236; erA:     -9884 ),
    (D: 0;  M:  1;  Mp:  2;  F:  0; eiA:   -2120; erA:      5751 ),
    (D: 0;  M:  2;  Mp:  0;  F:  0; eiA:   -2069; erA:         0 ),
    (D: 2;  M: -2;  Mp: -1;  F:  0; eiA:    2048; erA:     -4950 ),
    (D: 2;  M:  0;  Mp:  1;  F: -2; eiA:   -1773; erA:      4130 ),
    (D: 2;  M:  0;  Mp:  0;  F:  2; eiA:   -1595; erA:         0 ),
    (D: 4;  M: -1;  Mp: -1;  F:  0; eiA:    1215; erA:     -3958 ),
    (D: 0;  M:  0;  Mp:  2;  F:  2; eiA:   -1110; erA:         0 ),
    (D: 3;  M:  0;  Mp: -1;  F:  0; eiA:    -892; erA:      3258 ),
    (D: 2;  M:  1;  Mp:  1;  F:  0; eiA:    -810; erA:      2616 ),
    (D: 4;  M: -1;  Mp: -2;  F:  0; eiA:     759; erA:     -1897 ),
    (D: 0;  M:  2;  Mp: -1;  F:  0; eiA:    -713; erA:     -2117 ),
    (D: 2;  M:  2;  Mp: -1;  F:  0; eiA:    -700; erA:      2354 ),
    (D: 2;  M:  1;  Mp: -2;  F:  0; eiA:     691; erA:         0 ),
    (D: 2;  M: -1;  Mp:  0;  F: -2; eiA:     596; erA:         0 ),
    (D: 4;  M:  0;  Mp:  1;  F:  0; eiA:     549; erA:     -1423 ),
    (D: 0;  M:  0;  Mp:  4;  F:  0; eiA:     537; erA:     -1117 ),
    (D: 4;  M: -1;  Mp:  0;  F:  0; eiA:     520; erA:     -1571 ),
    (D: 1;  M:  0;  Mp: -2;  F:  0; eiA:    -487; erA:     -1739 ),
    (D: 2;  M:  1;  Mp:  0;  F: -2; eiA:    -399; erA:         0 ),
    (D: 0;  M:  0;  Mp:  2;  F: -2; eiA:    -381; erA:     -4421 ),
    (D: 1;  M:  1;  Mp:  1;  F:  0; eiA:     351; erA:         0 ),
    (D: 3;  M:  0;  Mp: -2;  F:  0; eiA:    -340; erA:         0 ),
    (D: 4;  M:  0;  Mp: -3;  F:  0; eiA:     330; erA:         0 ),
    (D: 2;  M: -1;  Mp:  2;  F:  0; eiA:     327; erA:         0 ),
    (D: 0;  M:  2;  Mp:  1;  F:  0; eiA:    -323; erA:      1165 ),
    (D: 1;  M:  1;  Mp: -1;  F:  0; eiA:     299; erA:         0 ),
    (D: 2;  M:  0;  Mp:  3;  F:  0; eiA:     294; erA:         0 ),
    (D: 2;  M:  0;  Mp: -1;  F: -2; eiA:       0; erA:      8752 ));

  (*
  月球黄纬周期项(ΣI).单位:0.000001度.
-------------------------------------
  角度的组合系数 ΣI的各项振幅A
  D  M  M' F       (正弦振幅)
-------------------------------------
*)

  Moon_latitude:array[0..59]of MOON_ECLIPTIC_LONGITUDE_COEFF=(
    (D: 0;  M:  0;  Mp:  0;  F:  1; eiA: 5128122 ),
    (D: 0;  M:  0;  Mp:  1;  F:  1; eiA:  280602 ),
    (D: 0;  M:  0;  Mp:  1;  F: -1; eiA:  277693 ),
    (D: 2;  M:  0;  Mp:  0;  F: -1; eiA:  173237 ),
    (D: 2;  M:  0;  Mp: -1;  F:  1; eiA:   55413 ),
    (D: 2;  M:  0;  Mp: -1;  F: -1; eiA:   46271 ),
    (D: 2;  M:  0;  Mp:  0;  F:  1; eiA:   32573 ),
    (D: 0;  M:  0;  Mp:  2;  F:  1; eiA:   17198 ),
    (D: 2;  M:  0;  Mp:  1;  F: -1; eiA:    9266 ),
    (D: 0;  M:  0;  Mp:  2;  F: -1; eiA:    8822 ),
    (D: 2;  M: -1;  Mp:  0;  F: -1; eiA:    8216 ),
    (D: 2;  M:  0;  Mp: -2;  F: -1; eiA:    4324 ),
    (D: 2;  M:  0;  Mp:  1;  F:  1; eiA:    4200 ),
    (D: 2;  M:  1;  Mp:  0;  F: -1; eiA:   -3359 ),
    (D: 2;  M: -1;  Mp: -1;  F:  1; eiA:    2463 ),
    (D: 2;  M: -1;  Mp:  0;  F:  1; eiA:    2211 ),
    (D: 2;  M: -1;  Mp: -1;  F: -1; eiA:    2065 ),
    (D: 0;  M:  1;  Mp: -1;  F: -1; eiA:   -1870 ),
    (D: 4;  M:  0;  Mp: -1;  F: -1; eiA:    1828 ),
    (D: 0;  M:  1;  Mp:  0;  F:  1; eiA:   -1794 ),
    (D: 0;  M:  0;  Mp:  0;  F:  3; eiA:   -1749 ),
    (D: 0;  M:  1;  Mp: -1;  F:  1; eiA:   -1565 ),
    (D: 1;  M:  0;  Mp:  0;  F:  1; eiA:   -1491 ),
    (D: 0;  M:  1;  Mp:  1;  F:  1; eiA:   -1475 ),
    (D: 0;  M:  1;  Mp:  1;  F: -1; eiA:   -1410 ),
    (D: 0;  M:  1;  Mp:  0;  F: -1; eiA:   -1344 ),
    (D: 1;  M:  0;  Mp:  0;  F: -1; eiA:   -1335 ),
    (D: 0;  M:  0;  Mp:  3;  F:  1; eiA:    1107 ),
    (D: 4;  M:  0;  Mp:  0;  F: -1; eiA:    1021 ),
    (D: 4;  M:  0;  Mp: -1;  F:  1; eiA:     833 ),
    (D: 0;  M:  0;  Mp:  1;  F: -3; eiA:     777 ),
    (D: 4;  M:  0;  Mp: -2;  F:  1; eiA:     671 ),
    (D: 2;  M:  0;  Mp:  0;  F: -3; eiA:     607 ),
    (D: 2;  M:  0;  Mp:  2;  F: -1; eiA:     596 ),
    (D: 2;  M: -1;  Mp:  1;  F: -1; eiA:     491 ),
    (D: 2;  M:  0;  Mp: -2;  F:  1; eiA:    -451 ),
    (D: 0;  M:  0;  Mp:  3;  F: -1; eiA:     439 ),
    (D: 2;  M:  0;  Mp:  2;  F:  1; eiA:     422 ),
    (D: 2;  M:  0;  Mp: -3;  F: -1; eiA:     421 ),
    (D: 2;  M:  1;  Mp: -1;  F:  1; eiA:    -366 ),
    (D: 2;  M:  1;  Mp:  0;  F:  1; eiA:    -351 ),
    (D: 4;  M:  0;  Mp:  0;  F:  1; eiA:     331 ),
    (D: 2;  M: -1;  Mp:  1;  F:  1; eiA:     315 ),
    (D: 2;  M: -2;  Mp:  0;  F: -1; eiA:     302 ),
    (D: 0;  M:  0;  Mp:  1;  F:  3; eiA:    -283 ),
    (D: 2;  M:  1;  Mp:  1;  F: -1; eiA:    -229 ),
    (D: 1;  M:  1;  Mp:  0;  F: -1; eiA:     223 ),
    (D: 1;  M:  1;  Mp:  0;  F:  1; eiA:     223 ),
    (D: 0;  M:  1;  Mp: -2;  F: -1; eiA:    -220 ),
    (D: 2;  M:  1;  Mp: -1;  F: -1; eiA:    -220 ),
    (D: 1;  M:  0;  Mp:  1;  F:  1; eiA:    -185 ),
    (D: 2;  M: -1;  Mp: -2;  F: -1; eiA:     181 ),
    (D: 0;  M:  1;  Mp:  2;  F:  1; eiA:    -177 ),
    (D: 4;  M:  0;  Mp: -2;  F: -1; eiA:     176 ),
    (D: 4;  M: -1;  Mp: -1;  F: -1; eiA:     166 ),
    (D: 1;  M:  0;  Mp:  1;  F: -1; eiA:    -164 ),
    (D: 4;  M:  0;  Mp:  1;  F: -1; eiA:     132 ),
    (D: 1;  M:  0;  Mp: -1;  F: -1; eiA:    -119 ),
    (D: 4;  M: -1;  Mp:  0;  F: -1; eiA:     115 ),
    (D: 2;  M: -2;  Mp:  0;  F:  1; eiA:     107 ));
implementation

end.
