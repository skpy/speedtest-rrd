#!/bin/bash
RRD=$1
GRAPHDIR=$2
TZ='America/New_York'
export TZ
PARAMS_ARRAY=("-s e-1w" "-s e-1m" "-s e-1y")
TOKEN_ARRAY=("week" "month" "year")

function usage {
  echo "speedtest-graph.sh RRD GRAPHDIR"
  echo "  RRD is the full path to the rrd file"
  echo "  GRAPHDIR is the directory into which graphs will be saved"
  echo
}
  
if [ -z "${RRD}" ]; then
  usage
  exit 1
fi
if [ -z "${GRAPHDIR}" ]; then
  usage
  exit 1
fi

# speedtest first
rrdtool graph ${GRAPHDIR}/speedtest.png -J -a PNG --title="speedtest" --vertical-label "Mb/s" -- \
  DEF:P=${RRD}:PING:AVERAGE \
  DEF:PMIN=${RRD}:PING:MIN \
  DEF:PMAX=${RRD}:PING:MAX \
  DEF:D=${RRD}:DOWN:AVERAGE \
  DEF:DMIN=${RRD}:DOWN:MIN \
  DEF:DMAX=${RRD}:DOWN:MAX \
  DEF:U=${RRD}:UP:AVERAGE \
  DEF:UMIN=${RRD}:UP:MIN \
  DEF:UMAX=${RRD}:UP:MAX \
  AREA:D#006600:Download \
  AREA:U#0000ff:Upload \
  LINE1:P#ff0000:"Ping (ms)\n" \
  GPRINT:P:LAST:"Last Ping\: %2.1lf ms\n" \
  GPRINT:D:LAST:"Last Download\: %2.1lf Mb/s\n" \
  GPRINT:U:LAST:"Last Upload\: %2.1lf Mb/s\n" > /dev/null 2>&1

for N in {0..2}; do
  rrdtool graph ${GRAPHDIR}/speedtest-${TOKEN_ARRAY[$N]}.png \
    -a PNG --title="Speedtest: Last ${TOKEN_ARRAY[$N]}" \
    --vertical-label "Mb/s" \
    ${PARAMS_ARRAY[$N]} \
    DEF:D=${RRD}:DOWN:AVERAGE \
    DEF:DMIN=${RRD}:DOWN:MIN \
    DEF:DMAX=${RRD}:DOWN:MAX \
    DEF:U=${RRD}:UP:AVERAGE \
    DEF:UMIN=${RRD}:UP:MIN \
    DEF:UMAX=${RRD}:UP:MAX \
    AREA:D#006600:Download \
    AREA:U#0000ff:Upload > /dev/null 2>&1
done
