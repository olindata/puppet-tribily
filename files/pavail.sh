#!/bin/bash

{
read mtot
read mfree
} < /proc/meminfo

afree=${mfree%kB}
afree=${afree/*:}
atot=${mtot%kB}
atot=${atot/*:}

echo $(( $afree * 100 / $atot ))
